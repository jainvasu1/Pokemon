import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pokemon_provider.dart';
import '../widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  bool showSavedOnly = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PokemonProvider>();

    return Scaffold(
      backgroundColor: const Color(0xffF8F8FC),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 28, 22, 20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // TOP HEADER
              Row(
                children: [
                  Image.asset("assets/appicon.png", width: 38, height: 38),

                  const SizedBox(width: 10),

                  const Text(
                    "Pokédex",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xff111827),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              Padding(
                padding: const EdgeInsets.only(left: 42),

                child: Text(
                  "${provider.filteredPokemon.length} found",

                  style: const TextStyle(
                    color: Color(0xff9CA3AF),
                    fontSize: 15,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // SEARCH
              SearchBarWidget(
                controller: searchController,
                onChanged: provider.searchPokemon,
              ),

              const SizedBox(height: 18),

              // ALL SAVED
              Container(
                height: 54,

                width: double.infinity,

                padding: const EdgeInsets.all(5),

                decoration: BoxDecoration(
                  color: const Color(0xffE9EBF0),

                  borderRadius: BorderRadius.circular(28),
                ),

                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),

                        onTap: () {
                          setState(() {
                            showSavedOnly = false;
                          });
                        },

                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),

                          decoration: BoxDecoration(
                            color: !showSavedOnly
                                ? Colors.white
                                : Colors.transparent,

                            borderRadius: BorderRadius.circular(24),

                            boxShadow: !showSavedOnly
                                ? [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ]
                                : [],
                          ),

                          child: const Center(
                            child: Text(
                              "All",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),

                        onTap: () {
                          setState(() {
                            showSavedOnly = true;
                          });
                        },

                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),

                          decoration: BoxDecoration(
                            color: showSavedOnly
                                ? Colors.white
                                : Colors.transparent,

                            borderRadius: BorderRadius.circular(24),
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: const [
                              Icon(
                                Icons.favorite,
                                size: 18,
                                color: Color(0xff9CA3AF),
                              ),

                              SizedBox(width: 5),

                              Text(
                                "Saved",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff9CA3AF),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
