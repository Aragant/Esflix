import 'package:esflix/carousel.dart';
import 'package:flutter/material.dart';

import 'movie.dart';
import 'movie_TMDB_web_service.dart';

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
      final movies = await MovieTMDBWebService.retrievePopular();
      setState(() {
        _movies = movies;
        _moviesPosterUrl = movies.map((e) => "https://image.tmdb.org/t/p/w500/${e.posterUrl}").toList();
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
    return Carousel(
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