import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const PokedexPage(),
    );
  }
}

class Pokemon {
  final String name;
  final String url;

  const Pokemon({required this.name, required this.url});

  String get image {
    final id = url.split('/')[url.split('/').length - 2];
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  }
}

class PokedexPage extends StatefulWidget {
  const PokedexPage({super.key});

  @override
  State<PokedexPage> createState() => _PokedexPageState();
}

class _PokedexPageState extends State<PokedexPage> {
  List<Pokemon> _todos = [];
  List<Pokemon> _filtrados = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _buscarDados();
  }

  Future<void> _buscarDados() async {
    try {
      final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List resultados = data['results'];
        setState(() {
          _todos = resultados.map((item) => Pokemon(
            name: item['name'].toString().toUpperCase(),
            url: item['url']
          )).toList();
          _filtrados = _todos;
          _carregando = false;
        });
      }
    } catch (e) {
      setState(() => _carregando = false);
    }
  }

  void _pesquisar(String texto) {
    setState(() {
      _filtrados = _todos
          .where((p) => p.name.toLowerCase().contains(texto.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('pokedex do tiodani',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              onChanged: _pesquisar,
              decoration: InputDecoration(
                hintText: 'Pesquisar Pokémon...',
                prefixIcon: const Icon(Icons.search, color: Colors.redAccent),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.redAccent, width: 2),
                ),
              ),
            ),
          ),
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator(color: Colors.redAccent))
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: _filtrados.length,
                    itemBuilder: (context, index) {
                      final pokemon = _filtrados[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Image.network(
                                  pokemon.image,
                                  errorBuilder: (c, e, s) => const Icon(Icons.catching_pokemon, size: 50, color: Colors.grey),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: Text(
                                pokemon.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
