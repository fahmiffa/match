import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());

  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match One'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: codeController,
                decoration: InputDecoration(labelText: 'Code Access'),
              ),
              SizedBox(height: 20),
              Container(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    _authController.login(codeController.text);
                  },
                  child: Text('Access',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
                ),
              ),
              SizedBox(height: 20),
               Obx(() {
                return _authController.Bsync.value ? sync() : SizedBox(height: 5);
               }),
            ],
          ),
        ),
      ),
    );
  }

  Widget sync() {
    return Container(
      width: 200,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          _authController.getDeviceSerial();
        },
        child: Text('Sync',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
