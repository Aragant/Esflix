import 'dart:convert';

import '../../auth/domain/tmdb_session.dart';
import '../domain/account.dart';
import '../../../assets/tmdb_constants.dart' as tmdb;
import 'package:http/http.dart' as http;

class AccountTmdbWebService {
  static Future<Account> getDetails() async {
    final response = await http.get(Uri.parse(
        '${tmdb.BASE_URL}/account?api_key=${tmdb.API_KEY}&session_id=${TmdbSession.sessionId}'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load account details');
    }

    final jsonBody = jsonDecode(response.body);

    return Account.fromJson(jsonBody);
  }
}
