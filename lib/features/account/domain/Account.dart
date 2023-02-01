class Account {
  final int id;
  final String username;
  final String? avatarPath;

  Account({
    required this.username,
    required this.avatarPath,
    required this.id,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      username: json['username'] as String,
      avatarPath: json['avatar']['tmdb']['avatar_path'] as String?,
      id: json['id'] as int,
    );
  }

  factory Account.empty() {
    return Account(username: '', avatarPath: null, id: 0);
  }
}
