import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/state/shopping_state.dart';
import '../../domain/state/language_provider.dart';
import '../../data/models/product.dart';
import '../../data/models/category.dart';
import '../../data/models/list_item.dart';

class FormScreen extends StatefulWidget {
  final int listId;

  const FormScreen({Key? key, required this.listId}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  Category? _selectedCategory;
  Product? _selectedProduct;
  final TextEditingController _priceController = TextEditingController();
  int _quantity = 1;

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(lang.translate('add_product'))),
      body: Consumer<ShoppingState>(
        builder: (context, state, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCategorySelector(context, state, lang),
                const SizedBox(height: 16),
                if (_selectedCategory != null) ...[
                  _buildProductDropdown(state, lang),
                  const SizedBox(height: 16),
                ],
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: lang.translate('price'),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    _buildQuantitySelector(),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => _saveItem(state, lang),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(lang.translate('list_add_btn'), style: const TextStyle(fontSize: 18)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategorySelector(BuildContext context, ShoppingState state, LanguageProvider lang) {
    final titleText = _selectedCategory != null
        ? lang.translateCategory(_selectedCategory!.name)
        : lang.translate('select_category');

    return InkWell(
      onTap: () {
        _showCategoryBottomSheet(context, state.categories, lang);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: lang.translate('select_category'),
          border: const OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(titleText, style: const TextStyle(fontSize: 16)),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _showCategoryBottomSheet(BuildContext context, List<Category> categories, LanguageProvider lang) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return ListTile(
              leading: Icon(Icons.category, color: Theme.of(context).primaryColor),
              title: Text(lang.translateCategory(cat.name)),
              onTap: () {
                setState(() {
                  _selectedCategory = cat;
                  _selectedProduct = null; // Reset product when category changes
                  _priceController.text = '';
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildProductDropdown(ShoppingState state, LanguageProvider lang) {
    final availableProducts = state.products.where((p) => p.categoryId == _selectedCategory?.id).toList();

    return DropdownButtonFormField<Product>(
      decoration: InputDecoration(
        labelText: lang.translate('product_select'),
        border: const OutlineInputBorder(),
      ),
      value: _selectedProduct,
      items: availableProducts.map((p) {
        return DropdownMenuItem<Product>(
          value: p,
          child: Text(lang.translateProduct(p.name)),
        );
      }).toList(),
      onChanged: (Product? val) {
        setState(() {
          _selectedProduct = val;
          _priceController.text = val?.defaultPrice.toString() ?? '0.0';
        });
      },
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle),
          color: Theme.of(context).primaryColor,
          iconSize: 32,
          onPressed: () {
            if (_quantity > 1) setState(() => _quantity--);
          },
        ),
        Text('$_quantity', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        IconButton(
          icon: const Icon(Icons.add_circle),
          color: Theme.of(context).primaryColor,
          iconSize: 32,
          onPressed: () => setState(() => _quantity++),
        ),
      ],
    );
  }

  Future<void> _saveItem(ShoppingState state, LanguageProvider lang) async {
    if (_selectedCategory == null || _selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang.translate('form_error_select'))),
      );
      return;
    }

    final priceStr = _priceController.text.trim();
    double price = double.tryParse(priceStr) ?? 0.0;

    final listItem = ListItem(
      listId: widget.listId,
      productId: _selectedProduct!.id!,
      price: price,
      quantity: _quantity,
    );

    await state.addListItem(listItem);
    if (mounted) Navigator.pop(context);
  }
}
