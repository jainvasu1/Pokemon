import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon_app/main.dart';

void main() {
  testWidgets('shows the Pokédex home screen', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Pokédex'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Search name or number'), findsOneWidget);
  });
}
