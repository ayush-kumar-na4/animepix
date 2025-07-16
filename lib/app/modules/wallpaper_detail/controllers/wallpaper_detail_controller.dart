import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:gal/gal.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:animepix/app/data/models/wallpaper_model.dart';
import 'package:animepix/app/modules/favorites/controllers/favorites_controller.dart';

class WallpaperDetailController extends GetxController {
  final WallpaperModel wallpaper = Get.arguments;
  final FavoritesController favoritesController =
      Get.find<FavoritesController>();

  final RxBool isDownloading = false.obs;
  final RxDouble downloadProgress = 0.0.obs;
  final RxBool isFullScreen = false.obs;

  Future<void> downloadWallpaper() async {
    try {
      // Request storage permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        Get.snackbar(
          'Permission Denied',
          'Storage permission is required to download wallpapers',
        );
        return;
      }

      isDownloading.value = true;
      downloadProgress.value = 0.0;

      final dio = Dio();
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/${wallpaper.id}.jpg';

      await dio.download(
        wallpaper.path,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgress.value = received / total;
          }
        },
      );

      // Save to gallery using gal
      await Gal.putImage(filePath);
      Get.snackbar('Success', 'Wallpaper downloaded successfully');

      // Clean up temp file
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to download wallpaper: $e');
    } finally {
      isDownloading.value = false;
      downloadProgress.value = 0.0;
    }
  }

  void toggleFavorite() {
    favoritesController.toggleFavorite(wallpaper);
  }

  void toggleFullScreen() {
    isFullScreen.value = !isFullScreen.value;
  }

  bool get isFavorite => favoritesController.isFavorite(wallpaper);
}
