import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teleplay/screens/home/controller/downloads_controller.dart';
import 'package:teleplay/screens/home/models/search_movie_model.dart';
import 'package:flutter/services.dart';

class SearchResultsMovieTile extends StatefulWidget {
  const SearchResultsMovieTile(
      {super.key,
      required this.searchMovieDataModel,
      required this.onTap,
      this.isHistory = false});
  final SearchMovieDataModel searchMovieDataModel;
  final VoidCallback? onTap;
  final bool isHistory;

  @override
  State<SearchResultsMovieTile> createState() => _SearchResultsMovieTileState();
}

class _SearchResultsMovieTileState extends State<SearchResultsMovieTile> {
  void removeFromHistory(SearchMovieDataModel item) {
    SharedPreferences.getInstance().then((value) {
      final itemString =
          '${item.title}~${item.time}~${item.seeds}~${item.peers}~${item.size}~${item.magnet}';
      List<String> history = value.getStringList("history")!;
      history.remove(itemString);
      value.setStringList("history", history);
      setState(() {});
    });
  }

  void showPopoverMenu(BuildContext context) {
    showPopover(
        width: 200,
        arrowHeight: 15,
        arrowWidth: 30,
        arrowDxOffset: 162,
        backgroundColor: Colors.white,
        direction: PopoverDirection.top,
        context: context,
        bodyBuilder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(
                        text: widget.searchMovieDataModel.magnet));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Magnet link copied to clipboard"),
                    ));
                  },
                  child: const Text("Share"),
                ),
                widget.isHistory
                    ? TextButton(
                        onPressed: () {
                          removeFromHistory(widget.searchMovieDataModel);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Removed from history")));
                        },
                        child: const Text("Clear"),
                      )
                    : Container()
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.90,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      widget.searchMovieDataModel.time.length > 16
                          ? widget.searchMovieDataModel.time.substring(0, 16)
                          : widget.searchMovieDataModel.time,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      overflow: TextOverflow.ellipsis,
                      widget.searchMovieDataModel.title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.searchMovieDataModel.size,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Seeds: ${widget.searchMovieDataModel.seeds}",
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            const Icon(
                              Icons.thumb_up_rounded,
                              color: Colors.green,
                              size: 12,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Peers: ${widget.searchMovieDataModel.peers}",
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            const Icon(
                              Icons.thumb_down_rounded,
                              color: Colors.red,
                              size: 12,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: IconButton(
                onPressed: () async {
                  showPopoverMenu(context);
                },
                icon: const Icon(
                  Icons.more_vert_rounded,
                  size: 26,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
