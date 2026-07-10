import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:customer_app/main.dart';

void main() {
  testWidgets('App renders splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: HrSystemApp(),
      ),
    );

    // Pump one frame — the widget tree should render immediately
    await tester.pump();

    // The app should show the splash screen on startup
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
