import 'package:http/http.dart' as http;
import '../../../assets/tmdb_constants.dart' as tmdb;

import '../domain/movie.dart';

class MovieTmdbWebService {
  static final _apiKey = tmdb.API_KEY;
  static final _baseUrl = '${tmdb.BASE_URL}/movie';
  static final _language = tmdb.LANGUAGE;

  static Future<List<Movie>> retrievePopular() async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/popular?api_key=$_apiKey&language=$_language&page=1'));

    if (response.statusCode == 200) {
      return Movie.parseList(response.body);
    } else {
      throw Exception('Failed to load popular movies');
    }
  }
}