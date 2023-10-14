// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:f_web_authentication/ui/pages/content/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WelcomePage());
    await tester.pump();
    // Verify that our counter starts at 0.
    expect(find.byKey(const Key("playButton")), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byKey(const Key('playButton')));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('Score: 0'), findsOneWidget);
  });
}

class SignUpPage {}
