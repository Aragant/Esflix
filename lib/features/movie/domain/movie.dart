
import 'package:esflix/features/movie/domain/genre.dart';

class Movie {
  final int id;
  final String title;
  final String posterPath;
  final String backdropUrl;
  final String description;
  final List<Genre> genres;
  final String releaseDate;
  final double rating;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.backdropUrl,
    required this.description,
    required this.genres,
    required this.releaseDate,
    required this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: json['title'] as String,
      posterPath: json['poster_path'] as String,
      backdropUrl: json['backdrop_path'] as String,
      description: json['overview'] as String,
      genres: (json['genres'] as List<dynamic>)
          .map((e) => Genre.fromJson(e))
          .toList(),
      releaseDate: json['release_date'] as String,
      rating: json['vote_average'].toDouble() as double,
    );
  }


}
