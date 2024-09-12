import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sample_project/src/blocs/search_bloc.dart';

import '../blocs/images_bloc.dart';
import '../models/images.dart';
import '../resources/repository.dart';
import 'image_details.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key, required this.query});

  final String query;

  @override
  State<SearchView> createState() => _ImageViewState();
}

class _ImageViewState extends State<SearchView> {
  late SearchBloc _searchBloc;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchBloc = SearchBloc(repository: Repository());
    _searchBloc.fetchImages(1, widget.query);

    // Add a listener for pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _searchBloc.fetchNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Search',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        // Loading Indicator
        StreamBuilder<bool>(
          stream: _searchBloc.isLoading,
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
            stream: _searchBloc.allImages,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final images = snapshot.data!;
                return GridView.builder(
                  controller: _scrollController,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    final image = images[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to the ImageDetailsPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ImageDetailsPage(image: image),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Image.network(image.urls?.regular ?? ''),
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Number of items per row
                    crossAxisSpacing:
                        0.0, // Horizontal space between grid items
                    mainAxisSpacing: 0.0, // Vertical space between grid items
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
}
