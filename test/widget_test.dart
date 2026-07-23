// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sokopop_flutter_app/main.dart';
import 'package:sokopop_flutter_app/features/auth/presentation/screens/splash_screen.dart';

// Root widget name in this project is SokopopApp (not MyApp).

void main() {
  testWidgets('App smoke test (renders without errors)', (WidgetTester tester) async {
    await tester.pumpWidget(const SokopopApp());
    // Splash screen should be the initial route.
    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
