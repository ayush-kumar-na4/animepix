import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:animepix/app/data/models/wallpaper_model.dart';

class ApiProvider {
  static const String baseUrl = 'https://wallhaven.cc/api/v1';
  static const String apiKey =
      'yIlaEBykDEUzk5BuvKATDMnL9iikOnYq'; 

  Future<List<WallpaperModel>> getWallpapers({
    String? query,
    String? category,
    int page = 1,
    int perPage = 24,
  }) async {
    try {
      final Map<String, String> params = {
        'page': page.toString(),
        'per_page': perPage.toString(),
        'apikey': apiKey,
      };

      if (query != null && query.isNotEmpty) {
        params['q'] = query;
      }

      if (category != null && category.isNotEmpty) {
        params['categories'] = category;
      }

      final uri = Uri.parse('$baseUrl/search').replace(queryParameters: params);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> wallpapers = data['data'] ?? [];

        return wallpapers
            .map((wallpaper) => WallpaperModel.fromJson(wallpaper))
            .toList();
      } else {
        throw Exception('Failed to load wallpapers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching wallpapers: $e');
    }
  }

  Future<List<WallpaperModel>> getAnimeWallpapers({
    int page = 1,
    int perPage = 24,
  }) async {
    return getWallpapers(query: 'anime', page: page, perPage: perPage);
  }

  Future<List<WallpaperModel>> searchWallpapers(
    String query, {
    int page = 1,
  }) async {
    return getWallpapers(query: query, page: page);
  }

  Future<List<WallpaperModel>> getWallpapersByCategory(
    String category, {
    int page = 1,
  }) async {
    return getWallpapers(category: category, page: page);
  }
}
