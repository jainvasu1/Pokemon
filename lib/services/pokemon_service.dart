import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon.dart';

class PokemonService {
  final String baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> fetchPokemon(int offset) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/pokemon?limit=10&offset=$offset'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load Pokémon');
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List;
      final pokemons = <Pokemon>[];

      for (final result in results) {
        final detailResponse =
            await http.get(Uri.parse(result['url'] as String));

        if (detailResponse.statusCode != 200) {
          throw Exception('Failed to load Pokémon details');
        }

        final detailData =
            json.decode(detailResponse.body) as Map<String, dynamic>;

        pokemons.add(Pokemon.fromJson(detailData));
      }

      return pokemons;
    } catch (e) {
      throw Exception('Error fetching Pokémon: $e');
    }
  }

  Future<Pokemon> fetchPokemonById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/pokemon/$id'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load Pokémon');
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      return Pokemon.fromJson(data);
    } catch (e) {
      throw Exception('Error fetching Pokémon by ID: $e');
    }
  }
}
//
