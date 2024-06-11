import 'package:Match/main_page.dart';
import 'package:Match/point_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Match/home_page.dart';
import 'package:get_storage/get_storage.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isLoggedIn = await checkLoginStatus();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

Future<bool> checkLoginStatus() async {
  GetStorage box = GetStorage();
  bool isLoggedIn = box.read('isLoggedIn') ?? false;
  return isLoggedIn;
}

croute() async {
  GetStorage box = GetStorage();
  bool iswasit = box.read('wasit') ?? false;

  if (iswasit) {
    return '/main';
  } else {
    return '/home';
  }
}

class AuthMiddleware extends GetMiddleware {}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        initialRoute: isLoggedIn ? croute() : '/login',
        getPages: [
          GetPage(name: '/login', page: () => LoginPage()),
          GetPage(
            name: '/home',
            page: () => HomePage(),
            middlewares: [],
          ),
          GetPage(
            name: '/main',
            page: () => MainPage(),
            middlewares: [],
          ),
          GetPage(
            name: '/point',
            page: () => PointPage(),
            middlewares: [],
          ),
        ]);
  }
}
