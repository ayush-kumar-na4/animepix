import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animepix/app/routes/app_pages.dart';
import 'package:animepix/app/data/providers/api_provider.dart';
import 'package:animepix/app/data/repositories/wallpaper_repository.dart';
import 'package:animepix/app/modules/home/controllers/home_controller.dart';
import 'package:animepix/app/modules/favorites/controllers/favorites_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  Get.put(ApiProvider());
  Get.put(WallpaperRepository());
  Get.put(HomeController());
  Get.put(FavoritesController());
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AnimePix',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
} 