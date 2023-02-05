class ListDetail {
  final int id;
  final String name;
  final String description;

  ListDetail({
    required this.id,
    required this.name,
    required this.description,
  });

  factory ListDetail.fromJson(Map<String, dynamic> json) {
    return ListDetail(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }
}