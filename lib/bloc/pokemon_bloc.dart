import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/bloc/pokemon_loaded_extension.dart';

import '../services/pokemon_service.dart';
import 'pokemon_event.dart';
import 'pokemon_state.dart';
import '../models/pokemon.dart';

//PokemonBloc is the main brain controller of this app

//PokemonEventt is the event which done by users abd pokemonState means that app or widget in which state.

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final PokemonService service; //Stores a reference to the API service.

  PokemonBloc(this.service) : super(const PokemonLoading()) {
    //initial state = loading
    //here this.service => Assigns the passed service to the local variable. and super(()) => Sets the initial state.

    on<FetchPokemon>(
        _onFetchPokemon); // every event contains one handler like FetchPokemon, FetchMorePokemon etc
    on<FetchMorePokemon>(_onFetchMore);
    on<SearchPokemon>(_onSearch);
    on<FilterPokemonByType>(_onFilter);

    // Auto load when app starts
    add(const FetchPokemon());
  }

  List<Pokemon> _applyFilters(
    //search + type filter apply krna
    List<Pokemon> list,
    String query,
    String type,
  ) {
    final q = query.trim().toLowerCase();

    return list.where((p) {
      final matchSearch =
          q.isEmpty || p.name.toLowerCase().contains(q) || p.id.toString() == q;

      final matchType = type == 'All' || p.types.contains(type);

      return matchSearch && matchType;
    }).toList();
  }

  Future<void> _onFetchPokemon(
    FetchPokemon event,
    Emitter<PokemonState> emit,
  ) async {
    emit(const PokemonLoading()); //ui shows loading

    try {
      final data = await service.fetchPokemon(0); //api call

      emit(
        PokemonLoaded(
          //data ui ko mil gya
          pokemonList: data,
          offset: 10,
        ),
      );
    } catch (e) {
      emit(PokemonError(e.toString()));
    }
  }

//This function handles the FetchMorePokemon event and updates the state using emit
  Future<void> _onFetchMore(
    FetchMorePokemon event,
    Emitter<PokemonState> emit,
  ) async {
    if (state is! PokemonLoaded) {
      return; //sirf loaded state mai hi pagination chalegi (//If the current state is NOT PokemonLoaded, stop here.)
    }

    final current = state as PokemonLoaded;
    if (current.isLoading) return;

    emit(await current.copyWith(isLoading: true));

    try {
      final newData = await service.fetchPokemon(current.offset);

      emit(
        await current.copyWith(
          pokemonList: [
            ...current.pokemonList,
            ...newData, //... is the spread operator using for the merge the item from one list to another list
          ],
          offset: current.offset + 10, //update offset
          isLoading: false, //stop loading
        ),
      );
    } catch (e) {
      emit(PokemonError(e.toString()));
    }
  }

  //searchQuery: event.query => user jo bhi type krega vo store hoga

  Future<void> _onSearch(
    SearchPokemon event,
    Emitter<PokemonState> emit,
  ) async {
    if (state is! PokemonLoaded) return;

    final current = state as PokemonLoaded;

    emit(
      await current.copyWith(
        searchQuery: event.query,
      ),
    );
  }

  Future<void> _onFilter(
    FilterPokemonByType event,
    Emitter<PokemonState> emit,
  ) async {
    if (state is! PokemonLoaded) return;

    final current = state as PokemonLoaded;

    emit(
      await current.copyWith(
        selectedType: event.type,
      ),
    );
  }

  List<Pokemon> getFiltered(PokemonLoaded state) {
    return _applyFilters(
      state.pokemonList,
      state.searchQuery,
      state.selectedType,
    );
  }
}
