import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final String name;
  final int id;
  final String type;
  final String imageUrl;
  final double height;
  final double weight;
  final List<String> abilities;

  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const DetailScreen({
    super.key,
    required this.name,
    required this.id,
    required this.type,
    required this.imageUrl,
    required this.height,
    required this.weight,
    required this.abilities,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int selectedTab = 0;
  late bool isFav; // ✅ local state for instant UI

  @override
  void initState() {
    super.initState();
    isFav = widget.isFavorite;
  }

  Color getPokemonColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return Colors.orange;
      case 'water':
        return Colors.blue;
      case 'grass':
        return Colors.green;
      case 'electric':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getPokemonColor(widget.type);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          // ✅ HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, left: 16, right: 16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ TOP BAR
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.3),
                        child:
                            const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                    Row(
                      children: [
                        // ❤️ FAVORITE
                        InkWell(
                          onTap: () {
                            widget.onFavoriteToggle(); // home update
                            setState(() {
                              isFav = !isFav; // instant UI update
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // 🔢 ID
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '#${widget.id.toString().padLeft(3, '0')}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 6),

                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(widget.type,
                      style: const TextStyle(color: Colors.white)),
                ),

                const SizedBox(height: 20),

                Center(
                  child: Image.network(widget.imageUrl, height: 140),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),

          // ✅ BODY
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ✅ TABS
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => selectedTab = 0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedTab == 0
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  "About",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: selectedTab == 0
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () => setState(() => selectedTab = 1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedTab == 1
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  "Base Stats",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: selectedTab == 1
                                        ? Colors.black
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ✅ SWITCH CONTENT
                  if (selectedTab == 0) ...[
                    Row(
                      children: [
                        Expanded(
                          child: infoCard("HEIGHT", "${widget.height} m"),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: infoCard("WEIGHT", "${widget.weight} kg"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "ABILITIES",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(widget.abilities.join(", ")),
                    ),
                  ] else ...[
                    Column(
                      children: [
                        statRow("HP", 70, color),
                        statRow("Attack", 65, color),
                        statRow("Defense", 55, color),
                        statRow("Speed", 80, color),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget infoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(title),
          const SizedBox(height: 6),
          Text(value),
        ],
      ),
    );
  }

  Widget statRow(String name, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(name)),
          Expanded(
            child: LinearProgressIndicator(
              value: value / 100,
              color: color,
              backgroundColor: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}
