import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class PokemonEvent {
  const PokemonEvent();
}

class FetchPokemon extends PokemonEvent {
  const FetchPokemon();
}

class FetchMorePokemon extends PokemonEvent {
  const FetchMorePokemon();
}

class SearchPokemon extends PokemonEvent {
  final String query;
  const SearchPokemon(this.query);
}

class FilterPokemonByType extends Pokemon {
  final String query;
  const FilterPokemonByType(this.query);
}
