import 'package:flutter/material.dart';
import 'package:induction/Utilities.dart';
import 'ColorCodes.dart';
import 'Home.dart';

class HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    List<Widget> scheduleContents = [
      Center(
        child: Image.asset('assets/images/logofulldrop.png', width:Utilities.scale(MediaQuery.of(context).size.width-110,context), height: Utilities.vScale((MediaQuery.of(context).size.width-110),context)/2.41, color: MaterialColor(0xcccb2d6f, magentaColorCodes),),
      ),
    ];
    return Scaffold(
        backgroundColor: MaterialColor(0xff262833, darkSeaGreenColorCodes),
        body: SingleChildScrollView (
            child: Container(
              padding: EdgeInsets.only(top: Utilities.vScale(MediaQuery.of(context).padding.top*2, context), left: Utilities.scale(30,context), right: Utilities.scale(30,context), bottom: Utilities.vScale(30,context)),
              child: Column(
                  children: scheduleContents
              ),
            )
        )
    );
  }
}