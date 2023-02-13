class MovieReview {
    String author;
    String content;
    String id;
    String url;

    MovieReview({
      required this.author,
      required this.content,
      required this.id,
      required this.url,
    });

    factory MovieReview.fromJson(Map<String, dynamic> json) {
      return MovieReview(
        author: json['author'] as String,
        content: json['content'] as String,
        id: json['id'] as String,
        url: json['url'] as String,
      );
    }
}
