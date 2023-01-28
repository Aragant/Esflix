import 'package:flutter/material.dart';

class ContentMediaCard extends StatelessWidget {
  final String title;
  final String urlImg;
  final String genre;

  const ContentMediaCard({super.key, 
    required this.title,
    required this.urlImg,
    required this.genre,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: 150,
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 150,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        NetworkImage("https://image.tmdb.org/t/p/w500/$urlImg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          Container(
            
            padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
            color: Colors.grey[900],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.headline5?.fontSize,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(genre, style: Theme.of(context).textTheme.headline4),
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      constraints: const BoxConstraints(),
                      onPressed: _option,
                      icon: const Icon(Icons.more_vert),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _option() {}
}
