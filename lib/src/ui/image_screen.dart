import 'package:flutter/material.dart';
import 'package:sample_project/src/blocs/images_bloc';

import 'package:sample_project/src/resources/repository.dart';


class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  late ImageBloc _imageBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _imageBloc = ImageBloc(repository: Repository());
    _imageBloc.fetchImages(1); // Fetch the first page of images

    // Add a listener for pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _imageBloc.fetchNextPage(); // Fetch next page when scrolled to the bottom
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _imageBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Gallery'),
      ),
      body: Column(
        children: [
          // Loading Indicator
          StreamBuilder<bool>(
            stream: _imageBloc.isLoading,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                return LinearProgressIndicator();
              } else {
                return SizedBox.shrink();
              }
            },
          ),
          // Image List
          Expanded(
            child: StreamBuilder<Images>(
              stream: _imageBloc.allImages,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data!.results.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Image.network(snapshot.data!.results[index].imageUrl),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
