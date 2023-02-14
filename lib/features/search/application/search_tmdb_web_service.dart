import 'dart:convert';

import 'package:esflix/features/search/domain/search_data.dart';

import '../../../assets/tmdb_constants.dart' as tmdb;
import 'package:http/http.dart' as http;

class SearchTmdbWebService {
  static Future<List<SearchData>> searchMovie(String query) async {
    final response = await http.get(Uri.parse(
        '${tmdb.BASE_URL}/search/movie?api_key=${tmdb.API_KEY}&query=$query&page=1&include_adult=false&language=${tmdb.LANGUAGE}'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load search results');
    }

    final jsonBody = jsonDecode(response.body);

    final List<SearchData> searchData = jsonBody['results']
        .map<SearchData>((e) => SearchData.fromJson(e))
        .toList();

    return searchData;
  }
}
