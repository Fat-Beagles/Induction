import 'package:flutter/material.dart';
import 'EventsOnDayState.dart';

class EventsOnDay extends StatefulWidget {
  EventsOnDay({Key key, this.userGroup, this.day, this.schedule, this.dayNum}) : super(key: key);
  final List<dynamic> schedule;
  final String userGroup;
  final String day;
  final int dayNum;

  @override
  EventsOnDayState createState() => EventsOnDayState();
}