import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animepix/app/data/models/wallpaper_model.dart';
import 'package:animepix/app/data/repositories/wallpaper_repository.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  final WallpaperRepository _repository = Get.find<WallpaperRepository>();
  
  final RxList<WallpaperModel> wallpapers = <WallpaperModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxInt currentPage = 1.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = ''.obs;
  
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  
  late TabController tabController;
  
  final List<String> categories = [
    'All',
    'Anime',
    'General',
    'People',
  ];
  
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: categories.length, vsync: this);
    loadWallpapers();
    
    // Pagination listener
    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent * 0.8) {
        loadMoreWallpapers();
      }
    });
  }
  
  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    tabController.dispose();
    super.onClose();
  }
  
  Future<void> loadWallpapers() async {
    try {
      isLoading.value = true;
      currentPage.value = 1;
      
      List<WallpaperModel> newWallpapers;
      
      if (searchQuery.value.isNotEmpty) {
        newWallpapers = await _repository.searchWallpapers(searchQuery.value);
      } else if (selectedCategory.value == 'Anime') {
        newWallpapers = await _repository.getAnimeWallpapers();
      } else {
        newWallpapers = await _repository.getWallpapers();
      }
      
      wallpapers.value = newWallpapers;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load wallpapers: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> loadMoreWallpapers() async {
    if (isLoadingMore.value) return;
    
    try {
      isLoadingMore.value = true;
      currentPage.value++;
      
      List<WallpaperModel> newWallpapers;
      
      if (searchQuery.value.isNotEmpty) {
        newWallpapers = await _repository.searchWallpapers(
          searchQuery.value,
          page: currentPage.value,
        );
      } else if (selectedCategory.value == 'Anime') {
        newWallpapers = await _repository.getAnimeWallpapers(page: currentPage.value);
      } else {
        newWallpapers = await _repository.getWallpapers(page: currentPage.value);
      }
      
      wallpapers.addAll(newWallpapers);
    } catch (e) {
      currentPage.value--;
      Get.snackbar('Error', 'Failed to load more wallpapers: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }
  
  void onSearchChanged(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      loadWallpapers();
    }
  }
  
  void onSearchSubmitted(String query) {
    searchQuery.value = query;
    loadWallpapers();
  }
  
  void onCategoryChanged(int index) {
    selectedCategory.value = categories[index];
    loadWallpapers();
  }
  
 Future<void> refreshWallpapers() async {
  await loadWallpapers();
}
}