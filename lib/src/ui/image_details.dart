import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/images.dart';
class ImageDetailsPage extends StatefulWidget {
  const ImageDetailsPage({super.key, required this.image});
  final Images image;
  @override
  State<ImageDetailsPage> createState() => _ImageDetailsPageState();
}

class _ImageDetailsPageState extends State<ImageDetailsPage> {



  downloadImage(String url) async {

    final status = await Permission.storage.request();
    var dir = await getApplicationDocumentsDirectory();
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    if (status.isGranted) {
      await FlutterDownloader.enqueue(
        url: url,
        savedDir: dir.path,
        fileName: 'image_${url.hashCode}.jpg',
      );

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission is required to download images')),
      );
      await Permission.storage.request();
    }
  }
  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState((){ });
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
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.image.description ?? 'Image Details'),
        actions: [
          IconButton(
              onPressed: ()  {


                String? url = widget.image.urls!.regular;
                String? urlLocation = widget.image.links!.downloadLocation;
                log("Url :${url!} and location : $urlLocation");
                downloadImage(url);
                // downloadImage(url!, context);


              },
              icon: const Icon(Icons.download)
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Image.network(widget.image.urls?.regular ?? ''),
            const SizedBox(height: 20),
            Text(
              'Likes: ${widget.image.likes}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Description: ${widget.image.description ?? 'No Description'}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );;
  }
}



  // Future<void> downloadImage(String url,BuildContext ctx)async{
  //
  //   Directory? externalStorage = await getDownloadsDirectory();
  //   String? externalStoragePath = externalStorage?.path;
  //   var imageId = await ImageDownloader.downloadImage(url,destination: AndroidDestinationType.custom(directory: externalStoragePath!  ));
  //
  //   if (imageId == null) {
  //     return;
  //   }
  //   // Below is a method of obtaining saved image information.
  //   var fileName = await ImageDownloader.findName(imageId);
  //   if(ctx.mounted && fileName != null){
  //     ScaffoldMessenger.of(ctx).showSnackBar( SnackBar(
  //       content: Text("Image is downloaded : $fileName"),
  //     ));
  //   }
  //
  //
  // }


class DownloadCallback {
  static void callback(String id, DownloadTaskStatus status, int progress) {
    if (kDebugMode) {
      print(progress);
    }
  }
}