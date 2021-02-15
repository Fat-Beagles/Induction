import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'GalleryState.dart';


class Gallery extends StatefulWidget {
  Gallery({Key key, this.user}) : super(key: key);

  final FirebaseUser user;
  @override
  GalleryState createState() => GalleryState();
}