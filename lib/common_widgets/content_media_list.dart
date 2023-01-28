import 'package:flutter/material.dart';

class ContentMediaList extends StatelessWidget {
  final List<String> items;

  const ContentMediaList({super.key, required this.items});

  // A carousel is a widget that displays a list of items in a horizontal
  // scrollable list. It is a stateful widget because it needs to keep track
  // of the current page in order to know which items to display.
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(8),
          child: Image.network("https://image.tmdb.org/t/p/w500/${items[index]}"),
        );
      },
    );
  }
}
