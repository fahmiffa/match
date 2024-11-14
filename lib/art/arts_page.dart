import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/sock_controller.dart';
import '../controllers/tab_controllers.dart';

class ArtsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyArt(),
    );
  }
}

// ignore: must_be_immutable
class MyArt extends StatelessWidget {
  final TabControllers tabController = Get.put(TabControllers());
  final AuthController _authController = Get.put(AuthController());
  final SockController sock = Get.put(SockController());
  int numb = 0;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Penilaian ${tabController.userData.value.name}'),
              Obx(() => Column(
                    children: [
                      Text(
                          '${tabController.userData.value.peserta.join(', ')}'),
                      Text(
                          '${tabController.userData.value.partai} - ${tabController.userData.value.kontingen.join(', ')}'),
                    ],
                  )),
              Obx(() => Text(sock.timer.value)),
            ],
          ),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Tehnik serang bela'),
              Tab(text: 'Kemantapan dan harmony'),
              Tab(text: 'Penjiwaan'),
            ],
            labelStyle: TextStyle(fontSize: 13.0),
            indicatorColor: Colors.blueGrey,
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
        body: TabBarView(
          children: [
            Attack(context, 0),
            Attack(context, 1),
            Attack(context, 2)
          ],
        ),
        bottomNavigationBar: Total(),
      ),
    );
  }

  Widget Total() {
    return Container(
      color: Colors.blueGrey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Total",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Obx(() => Text(tabController.score.value.toStringAsFixed(2),
                style: TextStyle(fontSize: 20, color: Colors.white)))
          ],
        ),
      ),
    );
  }

  Widget Attack(context, par) {
    final List<String> buttonLabels = [
      '0.01',
      '0.02',
      '0.03',
      '0.04',
      '0.05',
      '0.06',
      '0.07',
      '0.08',
      '0.09',
      '0.10',
      '0.11',
      '0.12',
      '0.13',
      '0.14',
      '0.15',
      '0.16',
      '0.17',
      '0.18',
      '0.19',
      '0.20',
      '0.21',
      '0.22',
      '0.23',
      '0.24',
      '0.25',
      '0.26',
      '0.27',
      '0.28',
      '0.29',
      '0.30',
    ];
    var orientation = MediaQuery.of(context).orientation;
    int crossAxisCount = orientation == Orientation.portrait ? 5 : 10;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount, // 10 buttons per row
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: buttonLabels.length,
              itemBuilder: (context, index) {
                return Obx(() => ElevatedButton(
                      onPressed: () {
                        if (par == 0) {
                          if (tabController.append.containsKey(par)) {
                            print(tabController.append[par]);
                          }
                          tabController.attack
                              ? tabController.addGanda(
                                  "${buttonLabels[index]}", 'press', par)
                              : null;
                        } else if (par == 1) {
                          tabController.firmness
                              ? tabController.addGanda(
                                  "${buttonLabels[index]}", 'press', par)
                              : null;
                        } else if (par == 2) {
                          tabController.foul
                              ? tabController.addGanda(
                                  "${buttonLabels[index]}", 'press', par)
                              : null;
                        }
                      },
                      child: Text(buttonLabels[index]),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black, backgroundColor: tabController.append.containsKey(par) &&
                                tabController.append[par] == buttonLabels[index]
                            ? Colors.grey[400]
                            : Colors.grey[300],
                      ),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }

  void appends() {}
}
