import 'package:esflix/features/list/application/list_tmdb_web_service.dart';
import 'package:esflix/features/list/domain/list_detail.dart';

import '../../movie/domain/movie.dart';

class ListService {
  static Future<void> init() async {
    if (!(await watchListIsPresent())) {
      await createWatchList();
    }
  }

  static Future<bool> watchListIsPresent() async {
    List<ListDetail> lists = await ListTmdbWebService.getLists();
    return lists.any((element) => element.name == "Watchlist");
  }

  static Future<bool> createWatchList() async {
    return await ListTmdbWebService.createList("Watchlist", "Watchlist");
  }

  static Future<ListDetail> getWatchList() async {
    List<ListDetail> lists = await ListTmdbWebService.getLists();
    return lists.firstWhere((element) => element.name == "Watchlist");
  }

  static Future<int> getWatchListId() async {
    ListDetail watchList = await getWatchList();
    return watchList.id;
  }

  static Future<List<Movie>> getWatchListMovies() async {
    ListDetail watchList = await getWatchList();
    return await ListTmdbWebService.getListMovies(watchList.id);
  }


 
  static Future<bool> addMovieToWatchlist(int idMovie) async{
    ListDetail watchList = await getWatchList();
    return await ListTmdbWebService.addMovieToList(watchList.id, idMovie);
  }


}