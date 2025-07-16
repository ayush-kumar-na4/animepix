class WallpaperModel {
  final String id;
  final String url;
  final String path;
  final String category;
  final String purity;
  final String resolution;
  final String fileSize;
  final String views;
  final String favorites;
  final String thumbs;
  final String colors;
  final List<String> tags;

  WallpaperModel({
    required this.id,
    required this.url,
    required this.path,
    required this.category,
    required this.purity,
    required this.resolution,
    required this.fileSize,
    required this.views,
    required this.favorites,
    required this.thumbs,
    required this.colors,
    required this.tags,
  });

  factory WallpaperModel.fromJson(Map<String, dynamic> json) {
    return WallpaperModel(
      id: json['id'].toString(),
      url: json['url'] ?? '',
      path: json['path'] ?? '',
      category: json['category'] ?? '',
      purity: json['purity'] ?? '',
      resolution: json['resolution'] ?? '',
      fileSize: json['file_size'].toString(),
      views: json['views'].toString(),
      favorites: json['favorites'].toString(),
      thumbs: json['thumbs']?['small'] ?? '',
      colors: (json['colors'] as List?)?.join(', ') ?? '',
      tags: (json['tags'] as List?)?.map((tag) => tag['name'].toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'path': path,
      'category': category,
      'purity': purity,
      'resolution': resolution,
      'file_size': fileSize,
      'views': views,
      'favorites': favorites,
      'thumbs': thumbs,
      'colors': colors,
      'tags': tags,
    };
  }
}