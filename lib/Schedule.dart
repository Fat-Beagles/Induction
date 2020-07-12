import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'ScheduleState.dart';

class Schedule extends StatefulWidget {
  Schedule({Key key, this.user}) : super(key: key);

  final FirebaseUser user;

  @override
  ScheduleState createState() => ScheduleState();
}