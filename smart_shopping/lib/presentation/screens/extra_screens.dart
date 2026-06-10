import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/state/shopping_state.dart';
import '../../domain/state/language_provider.dart';
import '../../data/models/user_profile.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final state = Provider.of<ShoppingState>(context);
    final theme = Theme.of(context);
    final profile = state.userProfile;

    return Scaffold(
      appBar: AppBar(title: Text(lang.translate('settings_title'))),
      body: ListView(
        children: [
          // Notification setting
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text(lang.translate('notifications')),
            trailing: Switch(
              activeColor: theme.primaryColor,
              value: profile?.notificationsEnabled ?? true,
              onChanged: (v) {
                if (profile != null) {
                  state.updateProfile(profile.copyWith(notificationsEnabled: v));
                }
              },
            ),
          ),
          
          // Language setting
          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(lang.translate('language')),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  lang.currentLanguage == 'tr' ? 'Türkçe' : 'English',
                  style: const TextStyle(color: Colors.grey),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
            onTap: () => _showLanguageSelector(context, lang),
          ),
          
          const Divider(),

          // Clear Data button
          ListTile(
            leading: const Icon(Icons.delete_forever_outlined, color: Colors.red),
            title: Text(
              lang.translate('clear_data'),
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () => _showClearDataConfirmation(context, state, lang),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelector(BuildContext context, LanguageProvider lang) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  lang.translate('language'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                title: const Text('Türkçe'),
                trailing: lang.currentLanguage == 'tr' ? Icon(Icons.check, color: Theme.of(context).primaryColor) : null,
                onTap: () {
                  lang.setLanguage('tr');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('English'),
                trailing: lang.currentLanguage == 'en' ? Icon(Icons.check, color: Theme.of(context).primaryColor) : null,
                onTap: () {
                  lang.setLanguage('en');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showClearDataConfirmation(BuildContext context, ShoppingState state, LanguageProvider lang) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lang.translate('clear_data')),
        content: Text(lang.currentLanguage == 'tr'
            ? 'Tüm alışveriş listeleriniz ve ekli ürünler silinecektir. Emin misiniz?'
            : 'All your shopping lists and added products will be deleted. Are you sure?'),
        actions: [
          TextButton(
            child: Text(lang.translate('cancel')),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(lang.translate('clear_data'), style: const TextStyle(color: Colors.red)),
            onPressed: () async {
              await state.clearAllData();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(lang.translate('clear_data_success'))),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final state = Provider.of<ShoppingState>(context);
    final profile = state.userProfile;
    final theme = Theme.of(context);

    final name = profile?.name ?? 'Akıllı Kullanıcı';
    final email = profile?.email ?? 'user@smartshopping.com';

    return Scaffold(
      appBar: AppBar(title: Text(lang.translate('profile_title'))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            children: [
              Center(
                child: Hero(
                  tag: 'profile_avatar',
                  child: Container(
                    height: 110,
                    width: 110,
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.primaryColor, width: 3),
                    ),
                    child: Icon(Icons.person, size: 65, color: theme.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              Text(
                name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                email,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              
              const SizedBox(height: 48),
              
              ElevatedButton.icon(
                onPressed: () => _showEditProfileDialog(context, state, lang, profile),
                icon: const Icon(Icons.edit, color: Colors.white),
                label: Text(
                  lang.translate('edit_profile'),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () async {
                  await state.logoutUser();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
                icon: const Icon(Icons.exit_to_app, color: Colors.red),
                label: Text(
                  lang.translate('logout'),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog(
      BuildContext context, ShoppingState state, LanguageProvider lang, UserProfile? profile) {
    final nameController = TextEditingController(text: profile?.name);
    final emailController = TextEditingController(text: profile?.email);
    final passwordController = TextEditingController(text: profile?.password);

    showDialog(
      context: context,
      builder: (context) {
        final dialogTheme = Theme.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(lang.translate('edit_profile')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: lang.translate('name'),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: lang.translate('email'),
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: lang.translate('password'),
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(lang.translate('cancel')),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(lang.translate('save'), style: TextStyle(color: dialogTheme.primaryColor, fontWeight: FontWeight.bold)),
              onPressed: () async {
                if (profile != null) {
                  final updated = profile.copyWith(
                    name: nameController.text.trim(),
                    email: emailController.text.trim(),
                    password: passwordController.text,
                  );
                  await state.updateProfile(updated);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
