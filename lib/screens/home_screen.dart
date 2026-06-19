import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchController controller = SearchController();

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset('assets/appicon.png', height: 30),
            const SizedBox(width: 10),
            const Text('Pokédex', style: TextStyle(color: Colors.black)),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchAnchor.bar(
              searchController: controller,

              barHintText: 'Search',

              barLeading: const Icon(Icons.search, color: Colors.grey),

              barBackgroundColor: MaterialStateProperty.all(Colors.white),
              barElevation: MaterialStateProperty.all(3),

              barShape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),

              barPadding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 16),
              ),

              suggestionsBuilder:
                  (BuildContext context, SearchController controller) {
                    final input = controller.text.toLowerCase();

                    final List<String> pokemonList = [
                      'pikachu',
                      'bulbasaur',
                      'charmander',
                      'squirtle',
                    ];

                    final results = pokemonList
                        .where((item) => item.contains(input))
                        .toList();

                    return results.map((pokemon) {
                      return ListTile(
                        title: Text(pokemon),
                        onTap: () {
                          controller.closeView(pokemon);
                        },
                      );
                    }).toList();
                  },
            ),

            const SizedBox(height: 20),

            const Text(
              'Welcome to the Pokédex!',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
