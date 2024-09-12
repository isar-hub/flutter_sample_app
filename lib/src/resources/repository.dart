import 'dart:async';

import 'package:sample_project/src/models/images.dart';
import 'package:sample_project/src/models/search_images.dart';
import 'package:sample_project/src/resources/image_api_provider.dart';


class Repository {
  final moviesApiProvider = ImageApiProvider();
  Future<List<Images>> fetAllImages({required int page}) => moviesApiProvider.fetchImageList(page: page);
  Future<SearchImages> fetSearchImages({required int page,required String query}) => moviesApiProvider.fetchSearchResult(page: page,query: query);
}