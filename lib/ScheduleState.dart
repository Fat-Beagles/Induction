import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:induction/Utilities.dart';
import 'ColorCodes.dart';
import 'Schedule.dart';

import 'ColorCodes.dart';
import 'ColorCodes.dart';

class ScheduleState extends State<Schedule> {

  Widget dayTile(BuildContext context, int day, int month, int wDay, int dayNum){
    int active = 0 ;
    DateTime today = new DateTime.now();
    if(today.day == day && today.month==month){
      active=1;
    }
    String mm = Utilities.getMonthString(month);
    String wdd = Utilities.getWeekDayString(wDay);

    List<Widget> positionedWidgets = [
      Positioned(
        left: 0,
        top: Utilities.scale(10,context),
        child: Text(
          "$day $mm,",
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: Utilities.scale(30.0, context),
              color: (active==1)?MaterialColor(0xFF114546, darkSeaGreenColorCodes):MaterialColor(0xFF14a098, seaGreenColorCodes)
          ),
        ),
      ),
      Positioned(
        left: 0,
        bottom: Utilities.scale(10,context),
        child: Text(
          "$wdd",
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: Utilities.scale(30.0, context),
              color: (active==1)?MaterialColor(0xFF114546, darkSeaGreenColorCodes):MaterialColor(0xFF14a098, seaGreenColorCodes)
          ),
        ),
      ),
      Positioned(
        right: 0,
        top: Utilities.scale(10,context),
        child: Text(
          "DAY $dayNum",
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: Utilities.scale(30.0, context),
              color: (active==1)?MaterialColor(0xFF114546, darkSeaGreenColorCodes):MaterialColor(0xFF14a098, seaGreenColorCodes)
          ),
        ),
      )
    ];

    return SizedBox(
      width: Utilities.scale(MediaQuery.of(context).size.width,context),
      height: Utilities.scale(MediaQuery.of(context).size.height/10,context),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: (active==1)?MaterialColor(0xFF14a098, seaGreenColorCodes):MaterialColor(0xFF114546, darkSeaGreenColorCodes),
          borderRadius: BorderRadius.circular(Utilities.scale(7.5,context))
        ),
        child: OutlineButton(
          onPressed: () {
          },
          child: Stack(
              children:positionedWidgets
          ),
          borderSide: BorderSide(
              color: (active==1)?MaterialColor(0xFF114546, darkSeaGreenColorCodes):MaterialColor(0xFF14a098, seaGreenColorCodes),
              width: Utilities.scale(4,context)
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Utilities.scale(7.5,context))
          ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MaterialColor(0xff262833, darkSeaGreenColorCodes),
      body: SingleChildScrollView (
          child: Container(
            padding: EdgeInsets.only(top: Utilities.scale(MediaQuery.of(context).padding.top*2, context), left: Utilities.scale(30,context), right: Utilities.scale(30,context), bottom: Utilities.scale(30,context)),
            child: Column(
              children: <Widget>[
                Center(
                  child: Text(
                    "SCHEDULE",
                    style: TextStyle(
                        fontSize: Utilities.scale(55,context),
                        fontWeight: FontWeight.bold,
                        color: MaterialColor(0xcccb2d6f, magentaColorCodes),
                        fontFamily: "Poppins"
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: Utilities.scale(30,context))),
                dayTile(context, 26, 6, 5, 4),
                Padding(padding: EdgeInsets.only(top: Utilities.scale(13,context))),
                dayTile(context, 24, 5, 5, 4),
                Padding(padding: EdgeInsets.only(top: Utilities.scale(13,context))),
                dayTile(context, 24, 4, 5, 4),
                Padding(padding: EdgeInsets.only(top: Utilities.scale(13,context))),
                dayTile(context, 24, 3, 5, 4),
                Padding(padding: EdgeInsets.only(top: Utilities.scale(13,context))),
                dayTile(context, 24, 1, 5, 4),
                Padding(padding: EdgeInsets.only(top: Utilities.scale(13,context))),
                dayTile(context, 24, 2, 5, 4),
                Padding(padding: EdgeInsets.only(top: Utilities.scale(13,context))),
                dayTile(context, 24, 10, 5, 4),
                Padding(padding: EdgeInsets.only(top: Utilities.scale(13,context))),
                dayTile(context, 24, 11, 5, 4),
                Padding(padding: EdgeInsets.only(top: Utilities.scale(13,context))),
                dayTile(context, 24, 12, 5, 4),
                Padding(padding: EdgeInsets.only(top: Utilities.scale(13,context))),
                dayTile(context, 24, 8, 5, 4),
              ],
            ),
          )
      )
    );
  }
}