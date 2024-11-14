import '../controllers/home_controller.dart';
import '../controllers/point_controller.dart';
import '../controllers/reltime_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/Websocket_service.dart';
import '../controllers/auth_controller.dart';

import '../controllers/sock_controller.dart';

class PointPage extends StatelessWidget {
  final RealtimeController dataController = Get.put(RealtimeController());
  final PointController pointController = Get.put(PointController());
  final HomeController data = Get.put(HomeController());
  final AuthController _authController = Get.put(AuthController());
  final SockController sock = Get.put(SockController());
  final WebSocketService _webSocketService = Get.put(WebSocketService());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(() => Text(data.userData.value.name)),
                Obx(() => Text(data.userData.value.kelas)),
                Obx(() => Text(data.userData.value.partai)),
                Obx(() => Text(sock.timer.value)),
              ],
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
          body: sock.isOpen.value ? Ver(sock.isVal.value) : vertical(),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Text(_webSocketService.logger.value)],
                )),
          ),
        ));
  }

  static par(x) {
    if (x == 1) {
      return 'Verifikasi Jatuhan';
    } else if (x == 2) {
      return 'Verifikasi Pembinaan';
    } else if (x == 3) {
      return 'Verifikasi Teguran';
    } else if (x == 4) {
      return 'Verifikasi Peringatan';
    }
  }

  static ver(x) {
    if (x == 1) {
      return 'drop';
    } else if (x == 2) {
      return 'coach';
    } else if (x == 3) {
      return 'teguran';
    } else if (x == 4) {
      return 'warning';
    }
  }

  Widget Ver(int x) {
    // ignore: invalid_use_of_protected_member
    final arr = pointController.peserta.value;
    return Center(
      child: Column(
        children: [
          SizedBox(height: 20),
          Text(
            par(x),
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20),
          Container(
            width: 200,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (x == 1) {
                  pointController.addValueVer(
                      '3', arr[0].id, ver(x), arr[0].type);
                }

                if (x == 2) {
                  pointController.addValueVer(
                      '0', arr[0].id, ver(x), arr[0].type);
                }

                if (x == 3) {
                  pointController.addValueVer(
                      '-1', arr[0].id, ver(x), arr[0].type);
                }

                if (x == 4) {
                  pointController.addValueVer(
                      '-5', arr[0].id, ver(x), arr[0].type);
                }
              },
              child: Text('Blue Corner',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 200,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (x == 1) {
                  pointController.addValueVer(
                      '1', arr[1].id, ver(x), arr[1].type);
                }

                if (x == 2) {
                  pointController.addValueVer(
                      '0', arr[1].id, ver(x), arr[1].type);
                }

                if (x == 3) {
                  pointController.addValueVer(
                      '-1', arr[1].id, ver(x), arr[1].type);
                }

                if (x == 4) {
                  pointController.addValueVer(
                      '-5', arr[1].id, ver(x), arr[1].type);
                }
              },
              child: Text('Red Corner',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 200,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                pointController.addValueVer(
                    '-5', arr[1].id, 'invalid', arr[1].type);
              },
              child: Text('Invalid',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }

  Widget vertical() {
    return SingleChildScrollView(
      child: Center(
        child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (var peserta in pointController.peserta)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 25),
                      Column(
                        children: [
                          Text("${peserta.name}",
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                          Text("${peserta.kontingen}",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black)),
                        ],
                      ),
                      SizedBox(height: 25),
                      AttributeP(peserta.id, peserta.type),
                    ],
                  ),
              ],
            )),
      ),
    );
  }

  static warna(id) {
    if (id == 1) {
      return Colors.blue;
    }

    if (id == 2) {
      return Colors.red;
    }
  }

  Widget AttributeP(int id, String tipe) {
    return Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var point in pointController.pointData)
              if (point.id != 3)
                Column(
                  children: [
                    Container(
                      width: 100,
                      height: 120,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: warna(id),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          pointController.addValue(
                              '${point.id}', id, point.name, tipe);
                        },
                        child: Stack(
                          children: [
                            Positioned(
                                top: 0,
                                right: 0,
                                child: Text(
                                  id == 1
                                      ? point.name == 'Hit'
                                          ? pointController.blue[0].toString()
                                          : pointController.blue[1].toString()
                                      : point.name == 'Hit'
                                          ? pointController.red[0].toString()
                                          : pointController.red[1].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                )),
                            Image.asset(
                              (point.name == 'Kick')
                                  ? 'assets/img/kick.png'
                                  : 'assets/img/hit.png',
                              width: 100,
                              height: 120,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
          ],
        ));
  }
}
