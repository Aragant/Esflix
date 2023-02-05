import 'package:esflix/features/account/application/account_tmdb_web_service.dart';
import 'package:esflix/features/account/domain/account.dart';
import 'package:esflix/features/list/application/list_service.dart';

import 'auth_tmdb_web_service.dart';
import '../data/tmdb_session_inmemory.dart';
import '../domain/tmdb_session.dart';

class AuthTmdbService {
  static Future<void> login(String username, String password) async {
    try {
      TmdbSession.requestToken = await AuthTmdbWebService.createRequestToken();
      await AuthTmdbWebService.createSessionWithLogin(username, password);
      TmdbSession.sessionId = await AuthTmdbWebService.createSession();
      await TmdbSessionInMemory.setSessionId(TmdbSession.sessionId!);
      ListService.init();
    } catch (error) {
      rethrow;
    }
  }

  static bool isLogged() {
    return TmdbSession.sessionId != null && TmdbSession.sessionId!.isNotEmpty;
  }

  static Future<void> logout() async {
    try {
      TmdbSession.sessionId = null;
      await TmdbSessionInMemory.deleteSessionId();
    } catch (error) {
      rethrow;
    }
  }

  static Future<void> init() async {
    try {
      TmdbSession.sessionId = await TmdbSessionInMemory.getSessionId();
      TmdbSession.accoutnId = await AccountTmdbWebService.getDetails().then((value) => value.id);
    } catch (error) {
      if (error.toString().contains('Failed to load account details')) {
        await logout();
      } else {
        rethrow;
      }
    }
  }
}


