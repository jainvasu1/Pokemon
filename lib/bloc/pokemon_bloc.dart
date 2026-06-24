import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/pokemon_service.dart';
import 'pokemon_event.dart';
import 'pokemon_state.dart';
import '../models/pokemon.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final PokemonService service; //Stores a reference to the API service.

  PokemonBloc(this.service) : super(const PokemonState()) {
    //here this.service => Assigns the passed service to the local variable. and super(()) => Sets the initial state.
    on<FetchPokemon>(_onFetchPokemon);
    on<FetchMorePokemon>(_onFetchMorePokemon);
    on<SearchPokemon>(_onSearchPokemon);
    on<FilterPokemonByType>(_onFilterByType);

    // Auto load when app starts
    add(FetchPokemon());
  }

  // Initial trigger
  Future<void> _onFetchPokemon(
    //Handles the initial fetch request.
    FetchPokemon event, //Contains event data.
    Emitter<PokemonState>
        emit, // emit() means we can push the multiple state in a single function call.
  ) async {
    add(FetchMorePokemon()); //Instead of fetching directly, it triggers the pagination event.
  }

  // Pagination + API call
  //Runs whenever more Pokémon need to be loaded.
  Future<void> _onFetchMorePokemon(
    FetchMorePokemon event, //Contains event data.
    Emitter<PokemonState> emit,
  ) async {
    //async isliye lagaya hai kyunki API call ko wait(Await) krna hai
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true));

    try {
      final List<Pokemon> newPokemon = await service.fetchPokemon(state.offset);

      emit(
        state.copyWith(
          pokemonList: [
            ...state.pokemonList,
            ...newPokemon,
          ],
          offset: state.offset + 10,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  // Search update
  void _onSearchPokemon(
    SearchPokemon event,
    Emitter<PokemonState> emit,
  ) {
    emit(
      state.copyWith(
        searchQuery: event.query,
      ),
    );
  }

  // Filter update
  void _onFilterByType(
    FilterPokemonByType event,
    Emitter<PokemonState> emit,
  ) {
    emit(
      state.copyWith(
        selectedType: event.type,
      ),
    );
  }
}
