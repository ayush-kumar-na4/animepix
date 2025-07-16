import 'package:get/get.dart';
import 'package:animepix/app/data/models/wallpaper_model.dart';
import 'package:animepix/app/data/providers/api_provider.dart';

class WallpaperRepository {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  
  Future<List<WallpaperModel>> getWallpapers({
    String? query,
    String? category,
    int page = 1,
  }) async {
    return await _apiProvider.getWallpapers(
      query: query,
      category: category,
      page: page,
    );
  }
  
  Future<List<WallpaperModel>> getAnimeWallpapers({int page = 1}) async {
    return await _apiProvider.getAnimeWallpapers(page: page);
  }
  
  Future<List<WallpaperModel>> searchWallpapers(String query, {int page = 1}) async {
    return await _apiProvider.searchWallpapers(query, page: page);
  }
  
  Future<List<WallpaperModel>> getWallpapersByCategory(String category, {int page = 1}) async {
    return await _apiProvider.getWallpapersByCategory(category, page: page);
  }
}