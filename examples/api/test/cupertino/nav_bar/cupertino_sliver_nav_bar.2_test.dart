// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter_api_samples/cupertino/nav_bar/cupertino_sliver_nav_bar.2.dart' as example;
import 'package:flutter_test/flutter_test.dart';

const Offset dragUp = Offset(0.0, -150.0);

void setWindowToPortrait(WidgetTester tester, {Size size = const Size(2400.0, 3000.0)}) {
  tester.view.physicalSize = size;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('CupertinoSliverNavigationBar bottom widget', (WidgetTester tester) async {
    setWindowToPortrait(tester);
    await tester.pumpWidget(const example.SliverNavBarApp());

    final Finder preferredSize = find.byType(PreferredSize);
    final Finder coloredBox = find.descendant(of: preferredSize, matching: find.byType(ColoredBox));
    final Finder text = find.text('Bottom Widget');

    expect(preferredSize, findsOneWidget);
    expect(coloredBox, findsOneWidget);
    expect(text, findsOneWidget);
  });

  testWidgets('Collapse and expand CupertinoSliverNavigationBar changes title position', (
    WidgetTester tester,
  ) async {
    setWindowToPortrait(tester);
    await tester.pumpWidget(const example.SliverNavBarApp());

    // Large title is visible and at lower position.
    expect(tester.getBottomLeft(find.text('Contacts').first).dy, 88.0);
    await tester.fling(find.text('Drag me up'), dragUp, 500.0);
    await tester.pumpAndSettle();

    // Large title is hidden and at higher position.
    expect(
      tester.getBottomLeft(find.text('Contacts').first).dy,
      36.0 + 8.0,
    ); // Static part + _kNavBarBottomPadding.
  });

  testWidgets('Middle widget is visible in both collapsed and expanded states', (
    WidgetTester tester,
  ) async {
    setWindowToPortrait(tester);
    await tester.pumpWidget(const example.SliverNavBarApp());

    // Navigate to a page that has both middle and large titles.
    final Finder nextButton = find.text('Go to Next Page');
    expect(nextButton, findsOneWidget);
    await tester.tap(nextButton);
    await tester.pumpAndSettle();

    // Both middle and large titles are visible.
    expect(tester.getBottomLeft(find.text('Contacts Group').first).dy, 30.5);
    expect(tester.getBottomLeft(find.text('Family').first).dy, 88.0);

    await tester.fling(find.text('Drag me up'), dragUp, 500.0);
    await tester.pumpAndSettle();

    // Large title is hidden and middle title is visible.
    expect(tester.getBottomLeft(find.text('Contacts Group').first).dy, 30.5);
    expect(
      tester.getBottomLeft(find.text('Family').first).dy,
      36.0 + 8.0,
    ); // Static part + _kNavBarBottomPadding.
  });

  testWidgets('CupertinoSliverNavigationBar with previous route has back button', (
    WidgetTester tester,
  ) async {
    setWindowToPortrait(tester);
    await tester.pumpWidget(const example.SliverNavBarApp());

    // Navigate to a page that has a back button.
    final Finder nextButton = find.text('Go to Next Page');
    expect(nextButton, findsOneWidget);
    await tester.tap(nextButton);
    await tester.pumpAndSettle();
    expect(nextButton, findsNothing);

    // Go back to the previous page.
    final Finder backButton = find.byType(CupertinoButton);
    expect(backButton, findsOneWidget);
    await tester.tap(backButton);
    await tester.pumpAndSettle();
    expect(nextButton, findsOneWidget);
  });
}
