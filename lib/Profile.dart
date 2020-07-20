import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'ProfileState.dart';

class Profile extends StatefulWidget {
  Profile({Key key, this.curUser, this.searchUser}) : super(key: key);

  final FirebaseUser curUser;
  final dynamic searchUser;

  @override
  ProfileState createState() => ProfileState();
}