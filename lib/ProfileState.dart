import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:induction/EditProfile.dart';
import 'package:induction/Utilities.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ColorCodes.dart';
import 'Profile.dart';

class ProfileState extends State<Profile> {
  String displayName='';
  String email='';
  String photoUrl='';
  String uid='';
  String branch='';
  String bio='';
  String linkedin='';
  dynamic groupColor='';
  bool isVerified=false;
  MaterialColor ringColor;
  String instagram='';
  FirebaseStorage storage;
  FirebaseDatabase userDB;
  DatabaseReference userDataRef;
  dynamic user;
  int activeUser=0;

  @override
  void initState(){
    if(mounted){
      setState(() {
        storage = FirebaseStorage(storageBucket: DotEnv().env['STORAGE_URL']);
        if(widget.curUser!=null){
          user = widget.curUser;
          displayName = user.displayName;
          email = user.email;
          photoUrl = user.photoUrl;
          photoUrl = photoUrl==null?DotEnv().env['DEF_IMAGE']:photoUrl;
          uid = user.uid;
          userDB = FirebaseDatabase(databaseURL: DotEnv().env['DB_URL']);
          userDataRef= userDB.reference().child('users/$uid');//.child('uid');
          activeUser = 1;
        }
        else{
          user = widget.searchUser;
          displayName = user['name'];
          email = user['email'];
          photoUrl = user['photoUrl'];
          photoUrl = photoUrl==null?DotEnv().env['DEF_IMAGE']:photoUrl;
          groupColor = user['groupCode'];
          ringColor = Utilities.getGroupColor(groupColor.toString());
          bio = user['bio'];
          isVerified = user['isVerified'];
          instagram = user['instaHandle'];
          linkedin = user['linkedin'];
        }
      });
    }
    if(activeUser==1) {
      getValFromDB();
    }
    super.initState();
  }

  void reloadUser() async{
    await user.reload();
    var _user = await FirebaseAuth.instance.currentUser();
    if(mounted){
      setState(() {
        user = _user;
        displayName = user.displayName;
        email = user.email;
        photoUrl = user.photoUrl;
        photoUrl = photoUrl==null?DotEnv().env['DEF_IMAGE']:photoUrl;
        uid = user.uid;
        userDB = FirebaseDatabase(databaseURL: DotEnv().env['DB_URL']);
        userDataRef= userDB.reference().child('users/$uid');//.child('uid');
      });
    }
    getValFromDB();
  }

  void getValFromDB() async{
    DataSnapshot data = await userDataRef.once();
    dynamic dataValues = data.value;
    print(dataValues);
    if(mounted){
      setState(() {
        branch = dataValues['branch'];
        groupColor = dataValues['groupCode'];
        ringColor = Utilities.getGroupColor(dataValues['groupCode']);
        bio = dataValues['bio'];
        instagram = dataValues['instaHandle'];
        linkedin = dataValues['linkedin'];
        isVerified = dataValues['isVerified'];
      });
    }
  }

