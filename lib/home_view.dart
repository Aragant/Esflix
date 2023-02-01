import 'package:esflix/theme/app_text_theme.dart';
import 'package:esflix/theme/dark_theme.dart';
import 'package:flutter/material.dart';
import 'features/movie/presentation/movie_popular_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

// A view that displays a title and a list of movies.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8.0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        title: const Text('ESFLIX', style: AppTexteTheme.logoText),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'POPULAR MOVIES',
              style: AppTexteTheme.title,
            ),
          ),
          Expanded(
            child: MoviePopularView(),
          ),
        ],
      ),
    );
  }
}
