import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokemon_app/main.dart';

void main() {
  testWidgets('shows splash screen and opens home screen', (tester) async {
    await tester.pumpWidget(const PokemonApp());

    expect(find.byType(Image), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to the Pokémon app!'), findsOneWidget);
  });
}
