import 'package:Match/controllers/point_controller.dart';
import 'package:Match/controllers/reltime_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';

class MainPage extends StatelessWidget {
  final RealtimeController dataController = Get.put(RealtimeController());

  final PointController pointController = Get.put(PointController());
  final AuthController _authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome ${pointController.userData.value.name}',
        ),
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
          padding: EdgeInsets.only(top: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Text(
                  '${pointController.userData.value.contest} (${pointController.userData.value.type})',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500))),
              SizedBox(height: 20),
              Obx(() {
                final dataArray = pointController.userData.value.peserta;
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
              SizedBox(height: 10),
              Obx(() => dataController.matchStatus.value.status == 1
                  ? Text(
                      'Pertandingan Selesai',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    )
                  : dataController.matchStatus.value.status == 0
                      ? WidgetOpen()
                      : WidgetOff())
            ],
          ),
        ),
      ),
    );
  }
}

class WidgetOpen extends StatelessWidget {
  final PointController _pointController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
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
          _pointController.UpdateStatus('2');
        },
        child: Text('OPEN',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

class WidgetOff extends StatelessWidget {
  final PointController _pointController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 200,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black54,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              _pointController.UpdateStatus('0');
            },
            child: Text('CLOSE',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: 200,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              _pointController.UpdateStatus('1');
            },
            child: Text('Done',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
          ),
        ),
      ],
    );
  }
}
