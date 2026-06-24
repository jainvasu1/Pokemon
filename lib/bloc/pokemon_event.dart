abstract class PokemonEvent {}

//  Initial load
class FetchPokemon extends PokemonEvent {}

//Pagination
class FetchMorePokemon extends PokemonEvent {}

class SearchPokemon extends PokemonEvent {
  final String query;

  SearchPokemon(this.query);
}

class FilterPokemonByType extends PokemonEvent {
  final String query;

  FilterPokemonByType(this.query);

  String? get type => null;
}
