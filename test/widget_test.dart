import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_lab_guardian/main.dart';

void main() {
  testWidgets('App should build without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Verify that the app builds
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Bottom navigation should have 4 tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    
    // Look for bottom navigation bar
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    
    // Check for navigation items
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Alerts'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
