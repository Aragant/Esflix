import 'package:esflix/features/search/application/search_tmdb_web_service.dart';
import 'package:esflix/features/search/domain/search_data.dart';
import 'package:flutter/material.dart';

import '../../../common_widgets/content_media_detail.dart';
class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  bool _isLoading = true;
  bool _isSearch = false;
  String? _exception;
  String query = '';
  List<SearchData> _movies = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    setState(() {
      _isLoading = true;
    });

    if (query.isNotEmpty) {
      try {
        final movies = await SearchTmdbWebService.searchMovie(query);
        setState(() {
          _movies = movies;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _exception = e.toString();
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // AppBar With Search field
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              query = value;
              _isSearch = true;
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearch = false;
              });

              _init();
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
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

  Widget _buildQueryEmpty() {
    return const Center(
      child: Text('No query'),
    );
  }

  Widget _buildMovieEmpty() {
    return const Center(
      child: Text('No movie with this name.'),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoading();
    } else if (_exception != null) {
      return _buildError();
    } else if (query.isEmpty) {
      return _buildQueryEmpty();
    } else if (_movies.isEmpty && !_isSearch) {
      return _buildMovieEmpty();
    } else if (_movies.isNotEmpty) {
      return _buildMovieList();
    } else {
      return _buildSearch();
    }
  }

  Widget _buildSearch() {
    return Container();
  }

  Widget _buildMovieList() {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        color: Colors.white,
      ),
      itemCount: _movies.length,
      itemBuilder: (context, index) {
        final movie = _movies[index];
        return GestureDetector(
          onTap: () {
            getDetail(movie.id);
          },
          child: ListTile(
            title: Text(movie.title),
          ),
        );
      },
    );
  }

  getDetail(int id) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ContentMediaDetail(id: id),
    ));
  }
}
