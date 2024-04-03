import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:teleplay/components/search_results_movie_tile.dart';
import 'package:teleplay/screens/home/controller/downloads_controller.dart';
import 'package:teleplay/screens/home/controller/movie_controller.dart';
import 'package:teleplay/screens/home/models/movie_model.dart';
import 'package:teleplay/screens/home/models/search_movie_model.dart';
import 'package:teleplay/screens/video_player.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  TextEditingController _magnetLinkController = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  MovieController _movieController = MovieController();
  List<MovieModel>? mediaResults;
  List<SearchMovieDataModel>? searchResults;
  bool isSearching = false;
  bool isMusic = false;
  bool showToggle = true;

  void _initSpeech() async {
    try {
      _speechEnabled = await _speechToText.initialize();
    } catch (e) {
      print(e.toString());
    }

    setState(() {});
  }

  void _startListening() async {
    Fluttertoast.showToast(
        msg: "Speak Now",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.white,
        textColor: Colors.blue,
        fontSize: 16.0);
    try {
      await _speechToText.listen(onResult: _onSpeechResult);
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Text to speech not available"),
        ),
      );
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      print(result.recognizedWords.toString());
      _searchController.text = result.recognizedWords.toString();
      searchMovies(result.recognizedWords.toString());
    });
  }

  @override
  void initState() {
    _initSpeech();
    super.initState();
  }

  void pickMagnetfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['torrent'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      print(file.name);
      searchMovies(file.name);
    }
  }

  void fetchMedia() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.blue[400],
        title: const Text(
          "Add File",
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select the file you want to upload",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _magnetLinkController,
              decoration: const InputDecoration(
                hoverColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                hintText: "Paste link here",
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    pickMagnetfile();
                  },
                  child: const Text(
                    "Select magnet File",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
            )
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _magnetLinkController.clear();
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();

              showMediaDetails(SearchMovieDataModel(
                magnet: _magnetLinkController.text,
                title: '',
                time: '',
                seeds: 0,
                peers: 0,
                size: '',
              ));
              _magnetLinkController.clear();
            },
            child: const Text(
              "Open",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> addHistoryItem(SearchMovieDataModel item) async {
    final prefs = await SharedPreferences.getInstance();

    // Convert the history item to a string
    final itemString =
        '${item.title}~${item.time}~${item.seeds}~${item.peers}~${item.size}~${item.magnet}';

    // Get the current list of history items
    final history = prefs.getStringList('history') ?? [];

    // Add the new item to the list
    history.add(itemString);

    // Save the updated list
    await prefs.setStringList('history', history);
  }

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
                                          addHistoryItem(searchMovieDataModel);
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

  void searchMovies(String query) async {
    setState(() {
      showToggle = false;
      isSearching = true;
    });

    searchResults = await _movieController.searchMovies(query);
    setState(() {
      isSearching = false;
    });
    print(searchResults);
    if (searchResults!.isEmpty) {
      Fluttertoast.showToast(
          msg: "No results found, check spelling and try again",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80,
          title: Container(
            margin: const EdgeInsets.only(top: 2),
            child: SearchBar(
              onSubmitted: (value) {
                searchMovies(value);
              },
              controller: _searchController,
              textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
                (states) => const TextStyle(color: Colors.white),
              ),
              trailing: [
                IconButton(
                    onPressed: _speechToText.isNotListening
                        ? _startListening
                        : _stopListening,
                    icon: Icon(
                      _speechToText.isNotListening ? Icons.mic : Icons.mic_off,
                      color: Colors.white,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.qr_code,
                      color: Colors.white,
                    )),
              ],
              shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
                (states) => RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              leading: const Icon(
                Icons.search,
                size: 30,
                color: Colors.white,
              ),
              hintStyle: MaterialStateProperty.resolveWith<TextStyle?>(
                (states) => const TextStyle(color: Colors.white),
              ),
              backgroundColor: MaterialStateProperty.all<Color?>(Colors.blue),
              elevation: MaterialStateProperty.all<double?>(0),
              hintText: "Search in Torrents",
            ),
          ),
        ),
        body: Stack(children: [
          Center(
            child: isSearching
                ? const CupertinoActivityIndicator()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        itemCount: searchResults?.length ?? 0,
                        itemBuilder: (context, index) {
                          return SearchResultsMovieTile(
                              onTap: () =>
                                  showMediaDetails(searchResults![index]),
                              searchMovieDataModel: searchResults![index]);
                        }),
                  ),
          ),
          showToggle
              ? Positioned(
                  left: 15,
                  child: Switch(
                      thumbIcon: MaterialStateProperty.resolveWith<Icon?>(
                        (states) => Icon(
                          Icons.music_note,
                          color: !isMusic ? Colors.blue : Colors.white,
                        ),
                      ),
                      trackOutlineWidth: MaterialStateProperty.all<double?>(0),
                      activeColor: Colors.blue,
                      activeTrackColor: Colors.blue[200],
                      inactiveTrackColor: Colors.grey[300],
                      inactiveThumbColor: Colors.blue[500],
                      value: isMusic,
                      onChanged: (value) {
                        setState(() {
                          isMusic != isMusic;
                          isMusic = value;
                        });
                      }))
              : Container()
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            fetchMedia();
          },
          backgroundColor: Colors.blue,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
