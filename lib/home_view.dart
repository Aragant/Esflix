import 'package:flutter/material.dart';
import 'features/movie/presentation/movie_popular_presentation.dart';

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