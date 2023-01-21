class Movie {
  final String title;
  final String posterUrl;
  final String backdropUrl;
  final String description;
  final String releaseDate;
  final double rating;

  Movie({
    required this.title,
    required this.posterUrl,
    required this.backdropUrl,
    required this.description,
    required this.releaseDate,
    required this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      posterUrl: json['poster_path'],
      backdropUrl: json['backdrop_path'],
      description: json['overview'],
      releaseDate: json['release_date'],
      rating: json['vote_average'].toDouble(),
    );
  }
}
