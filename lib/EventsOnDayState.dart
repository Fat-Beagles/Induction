import 'package:firebase_database/firebase_database.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:induction/EventsOnDay.dart';
import 'package:induction/Utilities.dart';
import 'package:url_launcher/url_launcher.dart';
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
    print(widget.userGroup);
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

  Widget _buildTitle(BuildContext context, dynamic event){
    List<String> words = event['eventName'].split(' ');
    String title='';
    if(event['eventName'].length>10){
      if(words.length >= 2){
        int mid = (words.length/2).floor();
        for(var i=0; i<mid; i++){
          title= title+words[i]+" ";
        }
        title= title+"\n";
        for(var i=mid; i<words.length; i++){
          title= title+words[i]+" ";
        }
      }
    }
    else{
      title= event['eventName'];
    }
    return SizedBox(
      height: Utilities.vScale(70,context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "$title",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: Utilities.vScale(22.0, context),
                color: (event['active']==1)?MaterialColor(0xFF114546, darkSeaGreenColorCodes):MaterialColor(0xFF14a098, seaGreenColorCodes)
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTime(BuildContext context, dynamic event){
    int time = event['startTime'];
    int hh = (time/100).floor();
    int mm = time - hh*100;
    hh = hh%12;
    hh = (hh==0)?12:hh;
    String ampm = (time>=1200)?"PM":"AM";
    return Text(
      "${(hh%10==hh)?"0$hh":"$hh"}:${(mm%10==mm)?"0$mm":"$mm"}\n$ampm",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          fontSize: Utilities.vScale(22.0, context),
          color: (event['active']==1)?MaterialColor(0xFF114546, darkSeaGreenColorCodes):MaterialColor(0xFF14a098, seaGreenColorCodes)
      ),
    );
  }

  Widget _buildDescription(BuildContext context, dynamic event){
    return ParsedText(
      text: "${event['eventDesc']}",
      parse: <MatchText> [
        MatchText(
          type: ParsedType.URL,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.indigoAccent,
            fontSize: Utilities.vScale(18,context),
          ),
          onTap: (url) async {
            if(await(canLaunch(url))){
              launch(url);
            }
            else{
              return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        content: Text("Cannot open URL"),
                        actions: <Widget>[
                          FlatButton(
                            child: new Text("Okay"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ]
                    );
                  }
              );
            }
          }
        ),
      ],
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: Utilities.vScale(18, context),
        color: (event['active']==1)?MaterialColor(0xFF114546, darkSeaGreenColorCodes):MaterialColor(0xFF14a098, seaGreenColorCodes),
      ),
    );
    return Text(
      "${event['eventDesc']}",
      style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: Utilities.vScale(18.0, context),
          color: (event['active']==1)?MaterialColor(0xFF114546, darkSeaGreenColorCodes):MaterialColor(0xFF14a098, seaGreenColorCodes)
      ),
    );
  }

  Widget _buildDuration(BuildContext context, dynamic event){
    int hh = event['duration'].floor();
    int mm = ((event['duration'] - hh)*100).floor();
    String dur = "${(hh==0)?"":(hh==1)?"1 hour ":"$hh hours "} ${(mm==0)?"":(mm==1)?"1 minute":"$mm minutes"}";
    return Text(
      "Duration: $dur",
      style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          fontSize: Utilities.vScale(18.0, context),
          color: (event['active']==1)?MaterialColor(0xFF114546, darkSeaGreenColorCodes):MaterialColor(0xFF14a098, seaGreenColorCodes)
      ),
    );
  }

  Widget eventTile(BuildContext context, dynamic event, int elemId){
    return SizedBox(
        width: Utilities.scale(MediaQuery.of(context).size.width,context),
//        height: Utilities.vScale(100,context),

        child: DecoratedBox(
          decoration: BoxDecoration(
              color: (event['active']==1)?MaterialColor(0xFF14a098, seaGreenColorCodes):MaterialColor(0xFF114546, darkSeaGreenColorCodes),
              borderRadius: BorderRadius.circular(Utilities.scale(7.5,context))
          ),
          child: OutlineButton(
            onPressed: () {},
            child: ExpansionTile(
              title: _buildTitle(context, event),
              trailing: _buildTime(context, event),
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: Utilities.vScale(7,context))),
                _buildDescription(context, event),
                Padding(padding: EdgeInsets.only(top: Utilities.vScale(7,context))),
                _buildDuration(context, event),
                Padding(padding: EdgeInsets.only(top: Utilities.vScale(7,context))),
              ],
              onExpansionChanged: (bool isExpanded) {
                setState(() {
                  this.events[elemId]['active']=(this.events[elemId]['active']==1)?0:1;
                });
              },
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
      scheduleContents.add(eventTile(context, events[i],i));
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