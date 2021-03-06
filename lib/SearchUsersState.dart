import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:induction/EditProfile.dart';
import 'package:induction/EventsOnDay.dart';
import 'package:induction/Profile.dart';
import 'package:induction/Utilities.dart';
import 'ColorCodes.dart';
import 'SearchUsers.dart';

class SearchUsersState extends State<SearchUsers> {
  List<dynamic> allUsers = new List();
  int numUsers = 0;
  FirebaseDatabase usersDB;
  DatabaseReference usersDBRef;
  FirebaseStorage storage;
  bool _hasMore = true;
  int lenFetched = 0;
  bool _isLoading = true;

  @override
  void initState(){
    if(mounted){
      setState(() {
        usersDB = FirebaseDatabase(databaseURL: DotEnv().env['DB_URL']);
        usersDBRef = usersDB.reference().child('users');
        storage = FirebaseStorage(storageBucket: DotEnv().env['STORAGE_URL']);
      });
    }
//    _loadMore();
    getUsersFromDB();
    super.initState();
  }

  void getNumUsers() async {
    int num = (await usersDBRef.once()).value.length;
    setState(() {
      numUsers = num;
    });
  }

  void getUsersFromDB() async {
    DataSnapshot data = await usersDBRef.once();
    dynamic values = data.value;
    values.forEach((k,v) async {
      try{
        if(k!=widget.user.uid && values[k]['name'].replaceAll(' ','')!=''){
          if(values[k]['photoUrl']==null || values[k]['photoUrl']==''){
            values[k]['photoUrl'] = DotEnv().env['DEF_IMAGE'];
          }
          if(mounted){
            setState(() {
              allUsers.add(values[k]);
            });
            allUsers.sort((a,b) => Utilities.compareNames(a,b));
          }
        }
      }
      catch(e){
        //Do nothing. Only to check if name is present in the Map.
      }
    });
  }

//  void _loadMore() async{
//    setState(() {
//      _isLoading = true;
//    });
//    int count = 0;
//    Query dataX;
//    if(allUsers.length == 0){
//      dataX = usersDBRef.orderByChild("name").limitToFirst(50);
//    }
//    else{
//      dataX = usersDBRef.orderByChild("name").startAt(allUsers.last['uid'], key: 'uid').limitToFirst(50);
//    }
//    dataX.onChildAdded.listen((event) {
//      count ++;
//      if(mounted){
//        setState(() {
//          if(event.snapshot.value['name']!=null && event.snapshot.value['name'].replaceAll(' ','')!='') {
//            allUsers.add(event.snapshot.value);
//          }
//        });
//      }
//      if(count == 50){
//        setState(() {
//          _isLoading = false;
//        });
//      }
//    });
//  }

  Widget userTile(dynamic user){
    print(user);
    int active = 0 ;
    List<Widget> profileImage = [
      Center(
        child: SizedBox(
          height: Utilities.getRoundImageSize(57, context),
          width: Utilities.getRoundImageSize(57, context),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: MaterialColor(0xff262833, darkSeaGreenColorCodes),
              borderRadius: BorderRadius.circular(Utilities.getRoundImageSize(355, context)/2),
            ),
          ),
        ),
      ),
      Center(
        child: SizedBox(
          height: Utilities.getRoundImageSize(50, context),
          width: Utilities.getRoundImageSize(50, context),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: MaterialColor(0xff262833, darkSeaGreenColorCodes),
              borderRadius: BorderRadius.circular(Utilities.getRoundImageSize(355, context)/2),
              border: Border.all(
                  color: Utilities.getGroupColor(int.parse(user['groupCode'].substring(1))), //Border color same as the group color.
                  width: Utilities.scale(5,context)
              ),
            ),
          ),
        ),
      ),
      Center(
        child: Container(
          width: Utilities.getRoundImageSize(45, context),
          height: Utilities.getRoundImageSize(45, context),
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(user['photoUrl']),
              )
          ),
//                      child: FlatButton(
//                        onPressed: () => {print("Hello")},
//                        shape: RoundedRectangleBorder(
//                            borderRadius: BorderRadius.circular(Utilities.getRoundImageSize(335, context)/2)
//                        ),
//                      ),
        ),
      ),
    ];

    return SizedBox(
        width: Utilities.scale(MediaQuery.of(context).size.width,context),
        height: Utilities.vScale(75,context),
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: (active==0)?MaterialColor(0xFF14a098, seaGreenColorCodes):MaterialColor(0xFF114546, darkSeaGreenColorCodes),
              borderRadius: BorderRadius.circular(Utilities.scale(7.5,context))
          ),
          child: OutlineButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile(
                    searchUser: user
                  ))
              );
            },
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: Utilities.scale(MediaQuery.of(context).size.width/5-10, context),
                  child: Stack(
                      children: profileImage
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: Utilities.scale(10,context))),
                Center(
                  child: Text(
                    "${user['name']}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: Utilities.vScale(25.0, context),
                      color: (active==0)?MaterialColor(0xFF114546, darkSeaGreenColorCodes):MaterialColor(0xFF14a098, seaGreenColorCodes),
                    ),
                  ),
                ),
              ],
            ),
            borderSide: BorderSide(
                color: (active==0)?MaterialColor(0xFF114546, darkSeaGreenColorCodes):MaterialColor(0xFF14a098, seaGreenColorCodes),
                width: Utilities.scale(4,context)
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Utilities.scale(7.5,context))
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> userContents = [
      Center(
        child: Text(
          "DISCOVER",
          style: TextStyle(
              fontSize: Utilities.vScale(55,context),
              fontWeight: FontWeight.bold,
              color: MaterialColor(0xcccb2d6f, magentaColorCodes),
              fontFamily: "Poppins"
          ),
        ),
      ),
    ];
    for(var i=0; i<((allUsers!=null)?allUsers.length:0); i++){
      userContents.add(Padding(padding: EdgeInsets.only(top: Utilities.vScale((i==0)?30:13,context))));
      userContents.add(userTile(allUsers[i]));
    }
    return Scaffold(
        backgroundColor: MaterialColor(0xff262833, darkSeaGreenColorCodes),
        body: SingleChildScrollView (
            child: Container(
              padding: EdgeInsets.only(top: Utilities.vScale(MediaQuery.of(context).padding.top*2, context), left: Utilities.scale(30,context), right: Utilities.scale(30,context), bottom: Utilities.vScale(30,context)),
              child: Column(
                  children: userContents
              ),
            )
        )
    );
//    return Scaffold(
//      backgroundColor: MaterialColor(0xff262833, darkSeaGreenColorCodes),
//      body: ListView.builder(
//          padding: EdgeInsets.only(left: Utilities.scale(30, context), right: Utilities.scale(30, context), top: Utilities.vScale(13, context)),
//          itemCount: _hasMore? lenFetched+1 : lenFetched,
//          itemBuilder: (BuildContext context, int index) {
//            if(index >= allUsers.length){
//              if(!_isLoading){
//                _loadMore();
//              }
//              return Center(
//                child: SizedBox(
//                  child: CircularProgressIndicator(),
//                  height: 24,
//                  width: 24,
//                ),
//              );
//            }
//            return Padding(
//                padding: EdgeInsets.only(top: Utilities.vScale(15, context)),
//                child: userTile(allUsers[index])
//            );
//          }
//      ),
//    );
  }
}