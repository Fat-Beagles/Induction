import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:induction/EventsOnDay.dart';
import 'package:induction/Utilities.dart';
import 'ColorCodes.dart';

class EventsOnDayState extends State<EventsOnDay> {
  List<String> days;
  List<dynamic> events;

  @override
  void initState(){
    getEventsFromSchedule();
    super.initState();
  }

  void getEventsFromSchedule() async{
    if(mounted){
      setState(() {
        events = new List();
        for(var i=1; i<((widget.schedule!=null)?widget.schedule.length:0); i++){
          if(widget.schedule[i]['date']==widget.day && widget.schedule[i]['group'][widget.userGroup.toLowerCase()]==true){
            events.add(widget.schedule[i]);
          }
        }
        events.sort((a,b)=> Utilities.compareEvents(a, b));
        for(var i=0; i<((events!=null)?events.length:0); i++){
          events[i]['active']=0;
        }
      });
    }
  }

  Widget eventTile(BuildContext context, dynamic event){
    List<Widget> positionedWidgets = [
      Positioned(
        left: 0,
        top: Utilities.vScale(10,context),
        child: Text(
          "",
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: Utilities.vScale(30.0, context),
              color: (event['active']==1)?MaterialColor(0xFF114546, darkSeaGreenColorCodes):MaterialColor(0xFF14a098, seaGreenColorCodes)
          ),
        ),
      ),
      Positioned(
        left: 0,
        bottom: Utilities.vScale(10,context),
        child: Text(
          "",
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: Utilities.vScale(30.0, context),
              color: (event['active']==1)?MaterialColor(0xFF114546, darkSeaGreenColorCodes):MaterialColor(0xFF14a098, seaGreenColorCodes)
          ),
        ),
      ),
      Positioned(
        right: 0,
        top: Utilities.vScale(10,context),
        child: Text(
          "",
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: Utilities.vScale(30.0, context),
              color: (event['active']==1)?MaterialColor(0xFF114546, darkSeaGreenColorCodes):MaterialColor(0xFF14a098, seaGreenColorCodes)
          ),
        ),
      )
    ];

    return SizedBox(
        width: Utilities.scale(MediaQuery.of(context).size.width,context),
        height: Utilities.vScale(100,context),
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: (event['active']==1)?MaterialColor(0xFF14a098, seaGreenColorCodes):MaterialColor(0xFF114546, darkSeaGreenColorCodes),
              borderRadius: BorderRadius.circular(Utilities.scale(7.5,context))
          ),
          child: OutlineButton(
            onPressed: () {
            },
            child: Stack(
                children:positionedWidgets
            ),
            borderSide: BorderSide(
                color: (event['active']==1)?MaterialColor(0xFF114546, darkSeaGreenColorCodes):MaterialColor(0xFF14a098, seaGreenColorCodes),
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
    List<Widget> scheduleContents = [
      Center(
        child: Text(
          "DAY ${widget.dayNum}",
          style: TextStyle(
              fontSize: Utilities.vScale(55,context),
              fontWeight: FontWeight.bold,
              color: MaterialColor(0xcccb2d6f, magentaColorCodes),
              fontFamily: "Poppins"
          ),
        ),
      ),
    ];
    for(var i=0; i<((events!=null)?events.length:0); i++){
      scheduleContents.add(Padding(padding: EdgeInsets.only(top: Utilities.vScale((i==0)?30:13,context))));
      scheduleContents.add(eventTile(context, events[i]));
    }
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