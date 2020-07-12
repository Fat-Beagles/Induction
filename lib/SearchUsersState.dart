import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'SearchUsers.dart';
import 'Utilities.dart';
import 'ColorCodes.dart';

class SearchUsersState extends State<SearchUsers>{
  List<dynamic> allUsers = new List();
  FirebaseDatabase usersDB;
  DatabaseReference usersDBRef;
  FirebaseStorage storage;

  @override
  void initState(){
    if(mounted){
      setState(() {
        usersDB = FirebaseDatabase(databaseURL: DotEnv().env['DB_URL']);
        usersDBRef = usersDB.reference().child('users');
        storage = FirebaseStorage(storageBucket: DotEnv().env['STORAGE_URL']);
      });
    }
    getUsersFromDB();
    super.initState();
  }

  void getUsersFromDB() async {
    DataSnapshot data = await usersDBRef.once();
    dynamic values = data.value;
    values.forEach((k,v) async {
      try{
        if(values[k]['name'].replaceAll(' ','')!=''){
          values[k]['photoUrl'] = await storage.ref().child('ProfilePictures').child('$k.jpeg').getDownloadURL();
          if(mounted){
            setState(() {
              allUsers.add(values[k]);
            });
          }
        }
      }
      catch(e){
        //Do nothing. Only to check if name is present in the Map.
      }
    });
  }

  Widget userTile(dynamic user){
    return Card(
      child: ListTile(
        leading: Image.network((user['photoUrl']==null)?DotEnv().env['DEF_IMAGE']:user['photoUrl']),
        title: Text(user['name']),
        trailing: Text(user['branch']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: allUsers.map((e) => userTile(e)).toList(),
          ),
        )
      )
    );
  }
}