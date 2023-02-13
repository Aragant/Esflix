import 'package:esflix/features/movie/application/movie_TMDB_web_service.dart';
import 'package:esflix/theme/app_text_theme.dart';
import 'package:flutter/material.dart';

import '../features/movie/domain/movie.dart';
import '../features/movie/presentation/movie_review.dart';

class ContentMediaDetail extends StatefulWidget {
  final int id;

  const ContentMediaDetail({super.key, required this.id});

  @override
  State<ContentMediaDetail> createState() => _ContentMediaDetailState();
}

class _ContentMediaDetailState extends State<ContentMediaDetail> {
  bool _isLoading = true;
  String? _exception;
  Movie? _movie;

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
      final movie = await MovieTmdbWebService.getDetails(widget.id);

      setState(() {
        _movie = movie;
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

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoading();
    } else if (_exception != null) {
      return _buildError();
    } else if (_movie == null) {
      return _buildMoviesIsEmpty();
    } else {
      return _buildDetail();
    }
  }

  Widget _buildDetail() {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Image.network(
                    'https://image.tmdb.org/t/p/w500${_movie!.backdropUrl}',
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      _movie!.title,
                      style: AppTexteTheme.title,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${_movie!.rating.toString()}/10',
                              style: AppTexteTheme.content,
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.red,
                            ),
                            Text(
                              _movie!.releaseDate,
                              style: AppTexteTheme.content,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      _movie!.description,
                      style: AppTexteTheme.content,
                    ),
                    const SizedBox(height: 30),
                    const Text("Commentaires", style: AppTexteTheme.title),
                    const SizedBox(height: 30),
                    MovieCommentary(id: widget.id),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
