import 'dart:convert';

import 'package:esflix/features/auth/domain/tmdb_session.dart';
import 'package:http/http.dart' as http;
import '../../../assets/tmdb_constants.dart' as tmdb;

class AuthTmdbWebService {
  static final _baseUrl = '${tmdb.BASE_URL}/authentication';

  static Future<String> createRequestToken() async {
    final response = await http
        .get(Uri.parse('$_baseUrl/token/new?api_key=${tmdb.API_KEY}'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load popular movies');
    }

    final jsonBody = jsonDecode(response.body);

    return jsonBody['request_token'];
  }

  static Future<String> createSession() async {
    final response = await http.post(
      Uri.parse('$_baseUrl/session/new?api_key=${tmdb.API_KEY}'),
      body: {
        'request_token': TmdbSession.requestToken!,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create session');
    }

    final jsonBody = jsonDecode(response.body);

    return jsonBody['session_id'];
  }

  static Future<bool> createSessionWithLogin(
      String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/token/validate_with_login?api_key=${tmdb.API_KEY}'),
      body: {
        'username': username,
        'password': password,
        'request_token': TmdbSession.requestToken!,
      },
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 401) {
        throw Exception('Wrong username or password');
      }
    }

    final jsonBody = jsonDecode(response.body);

    return jsonBody['success'];
  }
}
