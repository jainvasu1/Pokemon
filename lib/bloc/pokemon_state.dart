import 'package:equatable/equatable.dart';
import '../models/pokemon.dart';

class PokemonState extends Equatable {
  final List<Pokemon> pokemonList;
  final bool isLoading;
  final int offset;
  final String searchQuery;
  final String selectedType;

  const PokemonState({
    this.pokemonList = const [],
    this.isLoading = false,
    this.offset = 0,
    this.searchQuery = '',
    this.selectedType = 'All',
  });

  List<Pokemon> get filteredPokemon {
    final query = searchQuery.trim().toLowerCase();

    return pokemonList.where((pokemon) {
      final matchesSearch =
          query.isEmpty ||
          pokemon.name.toLowerCase().contains(query) ||
          pokemon.id.toString() == query;

      final matchesType =
          selectedType == 'All' ||
          pokemon.types.contains(selectedType);

      return matchesSearch && matchesType;
    }).toList();
  }

  PokemonState copyWith({
    List<Pokemon>? pokemonList,
    bool? isLoading,
    int? offset,
    String? searchQuery,
    String? selectedType,
  }) {
    return PokemonState(
      pokemonList: pokemonList ?? this.pokemonList,
      isLoading: isLoading ?? this.isLoading,
      offset: offset ?? this.offset,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedType: selectedType ?? this.selectedType,
    );
  }

  @override
  List<Object?> get props => [
        pokemonList,
        isLoading,
        offset,
        searchQuery,
        selectedType,
      ];
}