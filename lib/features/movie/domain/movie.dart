import 'dart:convert';

import 'package:esflix/features/movie/domain/genre.dart';

class Movie {
  final String title;
  final String posterPath;
  final String backdropUrl;
  final String description;
  final List<Genre> genres;
  final String releaseDate;
  final double rating;

  Movie({
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
      title: json['title'],
      posterPath: json['poster_path'],
      backdropUrl: json['backdrop_path'],
      description: json['overview'],
      genres: (json['genres'] as List<dynamic>)
          .map((e) => Genre.fromJson(e))
          .toList(),
      releaseDate: json['release_date'],
      rating: json['vote_average'].toDouble(),
    );
  }


}
