// ignore_for_file: invalid_use_of_protected_member

import 'controllers/home_controller.dart';
import 'controllers/reltime_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/Websocket_service.dart';
import 'controllers/auth_controller.dart';
import 'controllers/sock_controller.dart';
import 'controllers/tab_controllers.dart';

class MainPage extends StatelessWidget {
  final RealtimeController dataController = Get.put(RealtimeController());
  final AuthController _authController = Get.put(AuthController());
  final HomeController homeController = Get.put(HomeController());
  final SockController sock = Get.put(SockController());
  final WebSocketService _webSocketService = Get.put(WebSocketService());
  final TabControllers tabController = Get.put(TabControllers());

  final List<Map<String, dynamic>> tunggal = [
    {'val': 'Penampilan melebihi batas waktu toleransi', 'index': 1},
    {'val': 'Keluar Gelanggang (10x10m)', 'index': 2},
    {'val': 'Pakain/Senjata tidak sempurna', 'index': 3},
    {'val': 'Senjata Jatuh', 'index': 4},
    {'val': 'Menahan Gerakan lebih dari 5 detik', 'index': 5},
    {
      'val': 'Berhenti dengan jarak lebih dari 1 meter dari posisi awal',
      'index': 6
    }
  ];

  final List<Map<String, dynamic>> ganda = [
    {'val': 'Penampilan melebihi waktu toleransi', 'index': 1},
    {'val': 'Keluar gelanggang', 'index': 2},
    {'val': 'Senjata jatuh tidak sesuai dengan sinopsis', 'index': 3},
    {'val': 'Senjata Jatuh di luar gelanggang', 'index': 4},
    {'val': 'Pakaian tidak sesuai persyaratan', 'index': 5},
    {'val': 'Menahan gerakan lebih dari 5 detik', 'index': 6}
  ];

  final List<Map<String, dynamic>> regu = [
    {'val': 'Penampilan melebihi waktu toleransi', 'index': 1},
    {'val': 'Keluar gelanggang (10×10m)', 'index': 2},
    {'val': 'Pakaian tidak sesuai persyaratan', 'index': 3},
    {'val': 'Menahan gerakan lebih dari 5 detik', 'index': 4}
  ];

  final List<Map<String, dynamic>> solo = [
    {'val': 'Penampilan melebihi waktu toleransi', 'index': 1},
    {'val': 'Keluar gelanggang', 'index': 2},
    {'val': 'Senjata jatuh tidak sesuai dengan sinopsis', 'index': 3},
    {'val': 'Senjata Jatuh keluar gelanggang', 'index': 4},
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => homeController.isMatch.value
        ? DefaultTabController(length: 5, child: Fight())
        : DefaultTabController(length: 2, child: Art()));
  }

  Widget Fight() {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Dewan'),
              Obx(() => Text(tabController.userData.value.kelas)),
              Obx(() => Text(tabController.userData.value.partai)),
              Obx(() => Text(tabController.userData.value.peserta.join(', '))),
              Text(sock.timer.value)
            ],
          ),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Jatuhan'),
              Tab(text: 'Pembinaan'),
              Tab(text: 'Teguran'),
              Tab(text: 'Peringatan'),
            ],
            labelStyle: TextStyle(fontSize: 13.0),
            indicatorColor: Colors.blueGrey,
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
        body: TabBarView(children: [
          Home(),
          Other("drop"),
          Other("coach"),
          Other("teguran"),
          Other("warning")
        ]),
        bottomNavigationBar: Logger());
  }

  Widget Art() {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('${tabController.userData.value.name.capitalizeFirst}'),
              Column(
                children: [
                  Text('${tabController.userData.value.peserta.join(', ')}'),
                  Text(
                      '${tabController.userData.value.partai} - ${tabController.userData.value.kontingen.join(', ')}'),
                ],
              ),
              Text(sock.timer.value)
            ],
          ),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Home'),
              Tab(text: 'Penilaian'),
            ],
            labelStyle: TextStyle(fontSize: 20.0),
            indicatorColor: Colors.blueGrey,
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
        body: TabBarView(
          children: [Home(), art()],
        ),
        bottomNavigationBar: Logger());
  }

  Widget Home() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => Text(
                      '${homeController.userData.value.contest} (${homeController.userData.value.type})',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    )),
                SizedBox(height: 20),
                Obx(() {
                  final dataArray = homeController.userData.value.peserta;
                  List<Widget> textWidgets = [];
                  for (var item in dataArray) {
                    textWidgets.add(
                      Text(
                        '- ${item}',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w500),
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
                Obx(() => homeController.matchStatus.value.status == 1
                    ? Text(
                        'Pertandingan Selesai',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w500),
                      )
                    : Done())
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget art() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              children: tabController.juri.value.map((item) {
                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        width: 150,
                        height: 50,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            item['val'],
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            tabController.addPoint(
                                '0.00', 'fail${item['index']}', item['index']);
                          },
                          child: Text('RESET',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            tabController.addPoint(
                                '0.50', 'fail${item['index']}', item['index']);
                          },
                          child: Text('- 0.50',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500)),
                        )
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          height: 50,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              tabController.points.value[item['index']] == null
                                  ? '0'
                                  : tabController.points.value[item['index']]
                                      .toStringAsFixed(2),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              }).toList(),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                Obx(() => Text(
                      tabController.points.value.values
                          .fold(
                              0.0,
                              (previousValue, element) =>
                                  previousValue + element)
                          .toStringAsFixed(2),
                      textAlign: TextAlign.right,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget Other(String val) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${homeController.userData.value.contest} (${homeController.userData.value.type})',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20),
          Obx(() {
            final dataArray = homeController.userData.value.peserta;
            List<Widget> textWidgets = [];
            for (var item in dataArray) {
              textWidgets.add(
                Text(
                  '- ${item}',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
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
          Obx(() => dataController.matchStatus.value.status == 1
              ? Text(
                  'Pertandingan Selesai',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                )
              : OtherOps(val))
        ],
      ),
    );
  }

  Widget OtherOps(val) {
    final side = homeController.userData.value.side;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (val == 'drop') {
                    homeController.UpdateDrop('3', side[0], 'Drop');
                  }

                  if (val == 'coach') {
                    homeController.UpdateDrop('0', side[0], 'Coach');
                  }

                  if (val == 'teguran') {
                    homeController.UpdateDrop('-1', side[0], 'Teguran');
                  }

                  if (val == 'warning') {
                    homeController.UpdateDrop('-5', side[0], 'Warning');
                  }
                },
                child: Text('BLUE',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 100,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (val == 'drop') {
                    homeController.UpdateDrop('3', side[1], 'Drop');
                  }

                  if (val == 'coach') {
                    homeController.UpdateDrop('0', side[1], 'Coach');
                  }

                  if (val == 'teguran') {
                    homeController.UpdateDrop('-1', side[1], 'Teguran');
                  }

                  if (val == 'warning') {
                    homeController.UpdateDrop('-5', side[1], 'Warning');
                  }
                },
                child: Text('RED',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Container(
          width: 160,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              homeController.UpdateVer(val);
            },
            child: Obx(() => Text(
                homeController.tipe.value.contains(val)
                    ? 'CLOSE'
                    : 'VERIFIKASI',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500))),
          ),
        ),
      ],
    );
  }

  Widget Done() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [      
            Container(
              width: 240,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  homeController.UpdateStatus('1');
                },
                child: Text('Akhiri Pertandingan',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget Logger() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text(_webSocketService.logger.value)],
      ),
    );
  }
}
