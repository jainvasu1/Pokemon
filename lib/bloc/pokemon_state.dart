import '../models/pokemon.dart';

class PokemonState {
  final List<Pokemon> pokemonList;
  final bool isLoading;
  final int offset;
  final String searchQuery;
  final String selectedType;

  //provides initial state

  //prevents null errors

  // ensure ui always has safe values

  const PokemonState({
    this.pokemonList = const [],
    this.isLoading = false,
    this.offset = 0,
    this.searchQuery = '',
    this.selectedType = 'All',
  });

  List<Pokemon> get filteredPokemon {
    //why getter -> instead of storing filtered list we can calculate it whenever needed.
    final query = searchQuery
        .trim()
        .toLowerCase(); // here trim and lowercase using for ignoring spaces and case-insensitive search

    return pokemonList.where((pokemon) {
      //pokemonList.where (loop through all pokemon)
      final matchesSearch = //search condition
          query.isEmpty ||
              pokemon.name.toLowerCase().contains(query) ||
              pokemon.id.toString() == query;
      final matchesType =
          selectedType == 'All' || pokemon.types.contains(selectedType);

      return matchesSearch && matchesType; //must match both
    }).toList();
  }

  // in bloc, state is immutuable

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
}
