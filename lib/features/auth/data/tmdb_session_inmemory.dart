import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/shared_preferences_utils.dart';

class TmdbSessionInMemory{

  static Future<bool> setSessionId(String sessionId) async {
    return await SharedPreferencesUtils.setString('session_id', sessionId);
  }

  static Future<String?> getSessionId() async {
    return await SharedPreferencesUtils.getString('session_id');
  }

  static Future<bool> deleteSessionId() async {
    return await SharedPreferencesUtils.setString('session_id', '');
  }


}