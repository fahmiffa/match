import 'controllers/sock_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/Websocket_service.dart';
import 'controllers/auth_controller.dart';
import 'controllers/time_controller.dart';

class TimerPage extends StatelessWidget {  
  final AuthController _authController = Get.put(AuthController());
  final TimeController timeController = Get.put(TimeController());
  final SockController sock = Get.put(SockController());
  final WebSocketService _webSocketService = Get.put(WebSocketService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text('Timer')],
        ),
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
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Text(
                            '${_authController.userData.value.contest}',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500))),
                        SizedBox(height: 20),
                        Obx(() {
                          final dataArray =
                              _authController.userData.value.peserta;
                          List<Widget> textWidgets = [];
                          for (var item in dataArray) {
                            textWidgets.add(
                              Text(
                                '- ${item}',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                            );
                          }
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: textWidgets,
                          );
                        }),
                        SizedBox(height: 10),
                        Obx(() => Text(
                              '${timeController.minutes.value.toString().padLeft(2, '0')}:${timeController.seconds.value.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red),
                            )),
                        SizedBox(height: 10),
                        Obx(() => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        timeController.isRunning.value
                                            ? Colors.red
                                            : Colors.blueGrey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    timeController.isRunning.value
                                        ? timeController.stopTimer()
                                        : timeController.startTimer();
                                  },
                                  child: Text(
                                    timeController.isRunning.value
                                        ? 'Stop'
                                        : 'Start',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                SizedBox(width: 20.0),
                                SizedBox(width: 20.0),
                              ],
                            )),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Log',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w500)),
                        SizedBox(height: 20),
                        Obx(() {
                          if (timeController.times.isEmpty) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            final da = timeController.times;
                            List<Widget> textWidgets = [];
                            for (int i = 0;
                                i < timeController.times.length;
                                i++) {
                              textWidgets.add(
                                Text(
                                  '${da[i].time}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              );
                            }
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: textWidgets,
                            );
                          }
                        }),
                      ],
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text(
                //   _webSocketService.Connected.value
                //       ? 'Connected'
                //       : 'Disconnected',
                // ),
                Text(_webSocketService.logger.value)
              ],
            )),
      ),
    );
  }
}
