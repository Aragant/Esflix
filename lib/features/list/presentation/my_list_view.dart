import 'package:esflix/common_widgets/content_media_card.dart';
import 'package:esflix/features/list/application/list_tmdb_web_service.dart';
import 'package:esflix/features/list/domain/list_detail.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_text_theme.dart';
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

  bool _isLoading = true;
  String? _exception;
  List<ListDetail> _listsDetails = [];
  Map<int, List<Movie>> _listsMovies = {};
  List<String> _listsNames = [];
  List<int> _listsIds = [];

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
      List<String> listsNames = listsDetails.map((e) => e.name).toList();
      Map<int, List<Movie>> listsMovies = {
        for (var list in listsDetails)
          list.id: await ListTmdbWebService.getListMovies(list.id)
      };
      List<int> listsIds = listsDetails.map((e) => e.id).toList();
      setState(() {
        _listsDetails = listsDetails;
        _listsNames = listsNames;
        _listsMovies = listsMovies;
        _listsIds = listsIds;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _exception = error.toString();
        _isLoading = false;
      });
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
    } else if (_exception != null) {
      return _buildError();
    } else {
      return _buildListView();
    }
  }

  Widget _buildListView() {
    return DefaultTabController(
      length: _listsNames.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Lists"),
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
            tabs: _listsNames
                .map((e) => Tab(
                      text: e,
                    ))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: _listsMovies.entries
              .map((e) => Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: e.value.length,
                          itemBuilder: (context, index) {
                            return ContentMediaCard(
                              id: e.value[index].id,
                              title: e.value[index].title,
                              urlImg: e.value[index].posterPath,
                              genre: e.value[index].genres[0].name,
                              reloadList: reload,
                              idList: e.key,
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                        child: const Text("DELETE LIST"),
                        onPressed: () async {
                          reload();
                        },
                      ),
                    ],
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
              "NEW LIST",
              style: AppTexteTheme.title,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _listNameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a list name';
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
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: const Text("CREATE"),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      await ListTmdbWebService.createList(
                        _listNameController.text,
                        _listDescController.text,
                      );
                      Navigator.pop(context);
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
