import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teleplay/components/search_results_movie_tile.dart';
import 'package:teleplay/screens/home/controller/downloads_controller.dart';
import 'package:teleplay/screens/home/controller/movie_controller.dart';
import 'package:teleplay/screens/home/models/movie_model.dart';
import 'package:teleplay/screens/home/models/search_movie_model.dart';
import 'package:teleplay/screens/video_player.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<MovieModel>? mediaResults;
  MovieController _movieController = MovieController();
  void showMediaDetails(SearchMovieDataModel searchMovieDataModel) {
    getMediaData(searchMovieDataModel.magnet);
    showModalBottomSheet(
        clipBehavior: Clip.antiAlias,
        elevation: 1.5,
        enableDrag: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        context: context,
        builder: (context) => StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              Future.delayed(Duration.zero, () => setState(() {}));
              return Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
                  color: Colors.blue[200],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 5,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          "Select one among the below media files to start streaming",
                          style: TextStyle(
                              color: Colors.blue[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        mediaResults == null
                            ? CupertinoActivityIndicator(
                                color: Colors.blue[900],
                              )
                            : SizedBox(
                                height: 300,
                                child: ListView.builder(
                                    itemCount: mediaResults?.length ?? 0,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        trailing: IconButton(
                                            onPressed: () {
                                              DownloadsController().downloadFile(
                                                  'http://159.65.242.239/stream?magnet=${searchMovieDataModel.magnet}&filePath=${mediaResults![index].path}');
                                              Navigator.of(context).pop();
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Download started in background",
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.CENTER,
                                                  backgroundColor: Colors.blue,
                                                  textColor: Colors.white,
                                                  fontSize: 14.0);
                                            },
                                            icon: const Icon(
                                              Icons.download_rounded,
                                              color: Colors.white,
                                              size: 30,
                                            )),
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VideoPlayerPage(
                                                          movieList:
                                                              mediaResults,
                                                          magnetLink:
                                                              searchMovieDataModel
                                                                  .magnet,
                                                          movieModel: MovieModel(
                                                              name: mediaResults![
                                                                      index]
                                                                  .name,
                                                              path:
                                                                  mediaResults![
                                                                          index]
                                                                      .path,
                                                              size:
                                                                  mediaResults![
                                                                          index]
                                                                      .size))));
                                        },
                                        leading: mediaResults![index]
                                                    .name
                                                    .contains("mp4") ||
                                                mediaResults![index]
                                                    .name
                                                    .contains("mkv")
                                            ? const Icon(
                                                Icons.movie,
                                                color: Colors.white,
                                                size: 36,
                                              )
                                            : const Icon(
                                                Icons.file_open_rounded,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                        title: Text(
                                          maxLines: 1,
                                          mediaResults![index].name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        subtitle: Text(
                                          mediaResults![index].size,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      );
                                    }),
                              ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  void getMediaData(String magnetLink) async {
    setState(() {
      mediaResults = null;
    });
    mediaResults = await _movieController.fetchMediaData(magnetLink);
    print(mediaResults);
    setState(() {});
  }

  Future<List<SearchMovieDataModel>> getHistoryItems() async {
    final prefs = await SharedPreferences.getInstance();

    // Get the list of history items
    final history = prefs.getStringList('history') ?? [];

    // Convert the list of strings back to a list of SearchMovieDataModel
    return history.map((itemString) {
      final parts = itemString.split('~');
      print(parts);

      return SearchMovieDataModel(
        title: parts[0],
        time: parts[1],
        seeds: int.parse(parts[2]),
        peers: double.parse(parts[3]).toInt(),
        size: parts[4],
        magnet: parts[5],
      );
    }).toList();
  }

  var historyItems = <SearchMovieDataModel>[];

  @override
  void initState() {
    getHistoryItems().then((value) {
      setState(() {
        historyItems = value;
        historyItems = historyItems.reversed.toList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "History",
            style: TextStyle(
                color: Colors.blue, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (historyItems.isNotEmpty)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: historyItems.length,
                      itemBuilder: (context, index) {
                        return SearchResultsMovieTile(
                            isHistory: true,
                            searchMovieDataModel: historyItems[index],
                            onTap: () {
                              showMediaDetails(historyItems[index]);
                            });
                      },
                    ),
                  ),
                )
              else
                const Text(
                  "No history available",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
