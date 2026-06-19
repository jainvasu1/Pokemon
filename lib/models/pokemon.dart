class Pokemon {
  final int id;
  final String name;
  final String image;
  final List<String> types;
  final double height;
  final double weight;
  final List<String> abilities;

  Pokemon({
    required this.id,
    required this.name,
    required this.image,
    required this.types,
    required this.height,
    required this.weight,
    required this.abilities,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['sprites']['other']['official-artwork']['front_default']
          as String,
      types: (json['types'] as List)
          .map((e) => e['type']['name'] as String)
          .toList(),
      // PokéAPI returns height in decimetres and weight in hectograms.
      height: (json['height'] as num).toDouble() / 10,
      weight: (json['weight'] as num).toDouble() / 10,
      abilities: (json['abilities'] as List)
          .map((e) => e['ability']['name'] as String)
          .toList(),
    );
  }
}
