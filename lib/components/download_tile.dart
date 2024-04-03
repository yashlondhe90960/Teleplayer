import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

class DownloadTile extends StatefulWidget {
  const DownloadTile({super.key, required this.task, this.onTap});

  final DownloadTask task;
  final VoidCallback? onTap;

  @override
  State<DownloadTile> createState() => _DownloadTileState();
}

class _DownloadTileState extends State<DownloadTile> {
  @override
  Widget build(BuildContext context) {
    if (widget.task.filename == null) return Container();
    return GestureDetector(
      onTap: () {
        try {
          FlutterDownloader.open(taskId: widget.task.taskId!);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString()),
          ));
        }
      },
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
                      height: 5,
                    ),
                    Text(
                      widget.task.status == DownloadTaskStatus.complete
                          ? "Completed"
                          : widget.task.status == DownloadTaskStatus.failed
                              ? "Failed"
                              : "Downloading",
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 250,
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            widget.task.filename ?? '',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  widget.onTap!();
                                  if (widget.task.status ==
                                      DownloadTaskStatus.paused) {
                                    FlutterDownloader.resume(
                                        taskId: widget.task.taskId);
                                  } else {
                                    FlutterDownloader.pause(
                                        taskId: widget.task.taskId);
                                  }
                                },
                                icon: Icon(
                                  widget.task.status ==
                                          DownloadTaskStatus.complete
                                      ? Icons.download_done
                                      : widget.task.status ==
                                              DownloadTaskStatus.paused
                                          ? Icons.play_circle
                                          : Icons.pause_circle,
                                  size: 30,
                                  color: Colors.blue,
                                )),
                            IconButton(
                                onPressed: () {
                                  widget.onTap!();
                                  FlutterDownloader.remove(
                                      taskId: widget.task.taskId);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 30,
                                ))
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    LinearProgressIndicator(
                      value: widget.task.status == DownloadTaskStatus.complete
                          ? 1
                          : widget.task.progress / 100,
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      DateTime.fromMillisecondsSinceEpoch(
                              widget.task.timeCreated)
                          .toUtc()
                          .toString()
                          .substring(0, 16),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
