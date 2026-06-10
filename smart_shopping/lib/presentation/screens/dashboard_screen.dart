import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/state/shopping_state.dart';
import '../../domain/state/theme_state.dart';
import '../../domain/state/language_provider.dart';
import '../widgets/shopping_list_card.dart';
import 'checklist_screen.dart';
import 'stats_screen.dart';
import 'favorites_screen.dart';
import 'extra_screens.dart';
import 'login_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.translate('app_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.pie_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StatsScreen()),
              );
            },
          ),
          Consumer<ThemeState>(
            builder: (context, themeState, child) {
              return IconButton(
                icon: Icon(themeState.isDarkMode ? Icons.light_mode : Icons.dark_mode),
                onPressed: () {
                  themeState.toggleTheme();
                },
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: theme.primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    lang.translate('menu'),
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(lang.translate('profile_title')),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: Text(lang.translate('favorites_title')),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(lang.translate('settings_title')),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: Text(
                lang.translate('logout'),
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                Navigator.pop(context);
                await Provider.of<ShoppingState>(context, listen: false).logoutUser();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: Consumer<ShoppingState>(
        builder: (context, state, child) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final lists = state.shoppingLists;
          final completedCount = lists.where((l) => l.isCompleted).length;

          return Column(
            children: [
              _buildSummaryPanel(context, lists.length, completedCount, lang),
              Expanded(
                child: lists.isEmpty
                    ? _buildEmptyState(context, lang)
                    : ListView.builder(
                        itemCount: lists.length,
                        itemBuilder: (context, index) {
                          final list = lists[index];
                          return ShoppingListCard(
                            shoppingList: list,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ChecklistScreen(shoppingList: list),
                                ),
                              );
                            },
                            onDelete: () {
                              _confirmDelete(context, state, list.id!, lang);
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddListDialog(context, lang),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryPanel(BuildContext context, int total, int completed, LanguageProvider lang) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatColumn(context, lang.translate('total_lists'), total.toString()),
          _buildStatColumn(context, lang.translate('completed'), completed.toString()),
          _buildStatColumn(context, lang.translate('active'), (total - completed).toString()),
        ],
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, LanguageProvider lang) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_basket_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            lang.translate('no_lists'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showAddListDialog(BuildContext context, LanguageProvider lang) {
    final titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(lang.translate('new_list_title')),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: lang.translate('new_list_label'),
              border: const OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(lang.translate('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  Provider.of<ShoppingState>(context, listen: false)
                      .createShoppingList(titleController.text);
                  Navigator.pop(context);
                }
              },
              child: Text(lang.translate('create')),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, ShoppingState state, int id, LanguageProvider lang) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(lang.translate('delete_confirm_title')),
          content: Text(lang.translate('delete_confirm_desc')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(lang.translate('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                state.deleteShoppingList(id);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(
                lang.translate('delete'),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
