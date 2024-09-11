class Images {
  String? id;
  String? createdAt;
  int? width;
  int? height;
  String? color;
  int? likes;
  bool? likedByUser;
  String? description;
  Urls? urls;
  Links? links;

  Images(
      {this.id,
      this.createdAt,
      this.width,
      this.height,
      this.color,
      this.likes,
      this.likedByUser,
      this.description,
      this.urls,
      this.links});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    width = json['width'];
    height = json['height'];
    color = json['color'];
    likes = json['likes'];
    likedByUser = json['liked_by_user'];
    description = json['description'];
    urls = json['urls'] != null ? Urls.fromJson(json['urls']) : null;
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['width'] = width;
    data['height'] = height;
    data['color'] = color;
    data['likes'] = likes;
    data['liked_by_user'] = likedByUser;
    data['description'] = description;
    if (urls != null) {
      data['urls'] = urls!.toJson();
    }
    if (links != null) {
      data['links'] = links!.toJson();
    }
    return data;
  }
}

class Urls {
  String? regular;

  Urls({this.regular});

  Urls.fromJson(Map<String, dynamic> json) {
    regular = json['regular'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['regular'] = regular;
    return data;
  }
}

class Links {
  String? download;
  String? downloadLocation;

  Links({this.download, this.downloadLocation});

  Links.fromJson(Map<String, dynamic> json) {
    download = json['download'];
    downloadLocation = json['download_location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['download'] = download;
    data['download_location'] = downloadLocation;
    return data;
  }
}
