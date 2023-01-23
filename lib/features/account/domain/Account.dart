class Account {
  final String username;
  final String? avatarPath;

  Account({
    required this.username,
    required this.avatarPath,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      username: json['username'] as String,
      avatarPath: json['avatar']['tmdb']['avatar_path'] as String?,
    );
  }

  factory Account.empty() {
    return Account(username: '', avatarPath: null);
  }
}
