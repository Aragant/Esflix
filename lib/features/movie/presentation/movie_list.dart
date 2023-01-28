import 'package:esflix/common_widgets/content_media_card.dart';
import 'package:flutter/material.dart';

import '../domain/movie.dart';

class MovieList extends StatelessWidget {
  final List<Movie> movies;

  const MovieList({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return ContentMediaCard(title: movies[index].title, urlImg: movies[index].posterPath, genre: movies[index].genres[0].name);
      },
    );
  }
}