import 'art/art_page.dart';
import 'art/arts_page.dart';
import 'splash_page.dart';
import 'main_page.dart';
import 'fight/point_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_page.dart';
import 'package:get_storage/get_storage.dart';
import 'login_page.dart';
import 'solo_page.dart';
import 'timer_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(initialRoute: '/', getPages: [
      GetPage(name: '/', page: () => SplashScreen()),
      GetPage(name: '/login', page: () => LoginPage()),
      GetPage(
        name: '/solo',
        page: () => SoloPage(),
      ),
      GetPage(
        name: '/art',
        page: () => ArtPage(),
      ),
      GetPage(
        name: '/arts',
        page: () => ArtsPage(),
      ),
      GetPage(
        name: '/home',
        page: () => HomePage(),
      ),
      GetPage(
        name: '/main',
        page: () => MainPage(),
      ),
      GetPage(
        name: '/timer',
        page: () => TimerPage(),
      ),
      GetPage(
        name: '/point',
        page: () => PointPage(),
      ),
    ]);
  }
}
