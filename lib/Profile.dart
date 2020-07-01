import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'ProfileState.dart';

class Profile extends StatefulWidget {
  Profile({Key key, this.user}) : super(key: key);

  final FirebaseUser user;

  @override
  ProfileState createState() => ProfileState();
}