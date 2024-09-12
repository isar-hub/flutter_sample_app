import 'dart:async';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

import 'package:sample_project/src/models/images.dart';
import 'package:sample_project/src/models/search_images.dart';

class ImageApiProvider {
  Client client = Client();
  final baseUrl = dotenv.env['BASE_URL'];
  final key = dotenv.env['ACCESS_KEY'];

  Future<List<Images>> fetchImageList({required int page}) async {
    final response = await client
        .get(Uri.parse("$baseUrl/photos?page=$page&per_page=50&client_id=$key"));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Images.fromJson(json)).toList();
    } else {
      throw Exception('Failed to Load Images');
    }
  }
  Future<SearchImages> fetchSearchResult({required int page, required String query}) async {
    if (query.trim().isEmpty) {
      log("Query is empty");
      throw Exception('Search query cannot be empty');
    }
    final url = Uri.parse("$baseUrl/search/photos?page=$page&per_page=50&query=$query&client_id=$key");
    print("Fetching from URL: $url");

    final response = await client.get(
       url
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return SearchImages.fromJson(data);
    } else {
      log("code :${response.statusCode}");
      log("Error response: ${response.body}");
      throw Exception('Failed to Load Search Results');
    }
  }
}
