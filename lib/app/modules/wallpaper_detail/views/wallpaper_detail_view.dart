import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:get/get.dart';
import 'package:animepix/app/modules/wallpaper_detail/controllers/wallpaper_detail_controller.dart';

class WallpaperDetailView extends GetView<WallpaperDetailController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.isFullScreen.value) {
          return _buildFullScreenView();
        } else {
          return _buildDetailView();
        }
      }),
    );
  }

  Widget _buildDetailView() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 950,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: GestureDetector(
              onTap: controller.toggleFullScreen,
              child: CachedNetworkImage(
                imageUrl: controller.wallpaper.path,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      color: Colors.grey[900],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      color: Colors.grey[900],
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.red, size: 50),
                      ),
                    ),
              ),
            ),
          ),
          actions: [
            Obx(
              () => IconButton(
                icon: Icon(
                  controller.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: controller.isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: controller.toggleFavorite,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.fullscreen),
              onPressed: controller.toggleFullScreen,
            ),
          ],
        ),
        SliverToBoxAdapter(child: _buildInfoSection()),
        SliverToBoxAdapter(child: _buildActionButtons()),
      ],
    );
  }

  Widget _buildFullScreenView() {
    return Stack(
      children: [
        PhotoView(
          imageProvider: CachedNetworkImageProvider(controller.wallpaper.path),
          backgroundDecoration: const BoxDecoration(color: Colors.black),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
          heroAttributes: PhotoViewHeroAttributes(tag: controller.wallpaper.id),
        ),
        Positioned(
          top: 50,
          left: 16,
          child: CircleAvatar(
            backgroundColor: Colors.black54,
            child: IconButton(
              icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
              onPressed: controller.toggleFullScreen,
            ),
          ),
        ),
        Positioned(
          top: 50,
          right: 16,
          child: CircleAvatar(
            backgroundColor: Colors.black54,
            child: Obx(
              () => IconButton(
                icon: Icon(
                  controller.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: controller.isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: controller.toggleFavorite,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wallpaper Details',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Resolution', controller.wallpaper.resolution),
          _buildInfoRow('Category', controller.wallpaper.category),
          _buildInfoRow('Views', controller.wallpaper.views),
          _buildInfoRow('Favorites', controller.wallpaper.favorites),
          _buildInfoRow(
            'File Size',
            '${(int.parse(controller.wallpaper.fileSize) / 1024 / 1024).toStringAsFixed(1)} MB',
          ),
          if (controller.wallpaper.tags.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Tags',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  controller.wallpaper.tags
                      .map(
                        (tag) => Chip(
                          label: Text(tag),
                          backgroundColor: Colors.purple.withOpacity(0.3),
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                      )
                      .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    controller.isDownloading.value
                        ? null
                        : controller.downloadWallpaper,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child:
                    controller.isDownloading.value
                        ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${(controller.downloadProgress.value * 100).toInt()}%',
                            ),
                          ],
                        )
                        : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.download, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Download',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.purple),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Back to Gallery',
                style: TextStyle(color: Colors.purple, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
