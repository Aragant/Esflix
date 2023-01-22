import 'package:flutter/material.dart';
import 'movie/movie_popular_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: 200,
          child: MoviePopularView(),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}