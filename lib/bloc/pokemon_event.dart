import 'package:equatable/equatable.dart';

abstract class PokemonEvent extends Equatable {
  const PokemonEvent();

  @override
  List<Object?> get props => [];
}

class FetchPokemon extends PokemonEvent {
  const FetchPokemon();
}
//Equatable compares objects using their properties (values) instead of memory addresses.

class FetchMorePokemon extends PokemonEvent {
  const FetchMorePokemon();
}

class SearchPokemon extends PokemonEvent {
  final String query;
  const SearchPokemon(this.query);

  @override
  List<Object?> get props => [
        query
      ]; //props tells Equatable which fields should be used for comparison.
}

class FilterPokemonByType extends PokemonEvent {
  final String type;
  const FilterPokemonByType(this.type);

  @override
  List<Object?> get props => [type];
}
