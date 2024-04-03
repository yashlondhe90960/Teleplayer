import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:teleplay/components/download_tile.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  final ReceivePort _port = ReceivePort();
  int progress = 0;
  var allTasks = [];

  @override
  void initState() {
    loadAllDownLoads();

    super.initState();

    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      progress = data[2];
      setState(() {
        loadAllDownLoads();
      });
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  void loadAllDownLoads() async {
    final tasks = await FlutterDownloader.loadTasks();
    allTasks.clear();
    for (final task in tasks!) {
      allTasks.add(task);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Downloads",
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 26)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: allTasks.length,
            itemBuilder: (context, index) {
              return DownloadTile(
                  onTap: () {
                    print("tapped");
                    loadAllDownLoads();
                    setState(() {});
                  },
                  task: allTasks[index]);
            },
          ),
        ),
      ),
    );
  }
}
