import 'dart:async';

import 'package:sample_project/src/models/images';
import 'package:sample_project/src/resources/image_api_provider.dart';


class Repository {
  final moviesApiProvider = ImageApiProvider();

  Future<Images> fetchAllMovies({required int page}) => moviesApiProvider.fetchImageList(page: page);
}