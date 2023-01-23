class Account {
  final String? username;
  final String avatarPath;

  Account({this.username, required this.avatarPath});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      username: json['username'],
      avatarPath: json['avatar']['tmdb']['avatar_path'],
    );
  }

}