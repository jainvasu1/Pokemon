import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

class DetailScreen extends StatefulWidget {
  final int pokemonId;

  const DetailScreen({super.key, required this.pokemonId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<Pokemon> pokemon;

  @override
  void initState() {
    super.initState();
    pokemon = PokemonService().fetchPokemonById(widget.pokemonId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Pokemon>(
        future: pokemon,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          }

          final data = snapshot.data!;

          return Column(
            children: [
              // HEADER
              Container(
                height: 380,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green, Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: Icon(Icons.favorite_border, color: Colors.white),
                    ),
                    Positioned(
                      right: 10,
                      top: 80,
                      child: Text(
                        '#${data.id}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 60),
                        Text(
                          data.name.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children:
                              data.types.map((t) => _typeChip(t)).toList(),
                        ),
                      ],
                    ),
                    Positioned(
                      right: 0,
                      bottom: 10,
                      child: Image.network(
                        data.image,
                        height: 180,
                        width: 180,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // HEIGHT & WEIGHT
              Row(
                children: [
                  Expanded(child: _infoCard('HEIGHT', '${data.height} m')),
                  Expanded(child: _infoCard('WEIGHT', '${data.weight} kg')),
                ],
              ),

              const SizedBox(height: 20),

              // ABILITIES
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ABILITIES'),
                    Text(data.abilities.join(', ')),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _typeChip(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _infoCard(String title, String value) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(title),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
