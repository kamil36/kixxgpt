import 'package:flutter/material.dart';

class KixxGPTConstants {
  // Branding
  static const String appName = 'KixxGPT';
  static const String welcomeMessage =
      'Hello! I\'m KixxGPT, your AI assistant. How can I help you today?';

  // Colors
  static const Color primaryColor = Color(0xFF10A37F);
  static const Color accentColor = Color(0xFFFFB744);
  static const Color errorColor = Color(0xFFFF6B6B);

  // Messages
  static const String thinkingMessage = 'KixxGPT is thinking...';
  static const String errorMessage =
      'Sorry, something went wrong. Please try again.';
  static const String clearChatTitle = 'Clear Chat';
  static const String clearChatMessage =
      'Are you sure you want to clear the chat history?';

  // Durations
  static const Duration messageSendDelay = Duration(
    seconds: 1,
    milliseconds: 500,
  );
  static const Duration scrollAnimationDuration = Duration(milliseconds: 300);
  static const Duration typingDelay = Duration(milliseconds: 20);
}
