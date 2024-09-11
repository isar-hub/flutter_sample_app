import 'dart:async';

import 'package:sample_project/src/models/images.dart';
import 'package:sample_project/src/resources/image_api_provider.dart';


class Repository {
  final moviesApiProvider = ImageApiProvider();

  Future<List<Images>> fetchAllMovies({required int page}) => moviesApiProvider.fetchImageList(page: page);
}