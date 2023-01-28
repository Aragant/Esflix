import 'package:esflix/features/movie/presentation/movie_list.dart';
import 'package:flutter/material.dart';

import '../domain/movie.dart';
import '../application/movie_tmdb_web_service.dart';

class MoviePopularView extends StatefulWidget {
  const MoviePopularView({super.key});

  @override
  State<MoviePopularView> createState() => _MoviePopularViewState();
}

class _MoviePopularViewState extends State<MoviePopularView> {
  bool _isLoading = true;
  String? _exception;
  List<Movie> _movies = [];

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
      final movies = await MovieTmdbWebService.getPopular();
      setState(() {
        _movies = movies;
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
    return MovieList(
      movies: _movies,
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
