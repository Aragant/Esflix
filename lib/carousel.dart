import 'package:flutter/material.dart';

class Carousel extends StatelessWidget {
  final List<String> items;

  const Carousel({super.key, required this.items});

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
          child: Image.network(items[index]),
        );
      },
    );
  }
}
