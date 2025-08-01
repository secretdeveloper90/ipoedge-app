// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ipo_edge/main.dart';

void main() {
  testWidgets('IPO Edge app loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const IPOEdgeApp());

    // Wait for the app to load
    await tester.pumpAndSettle();

    // Verify that the app title is displayed
    expect(find.text('IPO Edge'), findsOneWidget);

    // Verify that the bottom navigation is present
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Verify that navigation items are present in bottom navigation
    final bottomNavBar = find.byType(BottomNavigationBar);
    expect(bottomNavBar, findsOneWidget);

    expect(find.descendant(of: bottomNavBar, matching: find.text('All IPOs')),
        findsOneWidget);
    expect(find.descendant(of: bottomNavBar, matching: find.text('Mainboard')),
        findsOneWidget);
    expect(find.descendant(of: bottomNavBar, matching: find.text('SME')),
        findsOneWidget);
    expect(find.descendant(of: bottomNavBar, matching: find.text('Search')),
        findsOneWidget);
    expect(find.descendant(of: bottomNavBar, matching: find.text('Profile')),
        findsOneWidget);
  });

  testWidgets('Navigation between tabs works', (WidgetTester tester) async {
    await tester.pumpWidget(const IPOEdgeApp());
    await tester.pumpAndSettle();

    // Find the bottom navigation bar and tap on specific items
    final bottomNavBar = find.byType(BottomNavigationBar);
    expect(bottomNavBar, findsOneWidget);

    // Tap on Mainboard tab (index 1)
    await tester.tap(find
        .descendant(
          of: bottomNavBar,
          matching: find.text('Mainboard'),
        )
        .first);
    await tester.pumpAndSettle();

    // Verify Mainboard screen is displayed
    expect(find.text('Mainboard IPOs'), findsOneWidget);

    // Tap on SME tab (index 2)
    await tester.tap(find
        .descendant(
          of: bottomNavBar,
          matching: find.text('SME'),
        )
        .first);
    await tester.pumpAndSettle();

    // Verify SME screen is displayed
    expect(find.text('SME IPOs'), findsOneWidget);

    // Tap on Search tab (index 3)
    await tester.tap(find
        .descendant(
          of: bottomNavBar,
          matching: find.text('Search'),
        )
        .first);
    await tester.pumpAndSettle();

    // Verify Search screen is displayed
    expect(find.text('Search IPOs'), findsOneWidget);
  });
}
