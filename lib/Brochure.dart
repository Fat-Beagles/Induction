import "package:flutter/material.dart";
import "ColorCodes.dart";
import 'package:fluttertoast/fluttertoast.dart';

class Brochure extends StatelessWidget{
  Brochure({Key key, this.title}): super(key:key);
  DateTime currentBackPressTime;
  final String title;

  @override
  Widget build(BuildContext context){

    return Scaffold(
        backgroundColor: MaterialColor(0xFF11292d, darkSeaGreenColorCodes),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
              child: Text(
                this.title,
                style: TextStyle(
                  fontSize: 25,
                  color: MaterialColor(0xFFcdcdcd, greyColorCodes),
                ),
              )),
        ),
        body: WillPopScope(
          child: Center(
            child: Text(
              this.title,
              style: TextStyle(
                fontSize: 25,
                color: MaterialColor(0xFFcdcdcd, greyColorCodes),
              ),
            ),
          ),
          onWillPop: onWillPop,
        ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press back again to logout.");
      return Future.value(false);
    }
    return Future.value(true);
  }
}