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
    } catch (error) {
      rethrow;
    }
  }
}


