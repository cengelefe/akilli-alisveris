import 'package:flutter/material.dart';

class AppTheme {
  // Light Theme Colors
  static const Color lightPrimary = Color(0xFF2E7D32); // Green
  static const Color lightBackground = Color(0xFFF5F5F5); // Light Gray
  static const Color lightCard = Colors.white;
  static const Color lightText = Color(0xFF212121);
  static const Color lightTextSecondary = Color(0xFF757575);

  // Dark Theme Colors
  static const Color darkPrimary = Color(0xFF66BB6A); // Light Green
  static const Color darkBackground = Color(0xFF121212); // Dark
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkText = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFF9E9E9E);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: lightPrimary,
      scaffoldBackgroundColor: lightBackground,
      cardColor: lightCard,
      appBarTheme: const AppBarTheme(
        backgroundColor: lightPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      colorScheme: ColorScheme.light(
        primary: lightPrimary,
        secondary: lightPrimary.withOpacity(0.8),
        background: lightBackground,
        surface: lightCard,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: lightText),
        bodyMedium: TextStyle(color: lightTextSecondary),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: lightPrimary,
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: darkPrimary,
      scaffoldBackgroundColor: darkBackground,
      cardColor: darkCard,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkCard,
        foregroundColor: darkText,
        elevation: 0,
      ),
      colorScheme: ColorScheme.dark(
        primary: darkPrimary,
        secondary: darkPrimary.withOpacity(0.8),
        background: darkBackground,
        surface: darkCard,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: darkText),
        bodyMedium: TextStyle(color: darkTextSecondary),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: darkPrimary,
        foregroundColor: Colors.black,
      ),
    );
  }
}
