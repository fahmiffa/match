import 'package:Match/controllers/points_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';

class PointPage extends StatelessWidget {
  final PointsController pointController = Get.put(PointsController());
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Point',
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
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth > constraints.maxHeight) {
              return vertical();
            } else {
              return vertical();
            }
          },
        ));
  }

  Widget vertical() {
    return Center(
      child: Obx(() => Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (var peserta in pointController.peserta)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("${peserta.name}",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                    SizedBox(height: 25),
                    AttributeP(peserta.id),       
                  ],
                ),
            ],
          )),
    );
  }

  static warna(par) {
    if (par == 'Hit') {
      return Colors.yellowAccent;
    }

    if (par == 'Kick') {
      return Colors.red;
    }

    if (par == 'Slam') {
      return Colors.blueGrey;
    }
  }

  Widget AttributeP(int id) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var point in pointController.pointData)
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: warna(point.name),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        pointController.addValue('${point.id}', id);
                      },
                      child: Text('${point.name}',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              color: Colors.black)),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
          ],
        ));
  }

}
