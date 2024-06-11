import 'package:Match/controllers/point_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';

class HomePage extends StatelessWidget {
  final PointController _pointController = Get.put(PointController());
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              'Welcome ${_pointController.userData.value.name}',
            )),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _authController.logout();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Text(
                    '${_pointController.userData.value.contest} (${_pointController.userData.value.type})',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  )),
              SizedBox(height: 10),
              Obx(() {
                final dataArray = _pointController.userData.value.peserta;
                List<Widget> textWidgets = [];
                for (var item in dataArray) {
                  textWidgets.add(
                    Text(
                      '- ${item}',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    ),
                  );
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: textWidgets,
                );
              }),
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
                    _pointController.checkStatus();
                  },
                  child: Text('Start',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
