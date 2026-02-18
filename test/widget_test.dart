// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kixxgpt/main.dart';

void main() {
  testWidgets('KixxGPT app loads with home screen', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const KixxGPTApp());

    // Verify the app title is displayed.
    expect(find.text('KixxGPT'), findsWidgets);

    // Verify the home screen main question is displayed.
    expect(find.text('What can I help with?'), findsOneWidget);

    // Verify suggestion buttons are present.
    expect(find.text('Create image'), findsOneWidget);
    expect(find.text('Analyze images'), findsOneWidget);
    expect(find.text('Help me write'), findsOneWidget);
    expect(find.text('Summarize text'), findsOneWidget);

    // Verify the drawer button is present.
    expect(find.byIcon(Icons.menu), findsOneWidget);
  });
}
