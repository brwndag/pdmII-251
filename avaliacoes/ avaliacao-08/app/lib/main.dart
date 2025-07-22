import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Studio Ghibli Movies',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 94, 153, 209),
          ),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  static const String apiUrl = 'https://ghibli-api.vercel.app/api/films';  // api filmes do studio ghibli
  
  List<Movie> movies = [];
  List<Movie> favorites = [];
  bool isLoading = false;
  String errorMessage = '';

  MyAppState() {
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        // Acessa a lista de filmes dentro da chave "data"
        if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
          List<dynamic> data = decoded['data'];
          movies = data.map((json) => Movie.fromJson(json)).toList();
        } else {
          errorMessage = 'Formato de resposta inesperado.';
        }
        errorMessage = '';
      } else {
        errorMessage = 'Erro: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage = 'Erro: $e';
    }

    isLoading = false;
    notifyListeners();
  }

  void toggleFavorite(Movie movie) {
    favorites.contains(movie) ? favorites.remove(movie) : favorites.add(movie);
    notifyListeners();
  }
}

class Movie {
  final String id;
  final String title;
  final String description;
  final String image;
  final String director;
  final String releaseDate;
  final String rtScore;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.director,
    required this.releaseDate,
    required this.rtScore,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Sem título',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      director: json['director'] ?? 'Desconhecido',
      releaseDate: json['release_date'] ?? '----',
      rtScore: json['rt_score'] ?? 'N/A',
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    Widget page = selectedIndex == 0 ? const MoviesPage() : const FavoritesPage();

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: MediaQuery.of(context).size.width >= 600,
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.movie), label: Text('Filmes')), //icon movies
              NavigationRailDestination(icon: Icon(Icons.favorite), label: Text('Favoritos')), //icon coracao
            ],
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) => setState(() => selectedIndex = value),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}

class MoviesPage extends StatelessWidget { // page com os filmes
  const MoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();

    if (appState.isLoading) return const Center(child: CircularProgressIndicator());
    if (appState.errorMessage.isNotEmpty) return Center(child: Text(appState.errorMessage));

    return RefreshIndicator(
      onRefresh: appState.fetchMovies,
      child: SizedBox(
        height: MediaQuery.of(context).size.height, //altura da ListView
        child: ListView.builder(
          itemCount: appState.movies.length,
          itemBuilder: (context, index) {
            final movie = appState.movies[index];
            final isFavorite = appState.favorites.contains(movie);

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: ListTile(
                leading: Image.network(movie.image, width: 50, fit: BoxFit.cover),
                title: Text(movie.title),
                subtitle: Text('${movie.director} • ${movie.releaseDate}'),
                trailing: IconButton(
                  icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : null),
                  onPressed: () => appState.toggleFavorite(movie),
                ),
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text(movie.title),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(movie.image),
                        const SizedBox(height: 10),
                        Text(movie.description),
                        const SizedBox(height: 10),
                        Text('Diretor: ${movie.director}\nAno: ${movie.releaseDate}\nNota: ${movie.rtScore}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {  //page de favs
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) return const Center(child: Text('Nenhum favorito ainda.'));

    return ListView.builder(
      itemCount: appState.favorites.length,
      itemBuilder: (context, index) {
        final movie = appState.favorites[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: ListTile(
            leading: Image.network(movie.image, width: 50, fit: BoxFit.cover),
            title: Text(movie.title),
            subtitle: Text('${movie.director} • ${movie.releaseDate}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => appState.toggleFavorite(movie),
            ),
          ),
        );
      },
    );
  }
}