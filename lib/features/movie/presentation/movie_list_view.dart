import 'package:esflix/common_widgets/content_media_card.dart';
import 'package:flutter/material.dart';

import '../domain/movie.dart';

class MovieListView extends StatelessWidget {
  final List<Movie> movies;
  VoidCallback watchlistCallback;
  final int idList;

  MovieListView({
    super.key,
    required this.movies,
    required this.watchlistCallback,
    this.idList = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return ContentMediaCard(
          id: movies[index].id,
          title: movies[index].title,
          urlImg: movies[index].posterPath,
          genre: movies[index].genres[0].name,
          reloadList: watchlistCallback,
          idList: idList,
        );
      },
    );
  }
}
