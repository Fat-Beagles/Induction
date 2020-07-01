import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'Application.dart';

void main() async {
  DotEnv().load('.env');
  runApp(Application());
}