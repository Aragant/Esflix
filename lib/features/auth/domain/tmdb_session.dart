
class TmdbSession {
  static String? requestToken;
  static String? sessionId;

  TmdbSession.fromJson(Map<String, dynamic> json) {
    requestToken = json['request_token'];
    sessionId = json['session_id'];
  }

  TmdbSession.setRequestTokenFromJson(Map<String, dynamic> json) {
    requestToken = json['request_token'];
  }

  TmdbSession.setSessionIdFromJson(Map<String, dynamic> json) {
    sessionId = json['session_id'];
  }
}
