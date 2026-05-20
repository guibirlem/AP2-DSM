class Pokemon {
  final String name;
  final String imageUrl;

  Pokemon({required this.name, required this.imageUrl});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    String url = json['url'];
    String id = url.split('/')[url.split('/').length - 2];
    return Pokemon(
      name: json['name'][0].toUpperCase() + json['name'].substring(1),
      imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
    );
  }
}
