import 'package:get/get.dart';
import 'package:animepix/app/modules/wallpaper_detail/controllers/wallpaper_detail_controller.dart';

class WallpaperDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WallpaperDetailController>(() => WallpaperDetailController());
  }
}