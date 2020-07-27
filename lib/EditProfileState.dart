import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:induction/Utilities.dart';
import 'ColorCodes.dart';
import 'EditProfile.dart';

class EditProfileState extends State<EditProfile> {
  String displayName='';
  String email='';
  String oldEmail='';
  String photoUrl='';
  String newPhotoUrl='';
  String uid='';
  String instagram='';
  String linkedin='';
  String bio='';
  FirebaseStorage storage;
  FirebaseDatabase userDB;
  DatabaseReference userDataRef;
  File profileImage;
  int timeSaved;
  final emailController = TextEditingController();
  final bioController = TextEditingController();
  final igController = TextEditingController();
  final nameController = TextEditingController();
  final linkedinController = TextEditingController();

  @override
  void initState(){
    if(mounted){
      setState(() {
        instagram = widget.instagram;
        linkedin = widget.linkedin;
        bio = widget.bio;
        storage = FirebaseStorage(storageBucket: DotEnv().env['STORAGE_URL']);
        displayName = widget.user.displayName;
        email = widget.user.email;
        oldEmail = widget.user.email;
        photoUrl = widget.user.photoUrl;
        photoUrl = photoUrl==null?DotEnv().env['DEF_IMAGE']:photoUrl;
        uid = widget.user.uid;
        userDB = FirebaseDatabase(databaseURL: DotEnv().env['DB_URL']);
        userDataRef= userDB.reference().child('users/$uid');//.child('uid');
        emailController.text = email;
        igController.text = instagram;
        linkedinController.text = linkedin;
        bioController.text = bio;
        nameController.text = displayName;
      });
    }
    super.initState();
  }

  Future<StorageReference> uploadPicture() async {
    final StorageReference ref = storage.ref().child('ProfilePictures').child('$uid.jpeg');
    final StorageUploadTask uploadTask = ref.putFile(profileImage);
    await uploadTask.onComplete;
    return ref;
  }

