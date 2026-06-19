import 'package:flutter/material.dart';
import 'package:pokemon_app/models/pokemon.dart';
import 'package:pokemon_app/providers/pokemon_provider.dart';
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
  static const _types = [
    'All',
    'grass',
    'fire',
    'water',
    'electric',
    'poison',
    'flying',
  ];

  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final Set<int> favoriteIds = {};

  bool showSavedOnly = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_loadMore);
  }

  void _loadMore() {
    if (!scrollController.hasClients) return;

    final provider = context.read<PokemonProvider>();
    final isNearBottom = scrollController.position.extentAfter < 300;

    if (isNearBottom && !provider.isLoading && !provider.isLoadingMore) {
      provider.fetchPokemon();
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
    final provider = context.watch<PokemonProvider>();
    final visiblePokemon = provider.filteredPokemon.where((pokemon) {
      return !showSavedOnly || favoriteIds.contains(pokemon.id);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xffF8F8FC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(visiblePokemon.length),
              const SizedBox(height: 20),
              SearchBarWidget(
                controller: searchController,
                onChanged: provider.searchPokemon,
              ),
              const SizedBox(height: 18),
              _buildListToggle(),
              const SizedBox(height: 16),
              SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _types.map((type) {
                    return FilterChipWidget(
                      title: _capitalize(type),
                      selected: provider.selectedType == type,
                      onTap: () => provider.filterByType(type),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _buildPokemonGrid(provider, visiblePokemon),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(int resultCount) {
    return Row(
      children: [
        Image.asset('assets/appicon.png', width: 42, height: 42),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pokédex',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Color(0xff111827),
              ),
            ),
            Text(
              '$resultCount found',
              style: const TextStyle(
                color: Color(0xff9CA3AF),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildListToggle() {
    return Container(
      height: 54,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xffE9EBF0),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          _buildToggleButton(
            title: 'All',
            selected: !showSavedOnly,
            onTap: () => setState(() => showSavedOnly = false),
          ),
          _buildToggleButton(
            title: 'Saved',
            selected: showSavedOnly,
            icon: Icons.favorite,
            onTap: () => setState(() => showSavedOnly = true),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String title,
    required bool selected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18,
                  color: selected ? Colors.red : const Color(0xff9CA3AF),
                ),
                const SizedBox(width: 5),
              ],
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? const Color(0xff111827)
                      : const Color(0xff9CA3AF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPokemonGrid(
    PokemonProvider provider,
    List<Pokemon> visiblePokemon,
  ) {
    if (provider.isLoading && provider.pokemon.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (visiblePokemon.isEmpty) {
      return Center(
        child: Text(
          showSavedOnly ? 'No saved Pokémon yet' : 'No Pokémon found',
          style: const TextStyle(
            color: Color(0xff9CA3AF),
            fontSize: 16,
          ),
        ),
      );
    }

    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: visiblePokemon.length + (provider.isLoadingMore ? 1 : 0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (context, index) {
        if (index == visiblePokemon.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final pokemon = visiblePokemon[index];
        return PokemonCard(
          pokemon: pokemon,
          isFavorite: favoriteIds.contains(pokemon.id),
          onFavorite: () => _toggleFavorite(pokemon.id),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => DetailScreen(pokemonId: pokemon.id),
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

  @override
  void dispose() {
    scrollController
      ..removeListener(_loadMore)
      ..dispose();
    searchController.dispose();
    super.dispose();
  }
}
