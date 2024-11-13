import 'package:flutter/material.dart';
import 'package:get/get.dart';


  Widget Footer() {
    return BottomAppBar(
      color: Colors.blueGrey,
      child: Container(
        height: 40.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Obx(() => Text(
                    "status : ",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }