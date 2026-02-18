import 'package:flutter/material.dart';
import 'package:kixxgpt/pages/main_page.dart';
import 'pages/home_page.dart';
import 'pages/chat_page_widget.dart';
import 'pages/settings_page.dart';
import 'widgets/app_drawer.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/quick_action_menu.dart';
import 'services/document_manager.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'models/message.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const KixxGPTApp());
}

class KixxGPTApp extends StatelessWidget {
  const KixxGPTApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KixxGPT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF10A37F),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Segoe UI',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF10A37F),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Segoe UI',
      ),
      home: const MainAppPage(),
    );
  }
}

