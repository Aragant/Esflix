import 'package:http/http.dart' as http;
import '../../../assets/tmdb_constants.dart' as tmdb;

class AuthentificationTMDBWebService {
  static final _apiKey = tmdb.API_KEY;
  static final _baseUrl = '${tmdb.BASE_URL}/authentication';
  static final _language = tmdb.LANGUAGE;
  

  static Future<String> createSessionWithLogin(
      String username, String password) async {
    final requestToken = await createRequestToken();
    return createSessionWithLoginAndRequestToken(username, password, requestToken);
  }

  static Future<String> createRequestToken() async {
    final response = await http.get(Uri.parse(
        '$_baseUrl/token/new?api_key=$_apiKey&language=$_language&page=1'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  //create a session with login
  static Future<String> createSessionWithLoginAndRequestToken(
      String username, String password, String requestToken) async {
    final response = await http.post(
        Uri.parse(
            '$_baseUrl/token/validate_with_login?api_key=$_apiKey&language=$_language&page=1'),
        body: {
          'username': username,
          'password': password,
          'request_token': requestToken
        });

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  
}
