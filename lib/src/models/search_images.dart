import 'images.dart';

class SearchImages {
  int? total;
  int? totalPages;
  List<Images>? results;

  SearchImages({
    this.total,
    this.totalPages,
    this.results,
  });

  SearchImages.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    totalPages = json['total_pages'];
    if (json['results'] != null) {
      results = <Images>[];
      json['results'].forEach((v) {
        results!.add(Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['total_pages'] = totalPages;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}