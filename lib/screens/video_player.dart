import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:teleplay/screens/home/models/movie_model.dart';

/// Stateful widget to fetch and then display video content.
class VideoPlayerPage extends StatefulWidget {
  VideoPlayerPage(
      {Key? key,
      required this.movieModel,
      required this.magnetLink,
      this.movieList = const []})
      : super(key: key);
  final MovieModel movieModel;
  final String magnetLink;
  List<MovieModel>? movieList = [];

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VlcPlayerController _videoPlayerController;
  bool _isPlaying = true;
  InterstitialAd? _interstitialAd;
  bool _isFullScreen = false;
  double _sliderValue = 0.0;
  var playbackSpeeds = [
    0.25,
    0.5,
    0.75,
    1,
    1.25,
    1.5,
    1.75,
    2,
  ];

  void showWarning() {
    Fluttertoast.showToast(
        msg: "Video will take some time to load",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.white,
        textColor: Colors.blue,
        fontSize: 12.0);
  }

  _createInterstitialAd() {
    InterstitialAd.load(
        // This is a test ad
        adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: ((ad) => _interstitialAd = ad),
            onAdFailedToLoad: (LoadAdError error) =>
                print('Failed to load an interstitial ad: ${error.message}')));
  }

  void showInterStitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          // Navigator.pop(context);
          ad.dispose();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          // Navigator.pop(context);
          ad.dispose();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  @override
  void initState() {
    showWarning();
    _createInterstitialAd();
    Future.delayed(const Duration(seconds: 10), () {
      showInterStitialAd();
    });
    _videoPlayerController = VlcPlayerController.network(
      'http://159.65.242.239/stream?magnet=${widget.magnetLink}&filePath=${widget.movieModel.path}',
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(
        advanced: VlcAdvancedOptions([
          VlcAdvancedOptions.networkCaching(
              10000), // Set network caching to 10000ms (10 seconds)
        ]),
      ),
    );

    void _listener() {
      if (_videoPlayerController.value.hasError) {
        print(
            'An error occurred: ${_videoPlayerController.value.errorDescription}');

        _videoPlayerController.removeListener(_listener);

        Fluttertoast.showToast(
            gravity: ToastGravity.BOTTOM,
            msg:
                "Video cannot be played due to low seed count. Please try another torrent",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.blue[200],
            textColor: Colors.blue[900],
            fontSize: 12.0);
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pop(context);
        });
      }
    }

// Add the listener
    _videoPlayerController.addListener(_listener);
    _videoPlayerController.addListener(_updateSliderValue);

    super.initState();
  }

  void setDefaultScreen() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  void setFullScreen() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  @override
  void dispose() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  void _updateSliderValue() {
    setState(() {
      _sliderValue = _videoPlayerController.value.position.inSeconds.toDouble();
    });
  }

  void showShareMenu() {
    showModalBottomSheet(
        clipBehavior: Clip.antiAlias,
        elevation: 1.5,
        enableDrag: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        context: context,
        builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.60,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              color: Colors.blue[200],
            ),
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Select the file you want to upload",
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const TextField(
                              maxLines: 10,
                              minLines: 5,
                              // controller: _magnetLinkController,
                              decoration: InputDecoration(
                                hoverColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                hintText: "Paste link here",
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blue[900],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: () {
                                Fluttertoast.showToast(
                                    msg: "Link copied to clipboard",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.blue[200],
                                    textColor: Colors.blue[900],
                                    fontSize: 12.0);
                                Clipboard.setData(
                                    ClipboardData(text: widget.magnetLink));
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Copy Link",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ]),
                ))));
  }

  void changePlaybackSpeed() {
    showModalBottomSheet(
        clipBehavior: Clip.antiAlias,
        elevation: 1.5,
        enableDrag: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        context: context,
        builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              color: Colors.blue[200],
            ),
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                            "Select playback speed",
                            style: TextStyle(
                                color: Colors.blue[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CupertinoPicker.builder(
                              useMagnifier: true,
                              offAxisFraction: 0.5,
                              itemExtent: 40,
                              childCount: playbackSpeeds.length,
                              onSelectedItemChanged: (value) {
                                _videoPlayerController.setPlaybackSpeed(
                                    playbackSpeeds[value].toDouble());
                              },
                              itemBuilder: (context, index) {
                                print(index);
                                return Text(
                                  playbackSpeeds[index].toString(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                );
                              }),
                        ]),
                  ),
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: _isFullScreen ? 16 / 8.5 : 16 / 9,
                  child: VlcPlayer(
                    controller: _videoPlayerController,
                    aspectRatio: _isFullScreen ? 16 / 8.3 : 16 / 9,
                    placeholder:
                        const Center(child: CupertinoActivityIndicator()),
                  ),
                ),
                Container(
                  color: Colors.black38,
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.speed),
                        onPressed: () {
                          changePlaybackSpeed();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.closed_caption),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {
                          showShareMenu();
                        },
                      ),
                      // Other options...
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black38,
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.replay_10),
                          onPressed: () {
                            _videoPlayerController.seekTo(
                              (_videoPlayerController.value.position -
                                  const Duration(seconds: 10)),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(_isPlaying == true
                              ? Icons.pause
                              : Icons.play_arrow),
                          onPressed: () {
                            setState(() {
                              _isPlaying = !_isPlaying;
                              _isPlaying
                                  ? _videoPlayerController.play()
                                  : _videoPlayerController.pause();
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.forward_10),
                          onPressed: () {
                            _videoPlayerController.seekTo(
                              (_videoPlayerController.value.position +
                                  const Duration(seconds: 10)),
                            );
                          },
                        ),
                        SizedBox(
                          width: _isFullScreen
                              ? MediaQuery.of(context).size.width * 0.70
                              : MediaQuery.of(context).size.width * 0.46,
                          child: Slider(
                            inactiveColor: Colors.white,
                            value: _sliderValue,
                            min: 0.0,
                            max: _videoPlayerController.value.duration.inSeconds
                                .toDouble(),
                            onChanged: (value) {
                              setState(() {
                                _sliderValue = _videoPlayerController
                                    .setTime(value.toInt()) as double;
                              });
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(_isFullScreen == true
                              ? Icons.fullscreen_exit
                              : Icons.fullscreen),
                          onPressed: () {
                            if (_isFullScreen == true) {
                              setDefaultScreen();
                            } else {
                              setFullScreen();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Icon(
                Icons.movie,
                size: 24,
                color: Colors.blue,
              ),
              title: Text(
                widget.movieModel.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              subtitle: Text(
                widget.movieModel.size,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.blue.shade200,
              height: 500,
              child: ListView.builder(
                  itemCount: widget.movieList?.length ?? 0,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VideoPlayerPage(
                                      movieModel: MovieModel(
                                          name: widget.movieList![index].name,
                                          path: widget.movieList![index].path,
                                          size: widget.movieList![index].size),
                                      magnetLink: widget.magnetLink,
                                      movieList: widget.movieList,
                                    )));
                      },
                      leading: widget.movieList![index].name.contains("mp4") ||
                              widget.movieList![index].name.contains("mkv")
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
                        widget.movieList![index].name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      subtitle: Text(
                        widget.movieList![index].size,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    );
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    ));
  }
}
