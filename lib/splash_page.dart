import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController.checkLoginStatus();
    });

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text(authController.uuid.value)],
            )),
      ),
    );
  }
}
