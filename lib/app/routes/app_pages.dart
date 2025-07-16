import 'package:get/get.dart';
import 'package:animepix/app/modules/home/bindings/home_binding.dart';
import 'package:animepix/app/modules/home/views/home_view.dart';
import 'package:animepix/app/modules/favorites/bindings/favorites_binding.dart';
import 'package:animepix/app/modules/favorites/views/favorites_view.dart';
import 'package:animepix/app/modules/wallpaper_detail/bindings/wallpaper_detail_binding.dart';
import 'package:animepix/app/modules/wallpaper_detail/views/wallpaper_detail_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.FAVORITES,
      page: () => FavoritesView(),
      binding: FavoritesBinding(),
    ),
    GetPage(
      name: _Paths.WALLPAPER_DETAIL,
      page: () => WallpaperDetailView(),
      binding: WallpaperDetailBinding(),
    ),
  ];
}