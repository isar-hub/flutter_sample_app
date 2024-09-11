import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

import 'package:sample_project/src/models/images.dart';

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
}
