import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class DownloadsController {
  void downloadFile(String url) async {
    final baseStorage = await getExternalStorageDirectory();
    print(baseStorage!.path);
    final taskId = await FlutterDownloader.enqueue(
      saveInPublicStorage: true,
      timeout: 90000000,
      url: url,
      headers: {
        'Content-Type': 'application/x-bittorrent',
        "Accept-Encoding": "identity"
      },
      savedDir: baseStorage.path,
      showNotification:
          true, 
      openFileFromNotification:
          true, 
    );
  }
}
