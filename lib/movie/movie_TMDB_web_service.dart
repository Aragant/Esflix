

import 'package:esflix/movie/movie.dart';
import 'package:http/http.dart' as http;

class MovieTMDBWebService {
  static Future<List<Movie>> retrievePopular() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=1c1b1b1b1b1b1b1b1b1b1b1b1b1b1b1b&language=en-US&page=1'));
  }
}