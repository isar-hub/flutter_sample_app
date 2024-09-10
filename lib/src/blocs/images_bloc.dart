
import 'package:rxdart/rxdart.dart';
import 'package:sample_project/src/models/images';
import 'package:sample_project/src/resources/repository.dart';

 class ImagesBloc {
  
  int _currentPage = 1;

  final _imagesFetcher = BehaviorSubject<Images>();
  final _loadingFetcher = BehaviorSubject<bool>();

  ImageBloc({required this.repository});
 late final Repository repository;
}

class ImageBloc {
  final Repository repository;

  // Pagination properties
  int _currentPage = 1;

  // BehaviorSubject for images and loading state
  final _imagesFetcher = BehaviorSubject<Images>();
  final _loadingFetcher = BehaviorSubject<bool>();

  ImageBloc({required this.repository});

  // Streams for listening in UI
  Stream<Images> get allImages => _imagesFetcher.stream;
  Stream<bool> get isLoading => _loadingFetcher.stream;

  // Fetch images and manage pagination
  fetchImages(int page) async {
    _loadingFetcher.sink.add(true); // Emit loading state
    try {
      final images = await repository.fetchAllMovies(page: page);
      _imagesFetcher.sink.add(images); // Emit images data to stream
      _currentPage = page; // Update current page
    } catch (error) {
      _imagesFetcher.sink.addError('Failed to load images');
    }
    _loadingFetcher.sink.add(false); // Stop loading state
  }

  // Method to fetch next page (for pagination)
  fetchNextPage()async {
    fetchImages(_currentPage + 1); // Increment page and fetch new data
  }

  // Dispose streams
  void dispose() {
    _imagesFetcher.close();
    _loadingFetcher.close();
  }
}
