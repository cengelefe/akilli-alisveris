import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'domain/state/shopping_state.dart';
import 'domain/state/theme_state.dart';
import 'domain/state/language_provider.dart';
import 'presentation/theme/app_theme.dart';
import 'presentation/screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeState()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ShoppingState()),
      ],
      child: const SmartShoppingApp(),
    ),
  );
}

class SmartShoppingApp extends StatelessWidget {
  const SmartShoppingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<ThemeState>(context);
    final lang = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      title: lang.translate('app_title'),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const LoginScreen(),
    );
  }
}
