import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';
import '../models/images.dart';

class ImageDetailsPage extends StatelessWidget {
  final Images image;

  const ImageDetailsPage({super.key, required this.image});



  Future<void> downloadImage(String url,BuildContext ctx)async{
    var imageId = await ImageDownloader.downloadImage(url);
    if (imageId == null) {
      return;
    }
    // Below is a method of obtaining saved image information.
    String? fileName = await ImageDownloader.findName(imageId);
    if(ctx.mounted){
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
        content: Text("Image is downloaded"),
      ));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(image.description ?? 'Image Details'),
        actions: [
          IconButton(
              onPressed: ()  {

                String? url = image.urls?.regular;
                downloadImage(url!, context);


              },
              icon: const Icon(Icons.download)
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Image.network(image.urls?.regular ?? ''),
            const SizedBox(height: 20),
            Text(
              'Likes: ${image.likes}',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Description: ${image.description ?? 'No Description'}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
