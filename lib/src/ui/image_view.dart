import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../blocs/images_bloc.dart';
import '../models/images.dart';
import '../resources/repository.dart';
import 'image_details.dart';



class ImageView extends StatefulWidget {
  const ImageView({super.key,});


  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {

  late ImageBloc _imageBloc;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _imageBloc = ImageBloc(repository: Repository());

    _imageBloc.fetchImages(1);

    // Add a listener for pagination
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
     _imageBloc.fetchNextPage();

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
    return Column(
      children: [
        const Text('Home',style: TextStyle(fontSize: 18,),),
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
            stream: _imageBloc.allImages  ,
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
}
