import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'PrimaryState.dart';


class Primary extends StatefulWidget {
  Primary({Key key, this.title, this.user}) : super(key: key);

  final FirebaseUser user;
  final String title;

  @override
  PrimaryState createState() => PrimaryState();
}