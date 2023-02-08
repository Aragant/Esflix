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
  bool _isLoading = true;
  String? _exception;
  List<ListDetail> listsDetails = [];
  List<List<Movie>> listsMovies = [];
  List<String> listsNames = ["Watchlist", "Favourites", "Watched"];

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
      setState(() {
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
      length: listsNames.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Lists"),
          bottom: TabBar(
            tabs: listsNames
                .map((e) => Tab(
                      text: e,
                    ))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: listsNames
              .map((e) => ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          e,
                          style: AppTexteTheme.title,
                        ),
                      );
                    },
                    itemCount: 10,
                  ))
              .toList(),
        ),
      ),
    );
  }
}


