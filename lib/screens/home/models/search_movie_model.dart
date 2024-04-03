class SearchMovieDataModel {
  final String title;
  final String time;
  final int seeds;
  final int peers;
  final String size;
  final String magnet;

  SearchMovieDataModel({
    required this.title,
    required this.time,
    required this.seeds,
    required this.peers,
    required this.size,
    required this.magnet,
  });

  factory SearchMovieDataModel.fromJson(Map<String, dynamic> json) {
    return SearchMovieDataModel(
      title: json['title'] ?? '',
      time: json['time'] ?? '',
      seeds: json['seeds'] ?? 0,
      peers: json['peers'] ?? 0,
      size: json['size'] ?? '',
      magnet: json['magnet'] ?? '',
    );
  }
}
