import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'SearchUsersState.dart';

class SearchUsers extends StatefulWidget {
  SearchUsers({Key key, this.user}) : super(key: key);

  final FirebaseUser user;

  @override
  SearchUsersState createState() => SearchUsersState();
}