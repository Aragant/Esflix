import 'package:esflix/features/list/application/list_service.dart';
import 'package:esflix/features/list/application/list_tmdb_web_service.dart';
import 'package:esflix/theme/app_text_theme.dart';
import 'package:flutter/material.dart';

enum ContentOptions {
  addToWatchList,
  share,
  report,
}

class ContentMediaCard extends StatefulWidget {
  final int id;
  final String title;
  final String urlImg;
  final String genre;
  VoidCallback reloadList;
  final int idList;

  ContentMediaCard({
    super.key,
    required this.id,
    required this.title,
    required this.urlImg,
    required this.genre,
    required this.reloadList,
    this.idList = 0,
  });

  @override
  State<ContentMediaCard> createState() => _ContentMediaCardState();
}

class _ContentMediaCardState extends State<ContentMediaCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: 150,
      height: 268,
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
                    image: NetworkImage(
                        "https://image.tmdb.org/t/p/w500/${widget.urlImg}"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 68,
            padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
            color: Colors.grey[900],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: Text(
                    widget.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTexteTheme.titleCard,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.genre,
                      style: AppTexteTheme.subTitleCard,
                    ),
                    if (widget.idList == 0) _buildPopupMenuButton(),
                    if (widget.idList != 0) _buildPopupMenuButtonOnList(),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPopupMenuButton() {
    return Container(
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
        onSelected: ((value) async {
          if (value == ContentOptions.addToWatchList) {
            if (await ListService.addMovieToWatchlist(widget.id)) {
              widget.reloadList();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(
                    'Ajouté à la watchlist',
                    style: AppTexteTheme.snackbar,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    'Déjà dans la watchlist',
                    style: AppTexteTheme.snackbar,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
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
    );
  }

  Widget _buildPopupMenuButtonOnList() {
    return Container(
      padding: const EdgeInsets.all(0),
      child: PopupMenuButton(
        padding: const EdgeInsets.all(0),
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem(
            value: ContentOptions.addToWatchList,
            child: Text('Supprimer de la liste'),
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
        onSelected: ((value) async {
          if (value == ContentOptions.addToWatchList) {
            if (await ListTmdbWebService.removeMovieFromList(
              widget.idList,
              widget.id,
            )) {
              widget.reloadList();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.green,
                  content: Text(
                    'Le film a été supprimé de la liste',
                    style: AppTexteTheme.snackbar,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    'Erreur lors de la suppression du film de la liste',
                    style: AppTexteTheme.snackbar,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
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
    );
  }
}
