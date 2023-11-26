// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/auth-provider.dart';
import 'package:flutter_application_1/observer/AuthRouteObserver.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/firebase_options.dart';

void main() {
  setUpAll(() async {
    // Initialize Firebase before running the test
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  });
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    auth_provider authProvider = auth_provider();
    AuthRouteObserver authRouteObserver = AuthRouteObserver(authProvider);
    await tester.pumpWidget(MyApp(authProvider: authProvider,
      authRouteObserver: authRouteObserver,));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
