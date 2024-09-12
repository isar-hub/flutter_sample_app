
import 'dart:async';
import 'dart:developer';
import 'package:sample_project/src/models/images.dart';
import 'package:sample_project/src/models/search_images.dart';
import 'package:sample_project/src/resources/repository.dart';

class SearchBloc {
  final Repository repository;

  // Pagination properties
  int _currentPage = 1;
  List<Images> _allImages= [];
   bool temp = true;

  String _query = '';
  // BehaviorSubject for images and loading state
  final StreamController<List<Images>> _imagesController = StreamController<List<Images>>();
  final StreamController<bool> _loadingController = StreamController<bool>();
  SearchBloc({required this.repository});

  Stream<List<Images>> get allImages => _imagesController.stream;
  Stream<bool> get isLoading => _loadingController.stream;
  // Fetch images and manage pagination
  Future<void> fetchImages(int page,String query) async {
    _loadingController.add(true); // Emit loading state
    try {
      final SearchImages result =  await repository.fetSearchImages(page: page,query: query);
      final int total = result.total!;
      final int totalPage = result.totalPages!;
      log("total item $total and total page $totalPage");
      final List<Images> newImages = result.results!;
      if(page ==1){
        _allImages = newImages;
      }
      else{
        _allImages.addAll(newImages);
      }
      _imagesController.add(_allImages);// Emit images data to stream
      _currentPage = page; // Update current page
      _query = query;
    } catch (error) {
      _imagesController.addError('Failed to load images $error');
    }
    _loadingController.add(false); // Stop loading state
    if(temp){
      temp = false;
      fetchNextPage();
    }

  }

  // Method to fetch next page (for pagination)
  fetchNextPage()async {
    fetchImages(_currentPage + 1,_query); // Increment page and fetch new data
  }

  // Dispose streams
  void dispose() {
    _imagesController.close();
    _loadingController.close();
  }
}
