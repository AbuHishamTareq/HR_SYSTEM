import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:driver_app/main.dart';

void main() {
  testWidgets('App renders', (WidgetTester tester) async {
    // Mock SharedPreferences so Riverpod providers don't throw MissingPluginException
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      const ProviderScope(
        child: DriverApp(),
      ),
    );

    // Pump one frame — the widget tree should render immediately
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
