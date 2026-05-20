import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokemonService {
  Future<List<Pokemon>> getPokemons() async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=50'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((item) => Pokemon.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar Pokémons');
    }
  }
}
