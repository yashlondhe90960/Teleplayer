import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:teleplay/screens/home/models/movie_model.dart';
import 'package:teleplay/screens/home/models/search_movie_model.dart';

class MovieController {
  Future<List<MovieModel>?> fetchMediaData(String magnetLink) async {
    final response = await http.get(
      Uri.parse('http://159.65.242.239/metadata?magnet=$magnetLink'),
    );

    if (response.statusCode == 200) {
      // Parse the response data
      var data = json.decode(response.body);
      print(data);
      List<MovieModel> myDataList =
          (data as List).map((data) => MovieModel.fromJson(data)).toList();
      return (myDataList);
    } else {
      print('Request failed with status: ${response.statusCode}');
      return null;
      // Handle errors
    }
  }

  Future<List<SearchMovieDataModel>> searchMovies(String query) async {
    print(query);
    final response = await http.get(
      Uri.parse('http://159.65.242.239/search?query=$query'),
    );
    var parsed = json.decode(response.body);
    print(parsed);
    final List<dynamic> torrentList = parsed['result'];

    return torrentList
        .map((json) => SearchMovieDataModel.fromJson(json))
        .toList();
  }
}
