import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/state/shopping_state.dart';
import '../../domain/state/language_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(lang.translate('favorites_title'))),
      body: Consumer<ShoppingState>(
        builder: (context, state, child) {
          final products = state.products;
          
          if (products.isEmpty) {
            return Center(child: Text(lang.translate('no_data')));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: const Icon(Icons.star, color: Colors.orange),
                title: Text(lang.translateProduct(product.name)),
                subtitle: Text('₺${product.defaultPrice.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    // Quick add logic would go here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${lang.translateProduct(product.name)} ${lang.currentLanguage == 'tr' ? 'aktif listeye eklendi (Demo).' : 'added to active list (Demo).'}')),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
