import 'package:esflix/common_widgets/content_media_list.dart';
import 'package:flutter/material.dart';

import '../domain/movie.dart';
import '../application/movie_tmdb_web_service.dart';
import '../../../assets/tmdb_constants.dart' as tmdb;

class MoviePopularView extends StatefulWidget {
  const MoviePopularView({super.key});

  @override
  State<MoviePopularView> createState() => _MoviePopularViewState();
}

class _MoviePopularViewState extends State<MoviePopularView> {
  bool _isLoading = true;
  String? _exception;
  List<Movie> _movies = [];
  List<String> _moviesPosterUrl = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final movies = await MovieTmdbWebService.retrievePopular();
      setState(() {
        _movies = movies;
        _moviesPosterUrl = movies
            .map((e) => "${tmdb.IMAGE_URL}/${e.posterUrl}")
            .toList();
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _exception = error.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Text(_exception.toString()),
    );
  }

  Widget _buildMoviesIsEmpty() {
    return const Center(
      child: Text('No movies'),
    );
  }

  Widget _buildMovies() {
    return ContentMediaList(
      items: _moviesPosterUrl,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoading();
    } else if (_exception != null) {
      return _buildError();
    } else if (_movies.isEmpty) {
      return _buildMoviesIsEmpty();
    } else {
      return _buildMovies();
    }
  }
}
