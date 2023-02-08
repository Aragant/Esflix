import 'dart:convert';
import 'dart:io';

import 'package:esflix/features/list/domain/list_detail.dart';
import 'package:http/http.dart' as http;
import '../../../assets/tmdb_constants.dart' as tmdb;
import '../../auth/domain/tmdb_session.dart';
import '../../movie/application/movie_tmdb_web_service.dart';
import '../../movie/domain/movie.dart';

class ListTmdbWebService {
  static Future<bool> addMovieToList(int listId, int movieId) async {
    final response = await http.post(
      Uri.parse(
          '${tmdb.BASE_URL}/list/$listId/add_item?&session_id=${TmdbSession.sessionId}&api_key=${tmdb.API_KEY}'),
      body: {
        "media_id": movieId.toString(),
      },
    );

    if (response.statusCode != 201 && response.statusCode != 403) {
      throw Exception('Failed to add movie to list');
    }

    if (response.statusCode == 403) {
      return false;
    }

    return true;
  }

  static Future<List<ListDetail>> getLists() async {
    final response = await http.get(
      Uri.parse(
          '${tmdb.BASE_URL}/account/${TmdbSession.accoutnId}/lists?session_id=${TmdbSession.sessionId}&api_key=${tmdb.API_KEY}'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get lists');
    }

    final jsonBody = jsonDecode(response.body);

    List<ListDetail> lists = List<ListDetail>.from(
        jsonBody['results'].map((x) => ListDetail.fromJson(x)));

    return lists;
  }

  static Future<bool> createList(String name, String description) async {
    final response = await http.post(
      Uri.parse(
          '${tmdb.BASE_URL}/list?&session_id=${TmdbSession.sessionId}&api_key=${tmdb.API_KEY}'),
      body: {
        'name': name,
        'description': description,
        'language': 'fr',
      },
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create list');
    }

    return true;
  }

  static Future<List<Movie>> getListMovies(int listId) async {
    final response = await http.get(
      Uri.parse(
          '${tmdb.BASE_URL}/list/$listId?&session_id=${TmdbSession.sessionId}&api_key=${tmdb.API_KEY}&language=${tmdb.LANGUAGE}'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get list movies');
    }

    final jsonBody = jsonDecode(response.body);

    List<int> moviesId = List<int>.from(jsonBody['items'].map((x) => x['id']));

    final movies =
        Future.wait(moviesId.map((e) => MovieTmdbWebService.getDetails(e)));

    return movies;
  }

  static Future<bool> removeMovieFromList(int listId, int movieId) async {
    final msg = jsonEncode({
      "media_id": movieId,
    });
    final response = await http.post(
      Uri.parse(
          '${tmdb.BASE_URL}/list/$listId/remove_item?session_id=${TmdbSession.sessionId}&api_key=${tmdb.API_KEY}'),
      body: msg,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove movie from list');
    }

    return true;
  }

  static Future<bool> deleteList(int listId) async {
    final response = await http.delete(
      Uri.parse(
          '${tmdb.BASE_URL}/list/${listId.toString()}?session_id=${TmdbSession.sessionId}&api_key=${tmdb.API_KEY}'),
    );

    print(response.statusCode);
    if (response.statusCode != 201 && response.statusCode != 500) {
      throw Exception('Failed to delete list');
    }

    return true;
  }
}
