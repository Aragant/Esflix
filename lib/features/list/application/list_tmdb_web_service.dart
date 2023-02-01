import 'package:http/http.dart' as http;
import '../../../assets/tmdb_constants.dart' as tmdb;
import '../../auth/domain/tmdb_session.dart';



class ListTmdbWebService {

  static Future<bool> addMovieToList(int listId, int movieId) async {
    final response = await http.post(
      Uri.parse(
          '${tmdb.BASE_URL}/list/$listId/add_item?&session_id=${TmdbSession.sessionId}&api_key=${tmdb.API_KEY}}'),
      body: {
        'media_id': movieId.toString(),
      },
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add movie to list');
    }

    return true;
  }
}