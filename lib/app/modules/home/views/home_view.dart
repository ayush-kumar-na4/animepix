import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:animepix/app/modules/home/controllers/home_controller.dart';
import 'package:animepix/app/routes/app_pages.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AnimePix'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Get.toNamed(Routes.FAVORITES),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(children: [_buildSearchBar(), _buildCategoryTabs()]),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshWallpapers,
        child: Obx(() {
          if (controller.isLoading.value && controller.wallpapers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.wallpapers.isEmpty) {
            return const Center(child: Text('No wallpapers found'));
          }

          return CustomScrollView(
            controller: controller.scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childCount: controller.wallpapers.length,
                  itemBuilder: (context, index) {
                    final wallpaper = controller.wallpapers[index];
                    return _buildWallpaperCard(wallpaper);
                  },
                ),
              ),
              if (controller.isLoadingMore.value)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.onSearchChanged,
        onSubmitted: controller.onSearchSubmitted,
        decoration: InputDecoration(
          hintText: 'Search wallpapers...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return TabBar(
      controller: controller.tabController,
      onTap: controller.onCategoryChanged,
      tabs:
          controller.categories.map((category) => Tab(text: category)).toList(),
      indicatorColor: Colors.purple,
      labelColor: Colors.purple,
      unselectedLabelColor: Colors.grey,
    );
  }

  Widget _buildWallpaperCard(wallpaper) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.WALLPAPER_DETAIL, arguments: wallpaper),
      child: Container(
        height: 325,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: wallpaper.thumbs,
            fit: BoxFit.fill,
            placeholder:
                (context, url) => Container(
                  // height: 200,
                  color: Colors.grey[900],
                  child: const Center(child: CircularProgressIndicator()),
                ),
            errorWidget:
                (context, url, error) => Container(
                  height: 200,
                  color: Colors.grey[900],
                  child: const Center(
                    child: Icon(Icons.error, color: Colors.red),
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
