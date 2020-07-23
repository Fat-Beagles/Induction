import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:induction/Gallery.dart';
import 'package:induction/Utilities.dart';
import 'ColorCodes.dart';
import 'Home.dart';

class HomeState extends State<Home> {
  String aboutURL;
  dynamic galleryURL;
  dynamic upNextURL;
  FirebaseDatabase homeDB;
  DatabaseReference homeDBRef;

  @override
  void initState(){
    homeDB = FirebaseDatabase(databaseURL: DotEnv().env['DB_URL']);
    homeDBRef = homeDB.reference().child("Home");
    getURLFromDB();
    super.initState();
  }

  void getURLFromDB() async{
    DataSnapshot aboutTemp = await homeDBRef.child("about").once();
    DataSnapshot galleryTemp = await homeDBRef.child("gallery").orderByKey().once();
    DataSnapshot upNextTemp = await homeDBRef.child("upNext").once();
    int time = new DateTime.now().millisecondsSinceEpoch;
    if(mounted){
      setState(() {
        aboutURL = aboutTemp.value;
        if(galleryTemp.value!=null){
          galleryURL = galleryTemp.value.values.toList();
          print(galleryURL);
          galleryURL = galleryURL[galleryURL.length-1]['url'];
        }
        else{
          galleryURL = aboutURL;
        }
        if(upNextTemp.value!=null){
          upNextURL = upNextTemp.value.values.toList();
          upNextURL = upNextURL[upNextURL.length-1]['url'];
        }
        else{
          upNextURL = aboutURL;
        }
      });
    }
  }

  Widget about(BuildContext context){
    return Container(
      width: Utilities.scale(MediaQuery.of(context).size.width-40, context),
      height: Utilities.vScale(MediaQuery.of(context).size.height/4, context),
      foregroundDecoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(1,1),
          end: Alignment(1,0.7),
          colors: [Colors.black54,Colors.transparent]
        ),
        borderRadius: BorderRadius.all(Radius.circular(Utilities.scale(10, context))),
      ),
      decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(Utilities.scale(10, context))),
          color: Colors.black26,
          image: (aboutURL==null)?null:DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(aboutURL)
          )
      ),
      child: FlatButton(
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: Utilities.scale(15, context),
              left: Utilities.scale(15, context),
              child: Text(
                "About",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Utilities.vScale(18, context)
                ),
              ),
            )
          ],
        ),
        onPressed: () => {
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(builder: (context) => EditProfile(
//                                user: user,
//                                bio: bio,
//                                instagram: instagram,
//                                ringColor: ringColor,
//                              ))).then((value) => reloadUser())
        },
      ),
    );
  }

  Widget gallery(BuildContext context){
    return Container(
      width: Utilities.scale(MediaQuery.of(context).size.width-40, context),
      height: Utilities.vScale(MediaQuery.of(context).size.height/4, context),
      foregroundDecoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment(1,1),
            end: Alignment(1,0.7),
            colors: [Colors.black54,Colors.transparent]
        ),
        borderRadius: BorderRadius.all(Radius.circular(Utilities.scale(10, context))),
      ),
      decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(Utilities.scale(10, context))),
          color: Colors.black26,
          image: (galleryURL==null)?null:DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(galleryURL)
          )
      ),
      child: FlatButton(
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: Utilities.scale(15, context),
              left: Utilities.scale(15, context),
              child: Text(
                "Gallery",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: Utilities.vScale(18, context)
                ),
              ),
            )
          ],
        ),
        onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Gallery()))
        },
      ),
    );
  }

  Widget upNext(BuildContext context){
    return Container(
      width: Utilities.scale(MediaQuery.of(context).size.width-40, context),
      height: Utilities.vScale(MediaQuery.of(context).size.height/4, context),
      foregroundDecoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment(1,1),
            end: Alignment(1,0.7),
            colors: [Colors.black54,Colors.transparent]
        ),
        borderRadius: BorderRadius.all(Radius.circular(Utilities.scale(10, context))),
      ),
      decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(Utilities.scale(10, context))),
          color: Colors.black26,
          image: (upNextURL==null)?null:DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(upNextURL)
          )
      ),
      child: FlatButton(
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: Utilities.scale(15, context),
              left: Utilities.scale(15, context),
              child: Text(
                "Up next",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: Utilities.vScale(18, context)
                ),
              ),
            )
          ],
        ),
        onPressed: () => {
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(builder: (context) => EditProfile(
//                                user: user,
//                                bio: bio,
//                                instagram: instagram,
//                                ringColor: ringColor,
//                              ))).then((value) => reloadUser())
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> homeContents = [
      Center(
        child: Image.asset('assets/images/logofulldrop.png', width:Utilities.scale(MediaQuery.of(context).size.width/2,context), height: Utilities.vScale((MediaQuery.of(context).size.width/2),context)/2.41, color: MaterialColor(0xcccb2d6f, magentaColorCodes),),
      ),

    ];
    return Scaffold(
        backgroundColor: MaterialColor(0xff262833, darkSeaGreenColorCodes),
        body: SingleChildScrollView (
            child: Container(
              padding: EdgeInsets.only(top: Utilities.vScale(MediaQuery.of(context).padding.top*2, context), left: Utilities.scale(30,context), right: Utilities.scale(30,context), bottom: Utilities.vScale(30,context)),
              child: Column(
                  children: <Widget>[
                    Image.asset('assets/images/logoFullNoShadow.png', width:Utilities.scale(MediaQuery.of(context).size.width/2,context), height: Utilities.vScale((MediaQuery.of(context).size.width/2),context)/2.41, color: MaterialColor(0xcccb2d6f, magentaColorCodes),),
                    Padding(padding: EdgeInsets.only(top: Utilities.vScale(20, context)),),
                    upNext(context),
                    Padding(padding: EdgeInsets.only(top: Utilities.vScale(10, context)),),
                    gallery(context),
                    Padding(padding: EdgeInsets.only(top: Utilities.vScale(10, context)),),
                    about(context)
                  ],
              ),
            )
        )
    );
  }
}