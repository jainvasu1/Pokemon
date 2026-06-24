import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/models/pokemon.dart';
import 'package:pokemon_app/bloc/pokemon_bloc.dart';
import 'package:pokemon_app/bloc/pokemon_event.dart';
import 'package:pokemon_app/bloc/pokemon_state.dart';
import 'package:pokemon_app/screens/detail_screen.dart';
import 'package:pokemon_app/widgets/filter_chip_widget.dart';
import 'package:pokemon_app/widgets/pokemon_card.dart';
import 'package:pokemon_app/widgets/search_bar_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final Set<int> favoriteIds = {};
  bool showSavedOnly = false;
  String selectedSort = 'Name';

  static const _types = [
    'All',
    'grass',
    'fire',
    'water',
    'electric',
    'poison',
    'flying',
  ];

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_loadMore);
  }

  void _loadMore() {
    if (!scrollController.hasClients) return;

    final bloc = context.read<
        PokemonBloc>(); //bloc instance so i can send the action to bloc for fetching the data(it gives the bloc, it doesnot rebuild the ui(perfect for action like scrolling))
    final isNearBottom = scrollController.position.extentAfter < 300;

    if (isNearBottom && !bloc.state.isLoading) {
      //here bloc.state.isloading checks the current state before doing anything because all data is inside the state.
      bloc.add(FetchMorePokemon()); // for sending event.
    }
  }

  void _toggleFavorite(int id) {
    setState(() {
      if (!favoriteIds.add(id)) {
        favoriteIds.remove(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonBloc, PokemonState>(
      // it specifies which bloc ans state listen the event
      builder: (context, state) {
        //a callback function taht gives you access to the current ui layout and current data(State) of the bloc.

        final visiblePokemon = state.filteredPokemon.where((pokemon) {
          return !showSavedOnly || favoriteIds.contains(pokemon.id);
        }).toList();

        _sortPokemon(visiblePokemon);

        return Scaffold(
          backgroundColor: const Color(0xffF8F8FC),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(visiblePokemon.length),
                  const SizedBox(height: 16),
                  SearchBarWidget(
                    controller: searchController,
                    onChanged: (value) {
                      context.read<PokemonBloc>().add(
                            SearchPokemon(
                                value), //here trigger the event then bloc fetch the data from state.
                          );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTopActions(state),
                  const SizedBox(height: 12),
                  _buildSortAndFilters(state),
                  const SizedBox(height: 12),
                  Expanded(
                    child: _buildPokemonGrid(state, visiblePokemon),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(int count) {
    return Row(
      children: [
        Image.asset('assets/appicon.png', width: 50, height: 50),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pokédex',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            Text(
              '$count found',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopActions(PokemonState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 42,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: const Color(0xffE9EBF0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              _toggleButton(
                "All",
                !showSavedOnly,
                () => setState(() => showSavedOnly = false),
              ),
              _toggleButton(
                "Saved",
                showSavedOnly,
                () => setState(() => showSavedOnly = true),
                icon: Icons.favorite,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            if (state.pokemonList.isEmpty) return;

            final random = Random();
            final randomPokemon =
                state.pokemonList[random.nextInt(state.pokemonList.length)];

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailScreen(
                  name: randomPokemon.name,
                  id: randomPokemon.id,
                  type: randomPokemon.types.first,
                  imageUrl: randomPokemon.image,
                  height: randomPokemon.height,
                  weight: randomPokemon.weight,
                  abilities: randomPokemon.abilities,
                  isFavorite: favoriteIds.contains(randomPokemon.id),
                  onFavoriteToggle: () => _toggleFavorite(randomPokemon.id),
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xffE9EBF0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "Random",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _toggleButton(String text, bool selected, VoidCallback onTap,
      {IconData? icon}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              //(...) it is a spread operator, which helps to insert all the elements from another list to current list.
              Icon(icon, size: 14),
              const SizedBox(width: 4),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortAndFilters(PokemonState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.sort, size: 16),
            const SizedBox(width: 6),
            Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0xffE9EBF0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedSort,
                  icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                  items: const ['Name', 'HP', 'Attack', 'Number']
                      .map(
                        (sort) => DropdownMenuItem(
                          value: sort,
                          child: Text('Sort: $sort'),
                        ),
                      )
                      .toList(),
                  onChanged: (sort) {
                    if (sort == null) return;
                    setState(() => selectedSort = sort);
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _types.map((type) {
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: FilterChipWidget(
                  title: _capitalize(type),
                  selected: state.selectedType == type,
                  onTap: () {
                    context.read<PokemonBloc>().add(
                          FilterPokemonByType(type),
                        );
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPokemonGrid(PokemonState state, List<Pokemon> list) {
    if (state.isLoading && state.pokemonList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (list.isEmpty) {
      return Center(
        child: Text(
          showSavedOnly ? 'No saved Pokémon yet' : 'No Pokémon found',
        ),
      );
    }

    return GridView.builder(
      controller: scrollController,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: list.length + (state.isLoading ? 1 : 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        if (index == list.length) {
          return const Center(child: CircularProgressIndicator());
        }
        // rest of your code remains the same

        final pokemon = list[index];

        return PokemonCard(
          pokemon: pokemon,
          isFavorite: favoriteIds.contains(pokemon.id),
          onFavorite: () => _toggleFavorite(pokemon.id),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailScreen(
                  name: pokemon.name,
                  id: pokemon.id,
                  type: pokemon.types.first,
                  imageUrl: pokemon.image,
                  height: pokemon.height,
                  weight: pokemon.weight,
                  abilities: pokemon.abilities,
                  isFavorite: favoriteIds.contains(pokemon.id),
                  onFavoriteToggle: () => _toggleFavorite(pokemon.id),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _capitalize(String value) {
    return value[0].toUpperCase() + value.substring(1);
  }

  void _sortPokemon(List<Pokemon> pokemon) {
    switch (selectedSort) {
      case 'HP':
        pokemon.sort((a, b) => b.hp.compareTo(a.hp));
        break;
      case 'Attack':
        pokemon.sort((a, b) => b.attack.compareTo(a.attack));
        break;
      case 'Number':
        pokemon.sort((a, b) => a.id.compareTo(b.id));
        break;
      case 'Name':
        pokemon.sort((a, b) => a.name.compareTo(b.name));
        break;
    }
  }

// Remove scroll listener and dispose controllers to prevent memory leaks
  @override
  void dispose() {
    scrollController
      ..removeListener(_loadMore)
      ..dispose();
    searchController.dispose();
    super.dispose();
  }
}
