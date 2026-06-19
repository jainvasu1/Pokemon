import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

class PokemonProvider with ChangeNotifier {
  final PokemonService _service = PokemonService();

  final List<Pokemon> _pokemonList = [];
  List<Pokemon> get pokemonList => _pokemonList;

  int _offset = 0;
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedType = 'All';

  PokemonProvider() {
    fetchPokemon();
  }

  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoading && _pokemonList.isNotEmpty;
  String get selectedType => _selectedType;

  List<Pokemon> get pokemon => _pokemonList;

  List<Pokemon> get filteredPokemon {
    final normalizedQuery = _searchQuery.trim().toLowerCase();

    return _pokemonList.where((pokemon) {
      final matchesSearch = normalizedQuery.isEmpty ||
          pokemon.name.toLowerCase().contains(normalizedQuery) ||
          pokemon.id.toString() == normalizedQuery;
      final matchesType =
          _selectedType == 'All' || pokemon.types.contains(_selectedType);

      return matchesSearch && matchesType;
    }).toList();
  }

  Future<void> fetchPokemon() => fetchMorePokemon();

  Future<void> fetchMorePokemon() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newPokemon = await _service.fetchPokemon(_offset);
      _pokemonList.addAll(newPokemon);
      _offset += 10;
    } catch (error) {
      debugPrint('Failed to load Pokémon: $error');
    }

    _isLoading = false;
    notifyListeners();
  }

  void searchPokemon(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void filterByType(String type) {
    _selectedType = type;
    notifyListeners();
  }
}
