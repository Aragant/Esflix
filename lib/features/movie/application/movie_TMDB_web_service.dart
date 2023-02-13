import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../assets/tmdb_constants.dart' as tmdb;

import '../domain/movie.dart';
import '../domain/review.dart';

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

    final moviesId =
        (jsonBody['results'] as List<dynamic>).map((e) => e['id']).toList();

    final movies = Future.wait(moviesId.map((e) => getDetails(e)));

    return movies;
  }

  static Future<Movie> getDetails(int movieId) async {
    final response = await http.get(
        Uri.parse('$_baseUrl/$movieId?api_key=$_apiKey&language=$_language'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load movie details');
    }

    final jsonBody = jsonDecode(response.body);

    final movie = Movie.fromJson(jsonBody);

    return movie;
  }

  static Future<List<Movie>> getUpComing() async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/upcoming?api_key=$_apiKey&language=$_language&page=1'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load upcoming movies');
    }

    final jsonBody = jsonDecode(response.body);

    final moviesId =
        (jsonBody['results'] as List<dynamic>).map((e) => e['id']).toList();

    final movies = Future.wait(moviesId.map((e) => getDetails(e)));

    return movies;
  }

  static Future<List<Movie>> getTopRated() async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/top_rated?api_key=$_apiKey&language=$_language&page=1'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load top rated movies');
    }

    final jsonBody = jsonDecode(response.body);

    final moviesId =
        (jsonBody['results'] as List<dynamic>).map((e) => e['id']).toList();

    final movies = Future.wait(moviesId.map((e) => getDetails(e)));

    return movies;
  }

  static Future<List<MovieReview>> getReviewsFromMovie(int movieId) async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/$movieId/reviews?api_key=$_apiKey&language=$_language&page=1'));
    print('$_baseUrl/$movieId/reviews?api_key=$_apiKey&language=$_language&page=1');
    if (response.statusCode != 200) {
      throw Exception('Failed to get reviews movie');
    }

    final jsonBody = jsonDecode(response.body);

    //final moviesReviews = jsonBody["results"].map((e) => e.fromJson(jsonBody));

    final moviesReviews = (jsonBody['results'] as List<dynamic>)
        .map((e) => MovieReview.fromJson(e))
        .toList();

    return moviesReviews;
  }
}
