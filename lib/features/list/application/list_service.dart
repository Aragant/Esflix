import 'package:esflix/features/list/application/list_tmdb_web_service.dart';
import 'package:esflix/features/list/domain/list_detail.dart';
import 'package:esflix/features/list/domain/movie_list.dart';

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
}