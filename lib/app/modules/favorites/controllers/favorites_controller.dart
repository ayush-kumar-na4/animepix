import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:animepix/app/data/models/wallpaper_model.dart';

class FavoritesController extends GetxController {
  final RxList<WallpaperModel> favorites = <WallpaperModel>[].obs;
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }
  
  Future<void> loadFavorites() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList('favorites') ?? [];
      
      final List<WallpaperModel> loadedFavorites = favoritesJson
          .map((json) => WallpaperModel.fromJson(jsonDecode(json)))
          .toList();
      
      favorites.value = loadedFavorites;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load favorites: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> addToFavorites(WallpaperModel wallpaper) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList('favorites') ?? [];
      
      if (!isFavorite(wallpaper)) {
        favoritesJson.add(jsonEncode(wallpaper.toJson()));
        await prefs.setStringList('favorites', favoritesJson);
        favorites.add(wallpaper);
        Get.snackbar('Success', 'Added to favorites');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add to favorites: $e');
    }
  }
  
  Future<void> removeFromFavorites(WallpaperModel wallpaper) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList('favorites') ?? [];
      
      favoritesJson.removeWhere((json) {
        final model = WallpaperModel.fromJson(jsonDecode(json));
        return model.id == wallpaper.id;
      });
      
      await prefs.setStringList('favorites', favoritesJson);
      favorites.removeWhere((fav) => fav.id == wallpaper.id);
      Get.snackbar('Success', 'Removed from favorites');
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove from favorites: $e');
    }
  }
  
  bool isFavorite(WallpaperModel wallpaper) {
    return favorites.any((fav) => fav.id == wallpaper.id);
  }
  
  void toggleFavorite(WallpaperModel wallpaper) {
    if (isFavorite(wallpaper)) {
      removeFromFavorites(wallpaper);
    } else {
      addToFavorites(wallpaper);
    }
  }
}
