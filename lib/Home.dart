import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'HomeState.dart';

class Home extends StatefulWidget {
  Home({Key key, this.user}) : super(key: key);

  final FirebaseUser user;
  @override
  HomeState createState() => HomeState();
}