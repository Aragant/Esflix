class SearchData {
  final int id;
  final String title;

  SearchData({
    required this.id,
    required this.title,
  });

  factory SearchData.fromJson(Map<String, dynamic> json) {
    return SearchData(
      id: json['id'],
      title: json['title'],
    );
  }
}