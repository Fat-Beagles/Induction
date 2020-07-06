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
  FirebaseUser user;
  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future loginService(String email, String password) async{
    try{
      var resUser=await firebaseauth.signInWithEmailAndPassword(email: email, password: password);
      setState(() {
        this.user = resUser.user;
      });
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
            MaterialPageRoute(builder: (context) => Primary(
                                                      title: "Home",
                                                      user: this.user
                                                    ))
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
              content: Text(result),
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
                  fontSize: Utilities.vScale(25,context),
                  color: MaterialColor(0xFFcdcdcd, greyColorCodes),
                ),
              )),
        ),
        body: Container (
            padding: EdgeInsets.only(top: Utilities.vScale(30.0,context), bottom: Utilities.vScale(30,context), left: Utilities.scale(30,context), right: Utilities.scale(30,context)),
            color: MaterialColor(0xFF114546, darkSeaGreenColorCodes),
            alignment: Alignment.center,
            child: SingleChildScrollView(
                child: Column(
                    children : [
                      Padding(padding: EdgeInsets.only(top:  Utilities.vScale(50.0,context))),
                      Image.asset('assets/images/logofulldrop.png', width:Utilities.scale(MediaQuery.of(context).size.width-110,context), height: Utilities.vScale((MediaQuery.of(context).size.width-110),context)/2.41),
                      Padding(padding: EdgeInsets.only(top: Utilities.vScale(30.0,context))),
                      Container(
                        width: Utilities.scale(MediaQuery.of(context).size.width,context),
                        height: Utilities.vScale(MediaQuery.of(context).size.height,context)/10,
                        child: TextFormField(
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
                              fontSize: Utilities.vScale(15, context)
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: Utilities.vScale(10.0,context))),
                      Container(
                        width: Utilities.scale(MediaQuery.of(context).size.width,context),
                        height: Utilities.vScale(MediaQuery.of(context).size.height,context)/10,
                        child: TextFormField(
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
                              fontSize: Utilities.vScale(15, context)
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: Utilities.vScale(10.0,context))),
                      SizedBox(
                        width: Utilities.scale(MediaQuery.of(context).size.width,context),
                        height: Utilities.vScale(MediaQuery.of(context).size.height,context)/12,
                        child: RaisedButton(
                          onPressed: () {
                            String email=emailController.text;
                            String password=passwordController.text;
                            return this.login(email,password);
                          },
                          child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                fontSize: Utilities.vScale(25,context),
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
        ),
    );
  }
}