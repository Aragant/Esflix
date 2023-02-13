import 'dart:convert';

import 'package:esflix/features/movie/application/movie_tmdb_web_service.dart';

import '../../movie/domain/movie.dart';
import '../../../assets/tmdb_constants.dart' as tmdb;
import 'package:http/http.dart' as http;

class SearchTmdbWebService {
  static Future<List<Movie>> searchMovie(String query) async {
    final response = await http.get(Uri.parse(
        '${tmdb.BASE_URL}/search/movie?api_key=${tmdb.API_KEY}&query=$query&page=1&include_adult=false&language=${tmdb.LANGUAGE}'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load search results');
    }

    final jsonBody = jsonDecode(response.body);

    final moviesId =
        (jsonBody['results'] as List<dynamic>).map((e) => e['id']).toList();

    moviesId.forEach((element) {
      print(element);
    });
    final movies =
        Future.wait(moviesId.map((e) => MovieTmdbWebService.getDetails(e)));

    return movies;
  }
}
