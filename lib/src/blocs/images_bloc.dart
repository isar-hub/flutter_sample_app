
import 'dart:async';
import 'package:sample_project/src/models/images.dart';
import 'package:sample_project/src/resources/repository.dart';

class ImageBloc {
  final Repository repository;

  // Pagination properties
  int _currentPage = 1;
  List<Images> _allImages = [];

  // BehaviorSubject for images and loading state
  final StreamController<List<Images>> _imagesController = StreamController<List<Images>>();
  final StreamController<bool> _loadingController = StreamController<bool>();
  ImageBloc({required this.repository});

  Stream<List<Images>> get allImages => _imagesController.stream;
  Stream<bool> get isLoading => _loadingController.stream;
  // Fetch images and manage pagination
  Future<void> fetchImages(int page) async {
      _loadingController.add(true); // Emit loading state
    try {
      final List<Images> newImages = await repository.fetchAllMovies(page: page);
      if(page ==1){
        _allImages = newImages;
      }
      else{
        _allImages.addAll(newImages);
      }
     _imagesController.add(_allImages);// Emit images data to stream
      _currentPage = page; // Update current page
    } catch (error) {
       _imagesController.addError('Failed to load images $error');
    }
    _loadingController.add(false); // Stop loading state
  }

  // Method to fetch next page (for pagination)
  fetchNextPage()async {
    fetchImages(_currentPage + 1); // Increment page and fetch new data
  }

  // Dispose streams
  void dispose() {
    _imagesController.close();
    _loadingController.close();
  }
}
