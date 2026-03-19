import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mealtime/app.dart';

void main() {
  testWidgets('Login succeeds with env credentials', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 500));

    final Finder accountInput = find.byType(TextField).at(0);
    final Finder passwordInput = find.byType(TextField).at(1);

    await tester.enterText(accountInput, 'admin');
    await tester.enterText(passwordInput, '1230');

    await tester.tap(find.byKey(const ValueKey<String>('loginButton')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('欢迎回来，admin'), findsOneWidget);
  });
}
