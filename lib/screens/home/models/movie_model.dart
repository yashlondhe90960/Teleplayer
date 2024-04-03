class MovieModel {
  final String name;
  final String path;
  final String size;

  MovieModel({
    required this.name,
    required this.path,
    required this.size,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      name: json['name'] ?? '',
      path: json['path'] ?? '',
      size: json['size'] ?? '',
    );
  }
}
