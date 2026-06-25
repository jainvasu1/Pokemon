import 'package:equatable/equatable.dart';
import '../models/pokemon.dart'; //Imports the Pokemon model so we can store Pokémon data in our state.

abstract class PokemonState extends Equatable {
  const PokemonState();

  @override
  List<Object?> get props => [];
}

class PokemonLoading extends PokemonState {
  const PokemonLoading();
}

class PokemonError extends PokemonState {
  final String message;

  const PokemonError(this.message);

  @override
  List<Object?> get props => [message];
}

class PokemonLoaded extends PokemonState {
  // pokemonState tells about current condition or state of app.(loading, error ya loaded)
  final List<Pokemon>
      pokemonList; //pokemonloaded manages logic of  pokemon data of search, filter and pagination
  final bool isLoading;
  final int offset;
  final String searchQuery;
  final String selectedType;

  const PokemonLoaded({
    this.pokemonList = const [],
    this.isLoading = false,
    this.offset = 0,
    this.searchQuery = '',
    this.selectedType = 'All',
  });

  @override
  List<Object?> get props => [
        pokemonList,
        isLoading,
        offset,
        searchQuery,
        selectedType,
      ];
}

//import the model so we can store the pokemondata in our stae.
//using equatable for comparing object based on their content(easy to comparison).
//pokemon state mai getter use kiya for get the values in pokemonstate
//pokemonloading, pokemonerror and pokemonloaded  these all are state
//pokemonstate tells about current condition and there pokemonloaded manages the logic of pokemon data of searching, pagination, filter etc
// now in pokemonloaded class we inject the parameters
//list<pokeomon> get filterpokemon jo hai vo searching or filtering ka logic manage krta hai matchestype or matchessearch ki value ki condition dekh rha hai
// now pokemonloaded copywith mai hum specific filed ke data ko update kr rhe hai
// now we use null coalescing operator for checking which value is null
// get props mai yaha hum parameters de rhe ahi jisse equatable easy to compare kr paaye unko.