  Future<void> applyChanges() async{
    setState(() {
      timeSaved = new DateTime.now().millisecondsSinceEpoch;
    });
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Updating"),
              content: Text("Please Wait ..."),
          );
        }
    );
    try{
      await widget.user.updateEmail(email);
    }
    catch(e){
      print(e.toString());
      await widget.user.updateEmail(oldEmail);
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text("Failed to update E-Mail"),
                content: Text("Check E-Mail ID again (might already be in use). Try logging in again."),
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

    try{
      UserUpdateInfo newInfo = new UserUpdateInfo();
      if(profileImage!=null){
        StorageReference ref = await uploadPicture();
        String url = await ref.getDownloadURL();
        if(mounted){
          setState(() {
            newPhotoUrl = url;
          });
        }
        newInfo.photoUrl = newPhotoUrl;
      }
      if(displayName.replaceAll(' ', '').length!=0){
        newInfo.displayName = displayName;
        await widget.user.updateProfile(newInfo);
      }
    }
    catch(e){
      await widget.user.updateEmail(oldEmail);
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text("Failed to update user name!"),
                content: Text("Please try again later."),
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

    try{
      await userDataRef.child('name').set(displayName);
      await userDataRef.child('bio').set(bio);
      await userDataRef.child('instaHandle').set(instagram);
      await userDataRef.child('linkedin').set(linkedin);
    }
    catch(e){
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text("Failed to update user information!"),
                content: Text("Please try again later."),
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
    Navigator.pop(context);
  }

  Future getImage() async {
    var _newProfileImage = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      profileImage = File(_newProfileImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: MaterialColor(0xff262833, darkSeaGreenColorCodes),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(MediaQuery.of(context).padding.top+5, context))),
              SizedBox(
                height: MediaQuery.of(context).size.height/3,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: SizedBox(
                        height: Utilities.getRoundImageSize(280, context),
                        width: Utilities.getRoundImageSize(280, context),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: MaterialColor(0x55262833, darkSeaGreenColorCodes),
                            borderRadius: BorderRadius.circular(Utilities.getRoundImageSize(280, context)/2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                spreadRadius: Utilities.scale(1, context),
                                offset: Offset(0, 0), // changes position of shadow
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        height: Utilities.getRoundImageSize(255, context),
                        width: Utilities.getRoundImageSize(255, context),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: MaterialColor(0xff262833, darkSeaGreenColorCodes),
                            borderRadius: BorderRadius.circular(Utilities.getRoundImageSize(355, context)/2),
                            border: Border.all(
                                color: (widget.ringColor==null)?Colors.white:widget.ringColor, //Border color same as the group color.
                                width: Utilities.scale(5,context)
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: Utilities.getRoundImageSize(235, context),
                        height: Utilities.getRoundImageSize(235, context),
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.cover,
                                image: (profileImage==null)?NetworkImage(photoUrl):FileImage(profileImage)
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
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(5, context))),
              SizedBox(
                height: Utilities.vScale(40, context),
                width: Utilities.scale(MediaQuery.of(context).size.width - 100, context),
                child: FlatButton(
                  onPressed: getImage,
                  child: Text(
                      'Change profile photo',
                      style: TextStyle(
                        fontSize: Utilities.vScale(20,context),
                        color: MaterialColor(0xFFcdcdcd, greyColorCodes),
                      )
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Utilities.scale(25.0,context))
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(10, context))),
              SizedBox(
                height: Utilities.vScale(50, context),
                width: Utilities.scale(320, context),
                child: DecoratedBox(    //Add user name.
                  decoration: BoxDecoration(
                    color:  MaterialColor(0xff501f3a, darkMagentaColorCodes),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(Utilities.scale(10, context)), topRight: Radius.circular(Utilities.scale(10, context)) ),
                  ),
                  child: Center(
                    child: SizedBox(
                      child: TextFormField(
                        controller: nameController,
                        cursorColor: MaterialColor(0xFFcdcdcd, greyColorCodes),
                        autocorrect: true,
                        decoration: InputDecoration(
                          hintText: "Change name",
                          hintStyle: TextStyle(color: MaterialColor(0x88cdcdcd, greyColorCodes)),
                          fillColor: MaterialColor(0xFFcdcdcd, greyColorCodes),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          counterText: '',
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 1,
                        maxLength: 30,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: MaterialColor(0xffffffff, greyColorCodes),
                            fontFamily: "Poppins",
                            fontSize: Utilities.vScale(25, context)
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: Utilities.scale(320, context),
                child: DecoratedBox(    //Add user info (branch, group, instagram handle)
                  decoration: BoxDecoration(
                    color:  MaterialColor(0xffcb2d6f, magentaColorCodes),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(Utilities.scale(10, context)), bottomRight: Radius.circular(Utilities.scale(10, context)) ),
                  ),
                  child: Center(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: Utilities.scale(3*320/4, context),
                            child: Column(
                              children: <Widget>[
                                Center(
                                  child: TextFormField(
                                    controller: emailController,
                                    cursorColor: MaterialColor(0xFFcdcdcd, greyColorCodes),
                                    autocorrect: true,
                                    decoration: InputDecoration(
                                      labelText: "E-mail",
                                      labelStyle: TextStyle(color: MaterialColor(0xFFcdcdcd, greyColorCodes)),
                                      hintText: "Change e-mail address",
                                      hintStyle: TextStyle(color: MaterialColor(0x88cdcdcd, greyColorCodes)),
                                      fillColor: MaterialColor(0xFFcdcdcd, greyColorCodes),
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: MaterialColor(0xcccdcdcd, greyColorCodes),
                                        fontFamily: "Poppins",
                                        fontSize: Utilities.vScale(20, context)
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: Utilities.vScale(10, context))),
                                Center(
                                  child: TextFormField(
                                    controller: bioController,
                                    cursorColor: MaterialColor(0xFFcdcdcd, greyColorCodes),
                                    autocorrect: true,
                                    decoration: InputDecoration(
                                      labelText: "Bio",
                                      labelStyle: TextStyle(color: MaterialColor(0xFFcdcdcd, greyColorCodes)),
                                      hintText: "Change bio",
                                      hintStyle: TextStyle(color: MaterialColor(0x88cdcdcd, greyColorCodes)),
                                      fillColor: MaterialColor(0xFFcdcdcd, greyColorCodes),
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      counterStyle: TextStyle(color: MaterialColor(0xcccdcdcd, greyColorCodes)),
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    maxLength: 140,
                                    style: TextStyle(
                                        color: MaterialColor(0xcccdcdcd, greyColorCodes),
                                        fontFamily: "Poppins",
                                        fontSize: Utilities.vScale(20, context)
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: Utilities.vScale(10, context))),
                                Center(
                                  child: TextFormField(
                                    controller: igController,
                                    cursorColor: MaterialColor(0xFFcdcdcd, greyColorCodes),
                                    autocorrect: true,
                                    decoration: InputDecoration(
                                      labelText: "Instagram",
                                      labelStyle: TextStyle(color: MaterialColor(0xFFcdcdcd, greyColorCodes)),
                                      hintText: "Enter Instagram handle",
                                      hintStyle: TextStyle(color: MaterialColor(0x88cdcdcd, greyColorCodes)),
                                      fillColor: MaterialColor(0xFFcdcdcd, greyColorCodes),
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: MaterialColor(0xcccdcdcd, greyColorCodes),
                                        fontFamily: "Poppins",
                                        fontSize: Utilities.vScale(20, context)
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: Utilities.vScale(10, context))),
                                Center(
                                  child: TextFormField(
                                    controller: linkedinController,
                                    cursorColor: MaterialColor(0xFFcdcdcd, greyColorCodes),
                                    autocorrect: true,
                                    decoration: InputDecoration(
                                      labelText: "LinkedIn",
                                      labelStyle: TextStyle(color: MaterialColor(0xFFcdcdcd, greyColorCodes)),
                                      hintText: "Enter LinkedIn profile URL",
                                      hintStyle: TextStyle(color: MaterialColor(0x88cdcdcd, greyColorCodes)),
                                      fillColor: MaterialColor(0xFFcdcdcd, greyColorCodes),
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: MaterialColor(0xcccdcdcd, greyColorCodes),
                                        fontFamily: "Poppins",
                                        fontSize: Utilities.vScale(20, context)
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: Utilities.vScale(10, context))),
                              ],
                            ),
                          )
                        ],
                      )
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(20, context))),
              SizedBox(
                width: Utilities.scale(320,context),
                height: Utilities.vScale(MediaQuery.of(context).size.height,context)/12,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: Utilities.scale(154,context),
                      height: Utilities.vScale(MediaQuery.of(context).size.height,context)/15,
                      child: FlatButton(
                        onPressed: () {
                          setState(() {
                            email = emailController.text;
                            bio = bioController.text;
                            instagram = igController.text;
                            displayName = nameController.text;
                            linkedin = linkedinController.text;
                          });
                          applyChanges();
                        },
                        child: Text(
                            'Save',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: Utilities.vScale(22,context),
                              color: MaterialColor(0xFFcdcdcd, greyColorCodes),
                            )
                        ),
                        color: MaterialColor(0xFF14a098, seaGreenColorCodes),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Utilities.scale(25.0,context))
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: Utilities.scale(12, context))),
                    SizedBox(
                      width: Utilities.scale(154,context),
                      height: Utilities.vScale(MediaQuery.of(context).size.height,context)/15,
                      child: FlatButton(
                        onPressed: () async {
                          try{
                            await FirebaseAuth.instance.signOut();
                          }
                          finally{
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          }
                        },
                        child: Text(
                            'Logout',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: Utilities.vScale(22,context),
                              color: MaterialColor(0xFFcdcdcd, greyColorCodes),
                            )
                        ),
                        color: MaterialColor(0xFF114546, darkSeaGreenColorCodes),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Utilities.scale(25.0,context))
                        ),
                      ),
                    ),
                  ],
                )
              ),
              Padding(padding: EdgeInsets.only(top: Utilities.vScale(40, context))),
            ],
          ),
        )
    );
  }
}