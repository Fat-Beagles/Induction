import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'EditProfileState.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key key, this.user, this.bio, this.instagram, this.ringColor, this.linkedin}) : super(key: key);

  final FirebaseUser user;
  final String bio;
  final String instagram;
  final String linkedin;
  final dynamic ringColor;

  @override
  EditProfileState createState() => EditProfileState();
}