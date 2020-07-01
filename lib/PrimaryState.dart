import 'package:flutter/material.dart';
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
            color: (bottomSelectedIndex==0)?Colors.white:MaterialColor(0x88cdcdcd, greyColorCodes),
          ),
          title: Text((bottomSelectedIndex==0)?'Home':'',
            style: TextStyle(color: (bottomSelectedIndex==0)?Colors.white:MaterialColor(0x88cdcdcd, greyColorCodes)),
          )
      ),
      BottomNavigationBarItem(
          icon: new Icon(Icons.event_note,
            color: (bottomSelectedIndex==1)?Colors.white:MaterialColor(0x88cdcdcd, greyColorCodes),
          ),
          title: Text((bottomSelectedIndex==1)?'Schedule':'',
            style: TextStyle(color: (bottomSelectedIndex==1)?Colors.white:MaterialColor(0x88cdcdcd, greyColorCodes)),
          )
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.person,
            color: (bottomSelectedIndex==2)?Colors.white:MaterialColor(0x88cdcdcd, greyColorCodes),
          ),
          title: Text((bottomSelectedIndex==2)?'Profile':'',
            style: TextStyle(color: (bottomSelectedIndex==2)?Colors.white:MaterialColor(0x88cdcdcd, greyColorCodes)),
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
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        Home(),
        Schedule(),
        Profile(
            user: widget.user
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
      pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: buildPageView(),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: MaterialColor(0xff11292d, darkSeaGreenColorCodes),
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

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press back again to logout.");
      return Future.value(false);
    }
    return Future.value(true);
  }
}