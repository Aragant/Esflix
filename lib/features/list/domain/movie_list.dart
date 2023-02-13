import '../../movie/domain/movie.dart';

class MovieList {
  final int id;
  final String name;
  final String description;
  final List<Movie> movies;

  MovieList({
    required this.id,
    required this.name,
    required this.description,
    this.movies = const [],
  });

  factory MovieList.fromJson(Map<String, dynamic> json) {
    return MovieList(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      movies: (json['items'] as List<dynamic>)
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
