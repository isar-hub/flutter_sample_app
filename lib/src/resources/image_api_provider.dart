
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../models/images';
class ImageApiProvider{
  Client client = Client();
  final  baseUrl = dotenv.env['BASE_URL'];
  final  key = dotenv.env['ACCESS_KEY'];

 
  
  Future<Images> fetchImageList({required int page}) async{
    final response = await client.get(Uri.parse("$baseUrl/photos/?client_id=$key&page=$page"));
    if(response.statusCode ==200){
      return Images.fromJson(json.decode(response.body));
    }
    else{
      throw Exception('Failed to Load Images');
    }
  }
}