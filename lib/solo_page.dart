import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/Websocket_service.dart';
import 'controllers/auth_controller.dart';
import 'controllers/reltime_controller.dart';
import 'controllers/sock_controller.dart';
import 'controllers/tab_controllers.dart';

class SoloPage extends StatelessWidget {
  final RealtimeController dataReal = Get.put(RealtimeController());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyPage(),
    );
  }
}

// ignore: must_be_immutable
class MyPage extends StatelessWidget {
  final TabControllers tabController = Get.put(TabControllers());
  final AuthController _authController = Get.put(AuthController());
  final SockController sock = Get.put(SockController());
  final WebSocketService _webSocketService = Get.put(WebSocketService());
  int numb = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Penilaian'),
              Obx(() => Text(tabController.userData.value.peserta.join(', '))),
              Obx(() => Text(sock.timer.value)),
            ],
          ),
          backgroundColor: Colors.blueGrey,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _authController.checkLoginStatus();
              },
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            controller: tabController.tabController,
            tabs: tabController.tabs,
          )),
      body: Obx(() => TabBarView(
            controller: tabController.tabController,
            children: tabController.tabs.map((Tab tab) {
              return Center(
                child: Tombol('${numb++}'),
              );
            }).toList(),
          )),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text(_webSocketService.logger.value)],
            )),
      ),
    );
  }

  Widget Tombol(String j) {
    return Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            tabController.dataVal.contains(int.parse(j))
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Done'),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              // tabController.addArt("0", j);
                            },
                            child: Text('Wrong Move')),
                      ),
                      Container(
                        width: 120,
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              // tabController.addArt("1", j);
                            },
                            child: Text('Next Move')),
                      ),
                    ],
                  ),
          ],
        ));
  }
}
