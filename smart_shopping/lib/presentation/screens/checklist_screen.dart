import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/state/shopping_state.dart';
import '../../data/models/shopping_list.dart';
import '../../data/models/list_item.dart';
import '../../data/models/product.dart';
import '../../data/models/category.dart';
import 'form_screen.dart';
import '../../domain/state/language_provider.dart';

class ChecklistScreen extends StatefulWidget {
  final ShoppingList shoppingList;

  const ChecklistScreen({Key? key, required this.shoppingList}) : super(key: key);

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShoppingState>(context, listen: false)
          .loadItemsForList(widget.shoppingList.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shoppingList.title),
        actions: [
          Consumer<ShoppingState>(
            builder: (context, state, child) {
              return IconButton(
                icon: Icon(widget.shoppingList.isCompleted
                    ? Icons.check_circle
                    : Icons.check_circle_outline),
                onPressed: () {
                  state.toggleListCompletion(widget.shoppingList);
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<ShoppingState>(
        builder: (context, state, child) {
          final items = state.currentListItems.where((i) => i.listId == widget.shoppingList.id).toList();
          final products = state.products;
          final categories = state.categories;

          // Group by category for better UI
          Map<int, List<ListItem>> groupedItems = {};
          for (var item in items) {
            final prod = products.firstWhere((p) => p.id == item.productId,
                orElse: () => Product(name: 'Bilinmeyen', categoryId: 0));
            if (!groupedItems.containsKey(prod.categoryId)) {
              groupedItems[prod.categoryId] = [];
            }
            groupedItems[prod.categoryId]!.add(item);
          }

          return Column(
            children: [
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Text(
                          lang.translate('no_items_in_list'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        itemCount: groupedItems.keys.length,
                        itemBuilder: (context, index) {
                          final catId = groupedItems.keys.elementAt(index);
                          final catItems = groupedItems[catId]!;
                          final category = categories.firstWhere((c) => c.id == catId,
                              orElse: () => Category(name: 'Bilinmeyen', icon: 'unknown'));

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Text(
                                  lang.translateCategory(category.name).toUpperCase(),
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              ...catItems.map((item) {
                                final prod = products.firstWhere((p) => p.id == item.productId);
                                return Dismissible(
                                  key: ValueKey(item.id),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 16),
                                    child: const Icon(Icons.delete, color: Colors.white),
                                  ),
                                  onDismissed: (direction) {
                                    state.deleteListItem(item.id!, item.listId);
                                  },
                                  child: ListTile(
                                    leading: Checkbox(
                                      value: item.isChecked,
                                      onChanged: (val) {
                                        state.toggleItemCheck(item);
                                      },
                                    ),
                                    title: Text(
                                      lang.translateProduct(prod.name),
                                      style: TextStyle(
                                        decoration: item.isChecked
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                    ),
                                    subtitle: Text('₺${item.price.toStringAsFixed(2)} x ${item.quantity}'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove_circle_outline),
                                          onPressed: () {
                                            if (item.quantity > 1) {
                                              state.updateListItemQuantity(item, item.quantity - 1);
                                            }
                                          },
                                        ),
                                        Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                        IconButton(
                                          icon: const Icon(Icons.add_circle_outline),
                                          onPressed: () {
                                            state.updateListItemQuantity(item, item.quantity + 1);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ],
                          );
                        },
                      ),
              ),
              _buildBottomSummary(context, state, widget.shoppingList.id!, lang),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomSummary(BuildContext context, ShoppingState state, int listId, LanguageProvider lang) {
    final total = state.calculateTotalForList(listId);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  lang.translate('total_amount'),
                  style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  '₺${total.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FormScreen(listId: listId)),
                );
              },
              icon: const Icon(Icons.add, color: Colors.white, size: 20),
              label: Text(
                lang.translate('add_product'),
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
