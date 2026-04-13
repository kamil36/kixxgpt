import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/chat_dashboard_page.dart';
import 'pages/login_page.dart';
import 'providers/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeProvider themeProvider = ThemeProvider();
  bool _isLoggedIn = false;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final username = prefs.getString('username') ?? '';

    setState(() {
      _isLoggedIn = isLoggedIn;
      _username = username;
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('username');

    setState(() {
      _isLoggedIn = false;
      _username = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => themeProvider,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeProvider.currentTheme,
            home: _isLoggedIn && _username.isNotEmpty
                ? ChatDashboard(username: _username, onLogout: _logout)
                : const LoginPage(),
          );
        },
      ),
    );
  }
}
