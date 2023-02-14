import 'package:esflix/features/auth/application/auth_tmdb_service.dart';
import 'package:esflix/features/list/application/list_service.dart';
import 'package:esflix/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'features/movie/application/movie_tmdb_web_service.dart';
import 'features/movie/domain/movie.dart';
import 'features/movie/presentation/movie_list_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _isLoading = true;
  String? _exception;
  bool _isLogged = false;
  List<Movie> _moviesPopular = [];
  List<Movie> _moviesWatchlist = [];
  List<Movie> _moviesTopRated = [];
  List<Movie> _moviesUpComing = [];
  int _idWatchlist = 0;

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
      final moviesPopular = await MovieTmdbWebService.getPopular();
      final moviesTopRated = await MovieTmdbWebService.getTopRated();
      final moviesUpComing = await MovieTmdbWebService.getUpComing();

      setState(() {
        _moviesPopular = moviesPopular;

        _moviesTopRated = moviesTopRated;
        _moviesUpComing = moviesUpComing;
        _isLoading = false;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _exception = error.toString();
          _isLoading = false;
        });
      }
    }

    if (AuthTmdbService.isLogged()) {
      try {
        final moviesWatchlist = await ListService.getWatchListMovies();
        final idWatchlist = await ListService.getWatchListId();
        setState(() {
          _moviesWatchlist = moviesWatchlist;
          _idWatchlist = idWatchlist;
          _isLogged = true;
        });
      } catch (error) {
        if (mounted) {
          setState(() {
            _exception = error.toString();
            _isLoading = false;
          });
        }
      }
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
      child: Text('Pas de films'),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoading();
    } else if (_exception != null) {
      return _buildError();
    } else if (_moviesPopular.isEmpty) {
      return _buildMoviesIsEmpty();
    } else {
      return _buildHome();
    }
  }

  Widget _buildHome() {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8.0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        title: const Text(
          'ESFLIX',
          style: AppTexteTheme.logoText,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'FILMS POPULAIRES',
                style: AppTexteTheme.title,
              ),
            ),
            SizedBox(
              height: 284,
              child: MovieListView(
                  movies: _moviesPopular, watchlistCallback: _reloadWatchList),
            ),
            if (_isLogged)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'WATCHLIST',
                  style: AppTexteTheme.title,
                ),
              ),
            SizedBox(
              height: 284,
              child: MovieListView(
                movies: _moviesWatchlist,
                watchlistCallback: _reloadWatchList,
                idList: _idWatchlist,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'MIEUX NOTÉ',
                style: AppTexteTheme.title,
              ),
            ),
            SizedBox(
              height: 284,
              child: MovieListView(
                  movies: _moviesTopRated, watchlistCallback: _reloadWatchList),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'PROCHAINEMENT',
                style: AppTexteTheme.title,
              ),
            ),
            SizedBox(
              height: 284,
              child: MovieListView(
                  movies: _moviesUpComing, watchlistCallback: _reloadWatchList),
            ),
          ],
        ),
      ),
    );
  }

  void _reloadWatchList() async {
    List<Movie> moviesWatchlist = await ListService.getWatchListMovies();
    setState(() {
      _moviesWatchlist = moviesWatchlist;
    });
  }
}
