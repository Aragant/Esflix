import 'package:esflix/features/list/application/list_service.dart';
import 'package:esflix/features/list/application/list_tmdb_web_service.dart';
import 'package:esflix/theme/app_text_theme.dart';
import 'package:flutter/material.dart';

enum ContentOptions {
  addToWatchList,
  share,
  report,
}

class ContentMediaCard extends StatelessWidget {
  final int id;
  final String title;
  final String urlImg;
  final String genre;

  const ContentMediaCard({
    super.key,
    required this.id,
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
            height: 65,
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
                    style: AppTexteTheme.titleCard,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      genre,
                      style: AppTexteTheme.subTitleCard,
                    ),
                    Container(
                      padding: const EdgeInsets.all(0),
                      child: PopupMenuButton(
                        padding: const EdgeInsets.all(0),
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem(
                            value: ContentOptions.addToWatchList,
                            child: Text('ajouter à la watchlist'),
                          ),
                          const PopupMenuItem(
                            value: ContentOptions.share,
                            child: Text('partager'),
                          ),
                          const PopupMenuItem(
                            value: ContentOptions.report,
                            child: Text('signaler'),
                          ),
                        ],
                        onSelected: ((value) {
                          if (value == ContentOptions.addToWatchList) {
                            ListService.addMovieToWatchlist(id);
                          } else if (value == ContentOptions.share) {
                          } else if (value == ContentOptions.report) {}
                        }),
                        child: Container(
                          padding: const EdgeInsets.all(0),
                          child: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
