import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:induction/SearchUsers.dart';
import 'ColorCodes.dart';
import 'Home.dart';
import 'Primary.dart';
import 'Profile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Schedule.dart';

class PrimaryState extends State<Primary> {
  int bottomSelectedIndex = 0;
  DateTime currentBackPressTime;

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: new Icon(Icons.home,
            color: (bottomSelectedIndex==0)?MaterialColor(0xcccb2d6f, magentaColorCodes):MaterialColor(0xff501f3a, darkMagentaColorCodes),
          ),
          title: Text((bottomSelectedIndex==0)?'Home':'',
            style: TextStyle(color: (bottomSelectedIndex==0)?MaterialColor(0xcccb2d6f, magentaColorCodes):MaterialColor(0xff501f3a, darkMagentaColorCodes)),
          )
      ),
      BottomNavigationBarItem(
          icon: new Icon(Icons.event_note,
            color: (bottomSelectedIndex==1)?MaterialColor(0xcccb2d6f, magentaColorCodes):MaterialColor(0xff501f3a, darkMagentaColorCodes),
          ),
          title: Text((bottomSelectedIndex==1)?'Schedule':'',
            style: TextStyle(color: (bottomSelectedIndex==1)?MaterialColor(0xcccb2d6f, magentaColorCodes):MaterialColor(0xff501f3a, darkMagentaColorCodes)),
          )
      ),
      BottomNavigationBarItem(
          icon: new Icon(Icons.contacts,
            color: (bottomSelectedIndex==2)?MaterialColor(0xcccb2d6f, magentaColorCodes):MaterialColor(0xff501f3a, darkMagentaColorCodes),
          ),
          title: Text((bottomSelectedIndex==2)?'People':'',
            style: TextStyle(color: (bottomSelectedIndex==2)?MaterialColor(0xcccb2d6f, magentaColorCodes):MaterialColor(0xff501f3a, darkMagentaColorCodes)),
          )
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.face,
            color: (bottomSelectedIndex==3)?MaterialColor(0xcccb2d6f, magentaColorCodes):MaterialColor(0xff501f3a, darkMagentaColorCodes),
          ),
          title: Text((bottomSelectedIndex==3)?'Profile':'',
            style: TextStyle(color: (bottomSelectedIndex==3)?MaterialColor(0xcccb2d6f, magentaColorCodes):MaterialColor(0xff501f3a, darkMagentaColorCodes)),
          )
      )
    ];
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      physics: NeverScrollableScrollPhysics(),
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        Home(
          user: widget.user,
        ),
        Schedule(
          user: widget.user,
        ),
        SearchUsers(
          user: widget.user
        ),
        Profile(
            curUser: widget.user
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: buildPageView(),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: MaterialColor(0xff151722, darkSeaGreenColorCodes),
          currentIndex: bottomSelectedIndex,
          onTap: (index) {
            bottomTapped(index);
          },
          items: buildBottomNavBarItems(),
        ),
      ),
      onWillPop: onWillPop,
    );
  }

  Future<bool> onWillPop() async{
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press back again to logout.");
      return Future.value(false);
    }
    await FirebaseAuth.instance.signOut();
    return Future.value(true);
  }
}