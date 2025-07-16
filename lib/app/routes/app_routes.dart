part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const FAVORITES = _Paths.FAVORITES;
  static const WALLPAPER_DETAIL = _Paths.WALLPAPER_DETAIL;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const FAVORITES = '/favorites';
  static const WALLPAPER_DETAIL = '/wallpaper-detail';
}
