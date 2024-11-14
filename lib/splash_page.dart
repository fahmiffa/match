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
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Row(
          children: [
            Text(
              authController.isDev.value ? authController.uuid.value : 'Ringgana',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.replay_outlined),
            onPressed: () {
              authController.checkLoginStatus();
            },
          ),
        ],
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ), 
    );
  }
}
