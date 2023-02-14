import 'package:esflix/common_widgets/content_media_card.dart';
import 'package:esflix/features/auth/application/auth_tmdb_web_service.dart';
import 'package:esflix/features/list/application/list_tmdb_web_service.dart';
import 'package:esflix/features/list/domain/list_detail.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_text_theme.dart';
import '../../auth/application/auth_tmdb_service.dart';
import '../../movie/domain/movie.dart';

class MyListView extends StatefulWidget {
  const MyListView({super.key});

  @override
  State<MyListView> createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  final _formKey = GlobalKey<FormState>();
  final _listNameController = TextEditingController();
  final _listDescController = TextEditingController();
  bool _isLogged = false;

  bool _isLoading = true;
  String? _exception;
  Map<ListDetail, List<Movie>> _listsMovies = {};

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<ListDetail> listsDetails = await ListTmdbWebService.getLists();
      bool logged = await AuthTmdbService.isLogged();
      listsDetails.sort((a, b) => a.name == "Watchlist" ? -1 : 1);
      Map<ListDetail, List<Movie>> listsMovies = {
        for (var list in listsDetails)
          list: await ListTmdbWebService.getListMovies(list.id)
      };
      setState(() {
        _listsMovies = listsMovies;
        _isLoading = false;
        _isLogged = logged;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _exception = error.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Text(_exception.toString()),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoading();
    }
    else if (_isLogged == false){
      return _notLogged();
    } else if (_exception != null) {
      return _buildError();
    } else {
      return _buildListView();
    }
  }

  Widget _notLogged(){
    return const Scaffold(
      body: Center(
        child: Text("Vous n'êtes pas connecté")
      ),
    );
  }

  Widget _buildListView() {
    return DefaultTabController(
      length: _listsMovies.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mes Listes"),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => newListWidget(),
                );
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.primary,
            isScrollable: true,
            tabs: _listsMovies.keys
                .map((e) => Tab(
                      text: e.name,
                    ))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: _listsMovies.entries
              .map((e) => Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.535,
                              crossAxisSpacing: 38,
                              mainAxisSpacing: 0,
                            ),
                            itemCount: e.value.length,
                            itemBuilder: (context, index) {
                              return ContentMediaCard(
                                id: e.value[index].id,
                                title: e.value[index].title,
                                urlImg: e.value[index].posterPath,
                                genre: e.value[index].genres[0].name,
                                reloadList: reload,
                                idList: e.key.id,
                              );
                            },
                          ),
                        ),
                        if (e.key.name != "Watchlist")
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ),
                            onPressed: () async {
                              await ListTmdbWebService.deleteList(e.key.id);
                              reload();
                            },
                            child: const Text("SUPPRIMER LA LISTE"),
                          ),
                      ],
                    ),
              ))
              .toList(),
        ),
      ),
    );
  }

  void reload() {
    _init();
  }

  Widget newListWidget() {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              "NOUVELLE LISTE",
              style: AppTexteTheme.title,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _listNameController,
                decoration: const InputDecoration(labelText: "Nom"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Donnez un nom à votre liste';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _listDescController,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Donnez une description';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: const Text("CRÉER"),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await ListTmdbWebService.createList(
                        _listNameController.text,
                        _listDescController.text,
                      );
                      if (mounted) Navigator.pop(context);
                      reload();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
