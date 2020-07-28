import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:induction/AppInfo.dart';
import 'package:induction/Utilities.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ColorCodes.dart';
import 'About.dart';

class AboutState extends State<About> {
  List<dynamic> isICProf = new List();
  List<dynamic> isICStud = new List();
  List<dynamic> isVol = new List();
  List<Widget> icList = new List();
  FirebaseDatabase usersDB;
  DatabaseReference usersDBRef;
  FirebaseStorage storage;

  void getInfoFromDB() async {
    DataSnapshot data = await usersDBRef.once();
    dynamic values = data.value;
    await values.forEach((k,v) async {
      try{
        if(values[k]['name'].replaceAll(' ','')!='' && values[k]['isICProf']!=null && values[k]['isICProf']==true){
          try{
            values[k]['photoUrl'] = await storage.ref().child('ProfilePictures').child('$k.jpeg').getDownloadURL();
          } catch(e) {
            values[k]['photoUrl'] = DotEnv().env['DEF_IMAGE'];
          }
          if(mounted){
            setState(() {
              isICProf.add(values[k]);
            });
            isICProf.sort((a,b) => Utilities.compareNames(a,b));
          }
        }
        if(values[k]['name'].replaceAll(' ','')!='' && values[k]['isICStud']!=null && values[k]['isICStud']==true){
          try{
            values[k]['photoUrl'] = await storage.ref().child('ProfilePictures').child('$k.jpeg').getDownloadURL();
          } catch(e) {
            values[k]['photoUrl'] = DotEnv().env['DEF_IMAGE'];
          }
          if(mounted){
            setState(() {
              isICStud.add(values[k]);
            });
            isICStud.sort((a,b) => Utilities.compareNames(a,b));
          }
        }
        if(values[k]['name'].replaceAll(' ','')!='' && values[k]['isVol']!=null && values[k]['isVol']==true){
          try{
            values[k]['photoUrl'] = await storage.ref().child('ProfilePictures').child('$k.jpeg').getDownloadURL();
          } catch(e) {
            values[k]['photoUrl'] = DotEnv().env['DEF_IMAGE'];
          }
          if(mounted){
            setState(() {
              isVol.add(values[k]);
            });
            isVol.sort((a,b) => Utilities.compareNames(a,b));
          }
        }
      }
      catch(e){
        //Do nothing. Only to check if name is present in the Map.
      }
    });
  }

  @override
  void initState(){
    if(mounted){
      setState(() {
        usersDB = FirebaseDatabase(databaseURL: DotEnv().env['DB_URL']);
        usersDBRef = usersDB.reference().child('users');
        storage = FirebaseStorage(storageBucket: DotEnv().env['STORAGE_URL']);
      });
    }
    getInfoFromDB();
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

  Widget renderIC(){
    icList = [];
    for(var i=0; i<((isICProf!=null)?isICProf.length:0); i++){
      icList.add(Padding(padding: EdgeInsets.only(top: Utilities.vScale((i==0)?30:13,context))));
      icList.add(userTile(isICProf[i]));
    }
  }

  Widget userTile(dynamic user){
    int active = 0 ;
    List<Widget> profileImage = [
      Center(
        child: SizedBox(
          height: Utilities.getRoundImageSize(57, context),
          width: Utilities.getRoundImageSize(57, context),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: MaterialColor(0xff262833, darkSeaGreenColorCodes),
              borderRadius: BorderRadius.circular(Utilities.getRoundImageSize(355, context)/2),
            ),
          ),
        ),
      ),
      Center(
        child: SizedBox(
          height: Utilities.getRoundImageSize(50, context),
          width: Utilities.getRoundImageSize(50, context),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: MaterialColor(0xff262833, darkSeaGreenColorCodes),
              borderRadius: BorderRadius.circular(Utilities.getRoundImageSize(355, context)/2),
              border: Border.all(
                  color: Utilities.getGroupColor(user['groupCode'].toString()), //Border color same as the group color.
                  width: Utilities.scale(5,context)
              ),
            ),
          ),
        ),
      ),
      Center(
        child: Container(
          width: Utilities.getRoundImageSize(45, context),
          height: Utilities.getRoundImageSize(45, context),
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(user['photoUrl']),
              )
          ),
//                      child: FlatButton(
//                        onPressed: () => {print("Hello")},
//                        shape: RoundedRectangleBorder(
//                            borderRadius: BorderRadius.circular(Utilities.getRoundImageSize(335, context)/2)
//                        ),
//                      ),
        ),
      ),
    ];

    return SizedBox(
        width: Utilities.scale(MediaQuery.of(context).size.width,context),
        height: Utilities.vScale(75,context),
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: (active==0)?MaterialColor(0xFF14a098, seaGreenColorCodes):MaterialColor(0xFF114546, darkSeaGreenColorCodes),
              borderRadius: BorderRadius.circular(Utilities.scale(7.5,context))
          ),
          child: OutlineButton(
            onPressed: () async {
              final Uri _emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: user['mail'],
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
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: Utilities.scale(MediaQuery.of(context).size.width/5-10, context),
                  child: Stack(
                      children: profileImage
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: Utilities.scale(10,context))),
                Center(
                  child: Text(
                    "${user['name']}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: Utilities.vScale(25.0, context),
                      color: (active==0)?MaterialColor(0xFF114546, darkSeaGreenColorCodes):MaterialColor(0xFF14a098, seaGreenColorCodes),
                    ),
                  ),
                ),
              ],
            ),
            borderSide: BorderSide(
                color: (active==0)?MaterialColor(0xFF114546, darkSeaGreenColorCodes):MaterialColor(0xFF14a098, seaGreenColorCodes),
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
    setState(() {
      renderIC();
    });
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
//              Column(
//                children: icList,
//              ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
//                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: SizedBox(
                        width: Utilities.scale(MediaQuery.of(context).size.width/2 - 50, context),
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                width: Utilities.scale(MediaQuery.of(context).size.width, context),
                                height: Utilities.vScale(60, context),
                                child: FlatButton(
//                                color:  MaterialColor(0xFF114546, darkSeaGreenColorCodes),
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
                                      'MORE INFO',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: Utilities.vScale(20,context),
                                          color: MaterialColor(0xcccb2d6f, magentaColorCodes)
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
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: Utilities.vScale(10, context))),
                    Center(
                      child: SizedBox(
                        width: Utilities.scale(MediaQuery.of(context).size.width/2 - 50, context),
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                width: Utilities.scale(MediaQuery.of(context).size.width, context),
                                height: Utilities.vScale(60, context),
                                child: FlatButton(
//                                color:  MaterialColor(0xFF114546, darkSeaGreenColorCodes),
                                  onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => AppInfo()))
                                  },
                                  child: Icon(
                                    Icons.info_outline,
                                    color: MaterialColor(0xcccb2d6f, magentaColorCodes),
                                    size: Utilities.vScale(30,context),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(Utilities.scale(24,context))
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(20, context))),
            ],
          )
        )
      )
    );
  }
}