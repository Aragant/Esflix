import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../assets/tmdb_constants.dart' as tmdb;

import '../domain/movie.dart';

class MovieTmdbWebService {
  static final _apiKey = tmdb.API_KEY;
  static final _baseUrl = '${tmdb.BASE_URL}/movie';
  static final _language = tmdb.LANGUAGE;

  static Future<List<Movie>> getPopular() async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/popular?api_key=$_apiKey&language=$_language&page=1'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load popular movies');
    }

    final jsonBody = jsonDecode(response.body);

    final movies = <Movie>[];

    for (final jsonMovie in jsonBody['results']) {
      movies.add(Movie.fromJson(jsonMovie));
    }

    return movies;
  }
}
