import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/Websocket_service.dart';
import '../controllers/auth_controller.dart';
import '../controllers/sock_controller.dart';
import '../controllers/tab_controllers.dart';

class ArtPage extends StatelessWidget {
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
            Obx(() => Text('${tabController.userData.value.name}')),
            Obx(() => Column(
                  children: [
                    Text('${tabController.userData.value.peserta.join(', ')}'),
                    Text(
                        '${tabController.userData.value.partai} - ${tabController.userData.value.kontingen.join(', ')}'),
                  ],
                )),
            Obx(() => Text(sock.timer.value)),
          ],
        ),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: Icon(Icons.replay_outlined),
            onPressed: () {
              _authController.logout();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(3.0),
                      height: 200,
                      child: Obx(() => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tabController.button.value
                                ? Colors.red
                                : Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            tabController.button.value
                                ? tabController.addArt("0.01", 'press')
                                : null;
                          },
                          child: Icon(
                            Icons.cancel_outlined,
                            size: 60,
                          ))),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(3.0),
                      height: 200,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {},
                          child: Obx(() => Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'SKOR KEBENARAN',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    '${tabController.modVal.value}',
                                    style: TextStyle(fontSize: 48),
                                  ),
                                ],
                              ))),
                    ),
                  ),
                ],
              ),
              ButtonList(),
            ],
          ),
        ),
      ),
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
}

class ButtonList extends StatelessWidget {
  final TabControllers tabController = Get.put(TabControllers());
  @override
  Widget build(BuildContext context) {
    final values = List<double>.generate(10, (index) => (index + 1) * 0.01);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      height: 60.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: values.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            child: Obx(() => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tabController.active == index &&
                            tabController.buttonPower.value == false
                        ? Colors.blueGrey
                        : Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    tabController.buttonPower.value
                        ? tabController.addPower(
                            '${values[index]}', 'power', index)
                        : null;
                  },
                  child: Text(values[index].toStringAsFixed(2)),
                )),
          );
        },
      ),
    );
  }
}
