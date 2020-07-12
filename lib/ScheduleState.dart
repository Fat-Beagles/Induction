import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:induction/EventsOnDay.dart';
import 'package:induction/Utilities.dart';
import 'ColorCodes.dart';
import 'Schedule.dart';

class ScheduleState extends State<Schedule> {
  List<dynamic> schedule;
  List<String> days;

  String userGroup;

  FirebaseDatabase scheduleDB;
  DatabaseReference scheduleDBRef;
  @override
  void initState(){
    if(mounted){
      setState((){
        scheduleDB = FirebaseDatabase(databaseURL: DotEnv().env['DB_URL']);
        scheduleDBRef = scheduleDB.reference().child('Schedule');
      });
    }
    getScheduleFromDB();
    getValFromDB();
    super.initState();
  }

  void getValFromDB() async{
    FirebaseDatabase userDB = FirebaseDatabase(databaseURL: DotEnv().env['DB_URL']);
    DatabaseReference userDataRef= userDB.reference().child('users/${widget.user.uid}');
    DataSnapshot data = await userDataRef.once();
    dynamic dataValues = data.value;
    if(mounted){
      setState(() {
        userGroup = dataValues['groupCode'];
      });
    }
  }

  void getScheduleFromDB() async{
    DataSnapshot data = await scheduleDBRef.once();
    dynamic values = data.value;
    if(mounted){
      setState(() {
        schedule = values;
        days = new List();
        for(var i=1; i<((schedule!=null)?schedule.length:0); i++){
          days.add(schedule[i]['date']+' '+schedule[i]['day'].toString());
        }
        Set<String> daysFinal = new Set.from(days);
        days = new List.from(daysFinal);
        days.sort((a,b)=> Utilities.compareDays(a, b));
      });
    }
  }

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
        top: Utilities.vScale(10,context),
        child: Text(
          "$day $mm,",
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: Utilities.vScale(30.0, context),
              color: (active==1)?MaterialColor(0xFF114546, darkSeaGreenColorCodes):MaterialColor(0xFF14a098, seaGreenColorCodes)
          ),
        ),
      ),
      Positioned(
        left: 0,
        bottom: Utilities.vScale(10,context),
        child: Text(
          "$wdd",
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: Utilities.vScale(30.0, context),
              color: (active==1)?MaterialColor(0xFF114546, darkSeaGreenColorCodes):MaterialColor(0xFF14a098, seaGreenColorCodes)
          ),
        ),
      ),
      Positioned(
        right: 0,
        top: Utilities.vScale(10,context),
        child: Text(
          "DAY $dayNum",
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: Utilities.vScale(30.0, context),
              color: (active==1)?MaterialColor(0xFF114546, darkSeaGreenColorCodes):MaterialColor(0xFF14a098, seaGreenColorCodes)
          ),
        ),
      )
    ];

    return SizedBox(
      width: Utilities.scale(MediaQuery.of(context).size.width,context),
      height: Utilities.vScale(100,context),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: (active==1)?MaterialColor(0xFF14a098, seaGreenColorCodes):MaterialColor(0xFF114546, darkSeaGreenColorCodes),
          borderRadius: BorderRadius.circular(Utilities.scale(7.5,context))
        ),
        child: OutlineButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventsOnDay(
                    schedule: this.schedule,
                    userGroup: this.userGroup,
                    day: this.days[dayNum-1].split(' ')[0],
                    dayNum: dayNum
                ))
            );
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
    List<Widget> scheduleContents = [
      Center(
        child: Text(
          "SCHEDULE",
          style: TextStyle(
              fontSize: Utilities.vScale(55,context),
              fontWeight: FontWeight.bold,
              color: MaterialColor(0xcccb2d6f, magentaColorCodes),
              fontFamily: "Poppins"
          ),
        ),
      ),
    ];
    for(var i=0; i<((days!=null)?days.length:0); i++){
      List<String> date = days[i].split('-');
      int dd = int.parse(date[0]);
      int mm = int.parse(date[1]);
      int wDay = int.parse(date[2].split(' ')[1]);
      scheduleContents.add(Padding(padding: EdgeInsets.only(top: Utilities.vScale((i==0)?30:13,context))));
      scheduleContents.add(dayTile(context, dd, mm, wDay, i+1));
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