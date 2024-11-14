import 'controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'controllers/reltime_controller.dart';

class HomePage extends StatelessWidget {
  final HomeController _homeController = Get.put(HomeController());
  final AuthController _authController = Get.put(AuthController());
  final RealtimeController dataController = Get.put(RealtimeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              '${_homeController.userData.value.name.capitalizeFirst}',
            )),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: Icon(Icons.replay_outlined),
            onPressed: () {
              _authController.checkLoginStatus();
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
                    '${_homeController.userData.value.contest} (${_homeController.userData.value.type} ${_homeController.isMatch.value ? _homeController.userData.value.babak : ''})',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  )),
              SizedBox(height: 10),
              Obx(() {
                final dataArray = _homeController.userData.value.peserta;
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
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        dataController.matchStatus.value.status == 1
                            ? null
                            : _homeController.checkStatus();
                      },
                      child: Obx(() =>
                          dataController.matchStatus.value.status == 1
                              ? Text('Peratandingan Selesai',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500))
                              : Text('Start',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500))))),
            ],
          ),
        ),
      ),
    );
  }
}
