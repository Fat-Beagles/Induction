import 'package:flutter/material.dart';
import 'package:induction/Utilities.dart';
import 'ColorCodes.dart';
import 'Profile.dart';

class ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: Utilities.scale(MediaQuery.of(context).padding.top*2, context))),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/images/background300dpi.png"), fit: BoxFit.fitWidth),
              ),
            ),
            Positioned(
              right: Utilities.scale(-60,context),
              top: Utilities.scale(-70,context),
              child: SizedBox(
                height: Utilities.scale(400, context),
                width: Utilities.scale(400, context),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: MaterialColor(0xff262833, darkSeaGreenColorCodes),
                    borderRadius: BorderRadius.circular(Utilities.scale(200, context)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        spreadRadius: Utilities.scale(1, context),
                        blurRadius: Utilities.scale(2, context),
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: Utilities.scale(-40,context),
              top: Utilities.scale(-50,context),
              child: SizedBox(
                height: Utilities.scale(355, context),
                width: Utilities.scale(355, context),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: MaterialColor(0xff262833, darkSeaGreenColorCodes),
                    borderRadius: BorderRadius.circular(Utilities.scale(195, context)),
                    border: Border.all(
                      color: Colors.white, //Border color same as the group color.
                      width: Utilities.scale(5,context)
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: Utilities.scale(-30,context),
              top: Utilities.scale(-40,context),
              child: SizedBox(
                height: Utilities.scale(335, context),
                width: Utilities.scale(335, context),
                child: DecoratedBox(    //Replace by user image.
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Utilities.scale(195, context)),
                  ),
                ),
              ),
            ),
            Positioned(
              right: Utilities.scale(-25,context),
              top: Utilities.scale(400,context),
              child: SizedBox(
                height: Utilities.scale(50, context),
                width: Utilities.scale(320, context),
                child: DecoratedBox(    //Add user name.
                  decoration: BoxDecoration(
                    color:  MaterialColor(0xff501f3a, darkMagentaColorCodes),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(Utilities.scale(10, context)), topRight: Radius.circular(Utilities.scale(10, context)) ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: Utilities.scale(-25,context),
              top: Utilities.scale(450,context),
              child: SizedBox(
                height: Utilities.scale(250, context),
                width: Utilities.scale(320, context),
                child: DecoratedBox(    //Add user info (branch, group, instagram handle)
                  decoration: BoxDecoration(
                    color:  MaterialColor(0xffcb2d6f, magentaColorCodes),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(Utilities.scale(10, context)), bottomRight: Radius.circular(Utilities.scale(10, context)) ),
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}