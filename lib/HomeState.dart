import 'package:flutter/material.dart';
import 'ColorCodes.dart';
import 'Home.dart';

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MaterialColor(0xdd11292d, darkSeaGreenColorCodes),
      body: SingleChildScrollView (
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top*2)),
                Text(
                  "  Home",
                  style: TextStyle(
                      fontSize: 55,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: "Poppins"
                  ),
                )
              ],
            ),
          )
      )
    );
  }
}