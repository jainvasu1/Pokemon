import 'package:pokemon_app/bloc/pokemon_state.dart';
import 'package:pokemon_app/models/pokemon.dart';

extension PokemonLoadedX on PokemonLoaded {
  Future<PokemonLoaded> copyWith({
    List<Pokemon>? pokemonList,
    bool? isLoading,
    int? offset,
    String? searchQuery,
    String? selectedType,
  }) async {
    return PokemonLoaded(
      pokemonList: pokemonList ?? this.pokemonList,
      isLoading: isLoading ?? this.isLoading,
      offset: offset ?? this.offset,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedType: selectedType ?? this.selectedType,
    );
  }
}
