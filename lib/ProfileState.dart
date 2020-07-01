import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:induction/Utilities.dart';
import 'ColorCodes.dart';
import 'Profile.dart';

class ProfileState extends State<Profile> {
  String displayName;
  String email;
  String photoUrl;
  String uid;
  String branch;
  String groupColor;
  String instagram;
  FirebaseStorage storage;

  @override
  void initState(){
    setState(() {
      storage = FirebaseStorage(storageBucket: DotEnv().env['STORAGE_URL']);
      displayName = widget.user.displayName;
      email = widget.user.email;
      photoUrl = widget.user.photoUrl;
      photoUrl = photoUrl==null?DotEnv().env['DEF_IMAGE']:photoUrl;
      branch = "CSAM";
      groupColor = "Blue";
      instagram = "@dhruvsahnan";
      uid = widget.user.uid;
    });
    print(displayName);
    print(email);
    print(photoUrl);
    print(uid);
    super.initState();
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
                      color: Colors.white, //Border color same as the group color.
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
                        fit: BoxFit.fill,
                        image: NetworkImage(photoUrl)
                    )
                ),
                child: FlatButton(
                  onPressed: () => {print("Hello")},
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Utilities.getRoundImageSize(335, context)/2)
                  ),
                ),
              ),
            ),
            Positioned(
              right: Utilities.getRoundImageSize(-25, context),
              top: Utilities.getRoundImageSize(400, context),
              child: SizedBox(
                height: Utilities.vScale(50, context),
                width: Utilities.scale(320, context),
                child: DecoratedBox(    //Add user name.
                  decoration: BoxDecoration(
                    color:  MaterialColor(0xff501f3a, darkMagentaColorCodes),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(Utilities.scale(10, context)), topRight: Radius.circular(Utilities.scale(10, context)) ),
                  ),
                  child: Center(
                      child: Text(
                          displayName,
                          style: TextStyle(
                            fontSize: Utilities.vScale(30, context),
                            color: Colors.white,
                          ),
                      )),
                ),
              ),
            ),
            Positioned(
              right:Utilities.getRoundImageSize(-25, context),
              top: Utilities.getRoundImageSize(450,context),
              child: SizedBox(
//                height: Utilities.vScale(250, context),
                width: Utilities.scale(320, context),
                child: DecoratedBox(    //Add user info (branch, group, instagram handle)
                  decoration: BoxDecoration(
                    color:  MaterialColor(0xffcb2d6f, magentaColorCodes),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(Utilities.scale(10, context)), bottomRight: Radius.circular(Utilities.scale(10, context)) ),
                  ),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          "\nBranch         $branch\nGroup          $groupColor\n",
                          style: TextStyle(
                              fontSize: Utilities.vScale(30, context),
                              color: Colors.white
                          ),
                        ),
                        Text(
                          "\n${instagram==null?'':"Instagram: @dhruvsahnan"}\n",
                          style: TextStyle(
                              fontSize: Utilities.vScale(25, context),
                              color: Colors.white
                          ),
                        )
                      ],
                    )
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}