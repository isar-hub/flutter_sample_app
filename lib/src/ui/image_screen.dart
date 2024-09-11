import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sample_project/src/blocs/images_bloc.dart';
import 'package:sample_project/src/models/images.dart';

import 'package:sample_project/src/resources/repository.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {

  bool _searchBoolean = false;
  late ImageBloc _imageBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _imageBloc = ImageBloc(repository: Repository());
    _imageBloc.fetchImages(1); // Fetch the first page of images

    // Add a listener for pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _imageBloc
            .fetchNextPage(); // Fetch next page when scrolled to the bottom
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _imageBloc.dispose();
    super.dispose();
  }

  _searchListView(){
    return Column(
        children: [
          // Loading Indicator
          StreamBuilder<bool>(
            stream: _imageBloc.isLoading,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                return const LinearProgressIndicator();
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          // Image List
          Expanded(
            child: StreamBuilder<List<Images>>(
              stream: _imageBloc.allImages,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                   final images = snapshot.data!;
                  return GridView.builder(
                    controller: _scrollController,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final image = images[index];
                      return ListTile(
                        title:
                            Image.network(image.urls?.regular ?? ''),
                      );
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Number of items per row
                      crossAxisSpacing:
                          0.0, // Horizontal space between grid items
                      mainAxisSpacing:
                          0.0, // Vertical space between grid items
                    ),
                  );
                } else if (snapshot.hasError) {
                   if (kDebugMode) {
                     print('Error: ${snapshot.error}');
                   }
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      );
  }

  Widget _defaultImageView(){
    return Column(
        children: [
          // Loading Indicator
          StreamBuilder<bool>(
            stream: _imageBloc.isLoading,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == true) {
                return const LinearProgressIndicator();
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          // Image List
          Expanded(
            child: StreamBuilder<List<Images>>(
              stream: _imageBloc.allImages,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                   final images = snapshot.data!;
                  return GridView.builder(
                    controller: _scrollController,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      final image = images[index];
                      return ListTile(
                        title:
                            Image.network(image.urls?.regular ?? ''),
                      );
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Number of items per row
                      crossAxisSpacing:
                          0.0, // Horizontal space between grid items
                      mainAxisSpacing:
                          0.0, // Vertical space between grid items
                    ),
                  );
                } else if (snapshot.hasError) {
                   if (kDebugMode) {
                     print('Error: ${snapshot.error}');
                   }
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      );
  }

    Widget _searchTextField() {
    return TextField(
      onChanged: (String s) {
        setState(() {
         
        });
      },
      autofocus: true,
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search,
      decoration: const InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white)
        ),
        hintText: 'Search',
        hintStyle: TextStyle(
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
    );
  }
//const Text(),
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_searchBoolean ? Text('Image Gallery') : _searchTextField(),
        actions:!_searchBoolean? [
          IconButton(
            icon:const Icon(Icons.search),
            onPressed: () {  
              setState(() {
              _searchBoolean = true;  
            });
          })
        ]
        : [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _searchBoolean = false;
              });
            }
          )
        ]
      ),
      body:  !_searchBoolean ? _defaultImageView() : _searchListView()
    );
  }
}
