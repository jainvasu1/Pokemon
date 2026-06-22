import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon_app/main.dart';

void main() {
  testWidgets('shows the splash screen on launch', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(Image), findsOneWidget);
  });
}
