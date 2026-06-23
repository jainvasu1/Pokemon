class Pokemon {
  final int id;
  final String name;
  final String image;
  final List<String> types;
  final double height;
  final double weight;
  final List<String> abilities;

  final int hp;
  final int attack;
  final int defense;
  final int spAttack;
  final int spDefense;
  final int speed;

  Pokemon({
    required this.id,
    required this.name,
    required this.image,
    required this.types,
    required this.height,
    required this.weight,
    required this.abilities,
    required this.hp,
    required this.attack,
    required this.defense,
    required this.spAttack,
    required this.spDefense,
    required this.speed,
  });

  int get total => hp + attack + defense + spAttack + spDefense + speed;

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final stats = {
      for (final stat in json['stats'] as List)
        stat['stat']['name'] as String: stat['base_stat'] as int,
    };

    return Pokemon(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['sprites']['other']['official-artwork']['front_default']
          as String,
      types: (json['types'] as List)
          .map((e) => e['type']['name'] as String)
          .toList(),
      // PokéAPI height is returned in decimetres (dm).
// Example: 4 -> 0.4 m, 17 -> 1.7 m
      height: (json['height'] as num).toDouble() / 10,
      // PokéAPI weight is returned in hectograms (hg).
// Example: 60 -> 6.0 kg, 905 -> 90.5 kg
      weight: (json['weight'] as num).toDouble() / 10,
      abilities: (json['abilities'] as List)
          .map((e) => e['ability']['name'] as String)
          .toList(),
      hp: stats['hp'] ?? 0,
      attack: stats['attack'] ?? 0,
      defense: stats['defense'] ?? 0,
      spAttack: stats['special-attack'] ?? 0,
      spDefense: stats['special-defense'] ?? 0,
      speed: stats['speed'] ?? 0,
    );
  }
}