  void openig() async{
    var url = 'https://www.instagram.com/${instagram.replaceAll('@', '')}';
    if(await canLaunch(url)) {
      await launch(url, universalLinksOnly: true);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text("Failed to open Instagram"),
                content: Text("Please try again later. If still failing, please report to us!"),
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

  void openlinkedin() async{
    var url = '$linkedin';
    if(await canLaunch(url)) {
      await launch(url, universalLinksOnly: true);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text("Failed to open LinkedIn"),
                content: Text("Please try again later. If still failing, please report to us!"),
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: Utilities.vScale(MediaQuery.of(context).padding.top*2, context))),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/images/background300dpi.png"), fit: BoxFit.fitWidth),
              ),
            ),
            Positioned(
              right: Utilities.getRoundImageSize(-58, context),
              top: Utilities.getRoundImageSize(-68, context),
              child: SizedBox(
                height: Utilities.getRoundImageSize(400, context),
                width: Utilities.getRoundImageSize(400, context),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: MaterialColor(0xff262833, darkSeaGreenColorCodes),
                    borderRadius: BorderRadius.circular(Utilities.getRoundImageSize(400, context)/2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        spreadRadius: Utilities.scale(1, context),
                        blurRadius: Utilities.scale(2, context),
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: Utilities.getRoundImageSize(-38, context),
              top: Utilities.getRoundImageSize(-48, context),
              child: SizedBox(
                height: Utilities.getRoundImageSize(355, context),
                width: Utilities.getRoundImageSize(355, context),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: MaterialColor(0xff262833, darkSeaGreenColorCodes),
                    borderRadius: BorderRadius.circular(Utilities.getRoundImageSize(355, context)/2),
                    border: Border.all(
                      color: (ringColor==null)?Colors.white:ringColor, //Border color same as the group color.
                      width: Utilities.scale(5,context)
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: Utilities.getRoundImageSize(-30, context),
              top: Utilities.getRoundImageSize(-40, context),
              child: Container(
                width: Utilities.getRoundImageSize(335, context),
                height: Utilities.getRoundImageSize(335, context),
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(photoUrl)
                    )
                ),
                child: (activeUser==1)?FlatButton(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfile(
                        user: user,
                        bio: bio,
                        instagram: instagram,
                        ringColor: ringColor,
                        linkedin: linkedin,
                      ))).then((value) => reloadUser())
                    },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Utilities.getRoundImageSize(335, context)/2)
                  ),
                ):null,
              ),
            ),
            Positioned(
              right: Utilities.getRoundImageSize(0, context),
              top: Utilities.getRoundImageSize(400, context),
              child: SizedBox(
                height: Utilities.vScale(50, context),
                width: Utilities.scale(295, context),
                child: DecoratedBox(    //Add user name.
                  decoration: BoxDecoration(
                    color:  MaterialColor(0xff501f3a, darkMagentaColorCodes),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(Utilities.scale(10, context))),
                  ),
                  child: SizedBox(
                    width: Utilities.scale(280, context),
                    child: Center(
                      child: Text(
                        displayName==null?'':displayName,
                        style: TextStyle(
                          fontSize: Utilities.vScale(30, context),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right:Utilities.getRoundImageSize(0, context),
              top: Utilities.getRoundImageSize(450,context),
              child: SizedBox(
//                height: Utilities.vScale(250, context),
                width: Utilities.scale(295, context),
                child: DecoratedBox(    //Add user info (branch, group, instagram handle)
                  decoration: BoxDecoration(
                    color:  MaterialColor(0xffcb2d6f, magentaColorCodes),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(Utilities.scale(10, context))),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: Utilities.scale(280, context),
                      child: Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(top: Utilities.vScale(15, context))),
                          Text(
                            "${(bio!=null)?bio:''}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: Utilities.vScale(25, context),
                                color: Colors.white
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: Utilities.vScale(10, context))),
                          Text(
                            (isVerified)?"~ Maintainer":"~ From ${(branch!='' && branch!=null)?branch:'somewhere'}",
//                          textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: Utilities.vScale(18, context),
                                color: Colors.white
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: Utilities.vScale((linkedin=='' || linkedin==null)?0:8, context))),
                          SizedBox(
                            height: Utilities.vScale((linkedin=='' || linkedin==null)?0:40, context),
                            width: Utilities.scale(MediaQuery.of(context).size.width/2, context),
                            child: (linkedin=='' || linkedin==null)?null:FlatButton(
                              onPressed: openlinkedin,
                              child: Text(
                                  'LinkedIn',
                                  style: TextStyle(
                                    fontSize: Utilities.vScale(22,context),
                                    color: MaterialColor(0xFFcdcdcd, greyColorCodes),
                                  )
                              ),
                              color: MaterialColor(0x88501f3a, darkMagentaColorCodes),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Utilities.scale(25.0,context))
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: Utilities.vScale( (instagram=='' || instagram==null)?0:8, context))),
                          SizedBox(
                            height: Utilities.vScale( (instagram=='' || instagram==null)?0:40, context),
                            width: Utilities.scale(MediaQuery.of(context).size.width/2, context),
                            child: (instagram=='' || instagram==null)?null:FlatButton(
                              onPressed: openig,
                              child: Text(
                                  'Instagram',
                                  style: TextStyle(
                                    fontSize: Utilities.vScale(22,context),
                                    color: MaterialColor(0xFFcdcdcd, greyColorCodes),
                                  )
                              ),
                              color: MaterialColor(0x88501f3a, darkMagentaColorCodes),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(Utilities.scale(25.0,context)),
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: Utilities.vScale(7, context))),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          ],
        )
    );
  }
}