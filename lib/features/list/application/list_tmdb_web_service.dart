import 'dart:convert';

import 'package:esflix/features/list/domain/list_detail.dart';
import 'package:esflix/features/list/domain/movie_list.dart';
import 'package:http/http.dart' as http;
import '../../../assets/tmdb_constants.dart' as tmdb;
import '../../auth/domain/tmdb_session.dart';

class ListTmdbWebService {
  static Future<bool> addMovieToList(int listId, int movieId) async {

    final response = await http.post(
      Uri.parse(
          '${tmdb.BASE_URL}/list/$listId/add_item?&session_id=${TmdbSession.sessionId}&api_key=${tmdb.API_KEY}'),
      body: {
        "media_id": movieId.toString(),
      },
    );

    if (response.statusCode != 201) {
      print(response.statusCode);
      throw Exception('Failed to add movie to list');
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
}
