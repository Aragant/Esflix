// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter_dotenv/flutter_dotenv.dart';


final String BASE_URL = dotenv.env['TMDB_BASE_URL']!;
final String API_KEY = dotenv.env['TMDB_API_KEY']!;
final String LANGUAGE = dotenv.env['LANG']!;
final String AUTH_URL = dotenv.env['TMDB_AUTH_URL']!;
final String IMAGE_URL = dotenv.env['TMDB_IMAGE_URL']!;
