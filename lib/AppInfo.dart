import "package:flutter/material.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:induction/Utilities.dart';
import 'ColorCodes.dart';

class AppInfo extends StatelessWidget {

  Widget getRow(String col1, String col2, BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
            child: SizedBox(
              width: Utilities.scale(MediaQuery.of(context).size.width/2-50, context),
              child: Center(
                child: Text(
                  col1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: Utilities.vScale(20,context),
                      fontWeight: FontWeight.bold,
                      color: MaterialColor(0xFF114546, darkSeaGreenColorCodes),
                      fontFamily: "Poppins"
                  ),
                ),
              ),
            )
        ),
        Padding(padding: EdgeInsets.only(left: Utilities.vScale(10, context))),
        Center(
          child: SizedBox(
            width: Utilities.scale(MediaQuery.of(context).size.width/2-50, context),
            child: Center(
              child: Text(
                col2,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: Utilities.vScale(20,context),
//                    fontWeight: FontWeight.bold,
                    color: MaterialColor(0xFF114546, darkSeaGreenColorCodes),
                    fontFamily: "Poppins"
                ),
              ),
            ),
          )
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MaterialColor(0xff262833, darkSeaGreenColorCodes),
        body: Container(
            padding: EdgeInsets.only(left: Utilities.scale(15, context), right: Utilities.scale(15,context)),
            color: MaterialColor(0xff262833, darkSeaGreenColorCodes),
            child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: Utilities.vScale(MediaQuery.of(context).padding.top*1.5, context))),
                    Center(
                      child: Text(
                        "APP INFO",
                        style: TextStyle(
                            fontSize: Utilities.vScale(55,context),
                            fontWeight: FontWeight.bold,
                            color: MaterialColor(0xcccb2d6f, magentaColorCodes),
                            fontFamily: "Poppins"
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: Utilities.vScale(20, context))),
                    Center(
                      child: SizedBox(
//                  height: Utilities.getRoundImageSize(MediaQuery.of(context).size.width, context),
                        width: Utilities.getRoundImageSize(MediaQuery.of(context).size.width, context),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: MaterialColor(0xaa14a098, seaGreenColorCodes),
                            borderRadius: BorderRadius.circular(Utilities.scale(30, context)/2),
                            border: Border.all(
                                color: MaterialColor(0xFF114546, darkSeaGreenColorCodes), //Border color same as the group color.
                                width: Utilities.scale(3,context)
                            ),
                          ),
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Padding(padding: EdgeInsets.only(top: Utilities.vScale(35, context))),
                                getRow("Version", DotEnv().env['APP_VER'], context),
                                Padding(padding: EdgeInsets.only(top: Utilities.vScale(20, context))),
                                getRow("Designed By", "Yatharth Taneja", context),
                                Padding(padding: EdgeInsets.only(top: Utilities.vScale(20, context))),
                                getRow("Developed By", "Dhruv Sahnan\nand\nVasu Goel", context),
                                Padding(padding: EdgeInsets.only(top: Utilities.vScale(35, context))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/images/iiitdgraphicidentity.png', width:Utilities.scale(MediaQuery.of(context).size.width/2,context), height: Utilities.vScale((MediaQuery.of(context).size.width/3),context)/2.41,),
                        Padding(padding: EdgeInsets.only(left: Utilities.scale(10, context))),
                        Image.asset('assets/images/logoFullNoShadow.png', width:Utilities.scale(MediaQuery.of(context).size.width/6,context), height: Utilities.vScale((MediaQuery.of(context).size.width/6),context)/2.41, color: Colors.white,)
                      ],
                    )
                  ],
                )
            )
        )
    );
  }
}