import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Login.dart';
import 'ColorCodes.dart';

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: "Induction '20",
      theme: ThemeData(
          primarySwatch: MaterialColor(0xFF511F3A, darkMagentaColorCodes)
      ),
      home: Login(),
    );
  }
}