import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0d0d0d),
    primaryColor: const Color(0xFF1DB584),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1a1a1a),
      elevation: 0,
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF1a1a1a)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    primaryColor: const Color(0xFF1DB584),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: TextStyle(
        color: Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
      titleMedium: TextStyle(color: Colors.black87),
    ),
    cardColor: Colors.white,
    dividerColor: const Color(0xFFE0E0E0),
  );
}
