import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../domain/movie.dart';

class MovieTMDBWebService {
  static final _apiKey = dotenv.env['TMDB_API_KEY']!;
  static final _baseUrl = '${dotenv.env['TMDB_BASE_URL']!}/movie';
  static final _language = dotenv.env['LANG']!;

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