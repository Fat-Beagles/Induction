import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:induction/AppInfo.dart';
import 'package:induction/Utilities.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ColorCodes.dart';
import 'About.dart';

class AboutState extends State<About> {

  @override
  void initState(){
    super.initState();
  }

  Widget getContact(String name, String mail){
    return SizedBox(
      width: Utilities.scale(MediaQuery.of(context).size.width/2 - 50, context),
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: Utilities.scale(MediaQuery.of(context).size.width, context),
              height: Utilities.vScale(60, context),
              child: FlatButton(
                color:  MaterialColor(0xFF114546, darkSeaGreenColorCodes),
                onPressed: () async{
                  final Uri _emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: mail,
                      queryParameters: {
                        'subject': 'Induction-2020'
                      }
                  );
                  if(await(canLaunch(_emailLaunchUri.toString()))){
                    await launch(_emailLaunchUri.toString());
                  }
                  else{
                    return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              content: Text("Cannot open mail. Try again later."),
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
                },
                child: Text(
                    '$name',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: Utilities.vScale(20,context),
                        color: MaterialColor(0xaa14a098, seaGreenColorCodes)
                    )
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Utilities.scale(24,context))
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getContactRow(String name1, String email1, String name2, String email2){
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
//        Padding(padding: EdgeInsets.only(left: Utilities.scale(15, context))),
          Center(
            child: getContact(name1, email1),
          ),
          Padding(padding: EdgeInsets.only(left: Utilities.vScale(10, context))),
          Center(
            child: getContact(name2, email2),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MaterialColor(0xff262833, darkSeaGreenColorCodes),
      body: Container(
        padding: EdgeInsets.only(left: Utilities.scale(15, context), right: Utilities.scale(15,context)),
        color: MaterialColor(0xff262833, darkSeaGreenColorCodes),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(MediaQuery.of(context).padding.top*1.5, context))),
              Center(
                child: Text(
                  "ABOUT",
                  style: TextStyle(
                      fontSize: Utilities.vScale(55,context),
                      fontWeight: FontWeight.bold,
                      color: MaterialColor(0xcccb2d6f, magentaColorCodes),
                      fontFamily: "Poppins"
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(15, context))),
              Container(
                width: Utilities.scale(MediaQuery.of(context).size.width-40, context),
                height: Utilities.vScale(MediaQuery.of(context).size.height/4, context),
                foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(Utilities.scale(10, context))),
                ),
                decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(Utilities.scale(10, context))),
                    color: Colors.black26,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/iiitdvector.png')
                    )
                ),
              ),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(15, context))),
              Center(
                child: SizedBox(
//                  height: Utilities.getRoundImageSize(MediaQuery.of(context).size.width, context),
                  width: Utilities.getRoundImageSize(MediaQuery.of(context).size.width, context),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: MaterialColor(0xaa14a098, seaGreenColorCodes),
                      borderRadius: BorderRadius.circular(Utilities.scale(30, context)/2),
                      border: Border.all(
                          color: MaterialColor(0xFF114546, darkSeaGreenColorCodes), //Border color same as the group color.
                          width: Utilities.scale(3,context)
                      ),
                    ),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: Utilities.vScale(15, context))),
                          SizedBox(
                            width: Utilities.scale(MediaQuery.of(context).size.width/1.2, context),
                            child: Text(
                              "WELCOME TO IIIT - DELHI",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: MaterialColor(0xFF114546, darkSeaGreenColorCodes),
                                fontWeight: FontWeight.w900,
                                fontSize: Utilities.scale(25, context),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: Utilities.vScale(15, context))),
                          SizedBox(
                            width: Utilities.scale(MediaQuery.of(context).size.width/1.25, context),
                            child: Text(
                              "IIIT-Delhi strives to generate a pool of graduates who not only possess the essential qualities to fulfill their responsibility as an engineer, but also as a citizen and a human being. Our Induction Program has been designed with precision to promote academic success, personal and social development, and to provide students with information about services and support systems at IIIT-Delhi. The primary goal of our Induction Program is to make the new students acquainted and connected to the people and resources in the IIITD community. We propel to generate a plethora of opportunities and offer experiences to engage the curious minds productively, challenge their beliefs, and motivate them to grow intellectually, socially, and emotionally. This 5 days fun-packed learning programme encompasses a blend of activities including motivational talks by prominent speakers, panel discussions, ice breaking sessions, individual / group manoeuvre, stress and time management workshops, ethics and value learning, and much more. To develop a close knit social interaction and a sense of belongingness within the environment, activities such as karaoke, talent show, quiz, etc are also planned for our students.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: MaterialColor(0xFF114546, darkSeaGreenColorCodes),
                                fontWeight: FontWeight.w500,
                                fontSize: Utilities.scale(18, context),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: Utilities.vScale(15, context)))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(10, context))),
              Center(
                child: Text(
                  "INDUCTION COMMITTEE",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: Utilities.vScale(40,context),
                      fontWeight: FontWeight.bold,
                      color: MaterialColor(0xcccb2d6f, magentaColorCodes),
                      fontFamily: "Poppins"
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(15, context))),
              getContactRow("PK", "pk@iiitd.ac.in", "Sujay Deb", "sdeb@iiitd.ac.in"),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(15, context))),
              getContactRow("Ravi Bhasin", "ravi@iiitd.ac.in", "Kaushik K.", "kaushik@iiitd.ac.in"),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(15, context))),
              getContactRow("Sonia Baloni Ray", "sonia@iiitd.ac.in", "Rajiv Ratn Shah", "rajivratn@iiitd.ac.in"),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(15, context))),
              getContactRow("Pallavi Kaushik", "pallavi@iiitd.ac.in", "Sheetu Ahuja", "sheetu@iiitd.ac.in"),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(15, context))),
              getContactRow("Sonal Garg", "sonal@iiitd.ac.in", "Ashutosh Brahma", "ashutosh@iiitd.ac.in"),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(15, context))),
              getContactRow("Vaibhav Goel", "vaibhav16111@iiitd.ac.in", "Arnav Tandon", "arnav18278@iiitd.ac.in"),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(15, context))),
              getContactRow("Pranay Jain", "pranay18358@iiitd.ac.in", "Jasmine Kaur", "jasmine18287@iiitd.ac.in"),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(15, context))),
              getContactRow("Ankur Goel", "ankur19030@iiitd.ac.in", "Yatharth Taneja", "yatharth19346@iiitd.ac.in"),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(25, context))),
              Center(
                child: Text(
                  "VOLUNTEERS",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: Utilities.vScale(40,context),
                      fontWeight: FontWeight.bold,
                      color: MaterialColor(0xcccb2d6f, magentaColorCodes),
                      fontFamily: "Poppins"
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(15, context))),
              getContactRow("Prakhar Shukla", "prakhar19187@iiitd.ac.in", "Sonal Aggarwal", "sonal19047@iiitd.ac.in"),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(15, context))),
              getContactRow("Akshaj Patil", "akshaj19111@iiitd.ac.in", "Pranav Jain", "pranav19207@iiitd.ac.in"),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(15, context))),
              getContactRow("Divisha Sharma", "divisha19204@iiitd.ac.in", "Ishita Agarwal", "ishita19013@iiitd.ac.in"),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(15, context))),
              getContactRow("Stuti Jain", "stuti19173@iiitd.ac.in", "Pranjal Pandey", "pranjal19208@iiitd.ac.in"),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(15, context))),
              getContactRow("Mukesh Kumar", "mukesh19185@iiitd.ac.in", "Kritika Vazirani", "kritika19206@iiitd.ac.in"),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(15, context))),
              getContactRow("Srinath J", "srinath19197@iiitd.ac.in", "Sayandip Kar", "sayandip19194@iiitd.ac.in"),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(15, context))),
              getContactRow("Ganesh Vilas", "chaudhari19116@iiitd.ac.in", "Vineet Joshi", "vineet19020@iiitd.ac.in"),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(15, context))),
              Center(
                child: SizedBox(
                  width: Utilities.scale(MediaQuery.of(context).size.width/2 - 30, context),
                  height: Utilities.vScale(50, context),
                  child: FlatButton(
                    color: MaterialColor(0xaa14a098, seaGreenColorCodes),
                    onPressed: () async{
                      const url = "https://www.iiitd.ac.in/contact";
                      if(await(canLaunch(url))){
                        await launch(url);
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
                    },
                    child: Text(
                        'More information',
                        style: TextStyle(
                            fontSize: Utilities.vScale(18,context),
                            color: Colors.white
                        )
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Utilities.scale(20.0,context))
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(15, context))),
              Center(
                child: SizedBox(
                  width: Utilities.scale(MediaQuery.of(context).size.width/2 - 30, context),
                  height: Utilities.vScale(50, context),
                  child: FlatButton(
                    color: MaterialColor(0x88501f3a, darkMagentaColorCodes),
                    onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AppInfo()))
                    },
                    child: Text(
                        'App information',
                        style: TextStyle(
                            fontSize: Utilities.vScale(18,context),
                            color: Colors.white
                        )
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Utilities.scale(20.0,context))
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(20, context))),
            ],
          )
        )
      )
    );
  }
}