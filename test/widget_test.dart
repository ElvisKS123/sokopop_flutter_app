import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sokopop_flutter_app/main.dart';
import 'package:sokopop_flutter_app/screens/splash_screen.dart';

void main() {
  testWidgets('Sokopop app shows the splash screen on launch', (tester) async {
    await tester.pumpWidget(const SokopopApp());
    await tester.pump();

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text('SOKOPOP'), findsOneWidget);
  });

  testWidgets('Splash screen exposes the main onboarding actions', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));

    expect(find.text('Get started'), findsOneWidget);
    expect(find.text('I already have an account'), findsOneWidget);
  });
}
