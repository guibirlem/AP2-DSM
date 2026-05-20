class Pokemon {
  final String name;
  final String url;

  Pokemon({required this.name, required this.url});

  String get imageUrl {
    final id = url.split('/')[url.split('/').length - 2];
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  }

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'].toString().toUpperCase(),
      url: json['url'],
    );
  }
}
