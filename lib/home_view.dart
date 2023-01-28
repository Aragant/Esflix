import 'package:flutter/material.dart';
import 'features/movie/presentation/movie_popular_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});


// A view that displays a title and a list of movies.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Esflix'),
      ),
      body: const MoviePopularView(),
    ); 
  }
}
