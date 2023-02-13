import 'package:esflix/features/movie/application/movie_TMDB_web_service.dart';
import 'package:esflix/features/movie/domain/review.dart';
import 'package:flutter/material.dart';


class MovieCommentary extends StatefulWidget {
  final int id;

  const MovieCommentary({super.key, required this.id});

  @override
  State<MovieCommentary> createState() => _MovieReview();

}

class _MovieReview extends State<MovieCommentary> {
  bool _isLoading = true;
  String? _exception;
  List<MovieReview> _movieReview = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    setState(() {
      _isLoading = true;
    });

    try{
      final movieReview = await MovieTmdbWebService.getReviewsFromMovie(widget.id);
      setState(() {
        _movieReview = movieReview;
        _isLoading = false;
      });
    }
    catch(error){
      if(mounted){
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
    } else if (_movieReview == null) {
      return _buildMoviesIsEmpty();
    } else {
      return _buildDetail();
    }
  }

    Widget _buildDetail(){
      return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _movieReview.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text(_movieReview[index].author),
                Text(_movieReview[index].content),
              ],
            ),
          );
        },
      );
    }
  }