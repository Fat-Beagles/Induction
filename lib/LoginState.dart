import "package:flutter/material.dart";
import 'package:induction/Utilities.dart';
import 'Primary.dart';
import "ColorCodes.dart";
import 'Login.dart';
import 'Brochure.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginState extends State<Login>{
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  final FirebaseAuth firebaseauth= FirebaseAuth.instance;
  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future loginService(String email, String password) async{
    try{
      var user=await firebaseauth.signInWithEmailAndPassword(email: email, password: password);
      return user!=null;
    } catch(e){
      return e.message;
    }
  }

  Future login(String email, String password) async {
    var result=await loginService(email, password);
    emailController.text='';
    passwordController.text='';
    if(result is bool){
      if(result){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Primary(title: "Home"))
        );
        return null;
      }
      else {
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("E-Mail id or Password is invalid."),
                  actions: <Widget>[
                    FlatButton(
                      child: new Text("Okay"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ]
              );
            }
        );
      }
    }
    else {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("E-Mail id or Password is invalid."),
                actions: <Widget>[
                  FlatButton(
                    child: new Text("Okay"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ]
            );
          }
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
                "SIGN IN",
                style: TextStyle(
                  fontSize: Utilities.scale(25,context),
                  color: MaterialColor(0xFFcdcdcd, greyColorCodes),
                ),
              )),
        ),
        body: Center(
            child: Container (
                padding: EdgeInsets.all(Utilities.scale(30.0,context)),
                color: MaterialColor(0xFF114546, darkSeaGreenColorCodes),
                child: Container(
                  child: Center(
                      child: Column(
                          children : [
                            Padding(padding: EdgeInsets.only(top:  Utilities.scale(50.0,context))),
                            Image.asset('assets/images/logofulldrop.png', width:Utilities.scale(MediaQuery.of(context).size.width-110,context), height: Utilities.vScale((MediaQuery.of(context).size.width-110)/2.41,context)),
                            Padding(padding: EdgeInsets.only(top: Utilities.scale(80.0,context))),
                            TextFormField(
                              controller: emailController,
                              cursorColor: MaterialColor(0xFFcdcdcd, greyColorCodes),
                              decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: TextStyle(color: MaterialColor(0xFFcdcdcd, greyColorCodes)),
                                hintText: "Enter Email",
                                hintStyle: TextStyle(color: MaterialColor(0x8514a098, seaGreenColorCodes)),
                                fillColor: MaterialColor(0xFFcdcdcd, greyColorCodes),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(Utilities.scale(25.0,context)),
                                  borderSide: BorderSide(
                                    color: MaterialColor(0xFF14a098, seaGreenColorCodes)
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(Utilities.scale(25.0,context)),
                                  borderSide: BorderSide(
                                      color: MaterialColor(0xFF14a098, seaGreenColorCodes)
                                  ),
                                ),
                              ),
                              validator: (val) {
                                if(val.length==0) {
                                  return "Email cannot be empty";
                                }else{
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                color: MaterialColor(0xcccdcdcd, greyColorCodes),
                                fontFamily: "Poppins",
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: Utilities.scale(30.0,context))),
                            TextFormField(
                              controller: passwordController,
                              cursorColor: MaterialColor(0xFFcdcdcd, greyColorCodes),
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: TextStyle(color: MaterialColor(0xFFcdcdcd, greyColorCodes)),
                                hintText: "Enter Password",
                                hintStyle: TextStyle(color: MaterialColor(0x8514a098, seaGreenColorCodes)),
                                fillColor: MaterialColor(0xFFcdcdcd, greyColorCodes),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(Utilities.scale(25.0,context)),
                                  borderSide: BorderSide(
                                      color: MaterialColor(0xFF14a098, seaGreenColorCodes)
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(Utilities.scale(25.0,context)),
                                  borderSide: BorderSide(
                                      color: MaterialColor(0xFF14a098, seaGreenColorCodes)
                                  ),
                                ),
                              ),
                              validator: (val) {
                                if(val.length==0) {
                                  return "Password cannot be empty";
                                }else{
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              style: TextStyle(
                                color: MaterialColor(0xcccdcdcd, greyColorCodes),
                                fontFamily: "Poppins",
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: Utilities.scale(30.0,context))),
                            SizedBox(
                              width: Utilities.scale(MediaQuery.of(context).size.width,context),
                              height: Utilities.scale(MediaQuery.of(context).size.height/15,context),
                              child: RaisedButton(
                                onPressed: () {
                                  String email=emailController.text;
                                  String password=passwordController.text;
                                  return this.login(email,password);
                                },
                                child: Text(
                                    'SIGN IN',
                                    style: TextStyle(
                                      fontSize: Utilities.scale(25,context),
                                      color: MaterialColor(0xFFcdcdcd, greyColorCodes),
                                    )
                                ),
                                color: MaterialColor(0xFF14a098, seaGreenColorCodes),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(Utilities.scale(25.0,context))
                                ),
                              ),
                            ),
                          ]
                      )
                  ),
                )
            )
        )
    );
  }
}