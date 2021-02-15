import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:induction/Utilities.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'ColorCodes.dart';
import 'Gallery.dart';
import 'package:share/share.dart';

class GalleryState extends State<Gallery> {
  String caption;
  String key;
  int likeCount;
  bool liked = false;
  int imIndex;
  List<dynamic> galleryItems;
  FirebaseDatabase galleryDB;
  DatabaseReference galleryDBRef;
  DataSnapshot galleryItemsSnapshot;
  String galleryText='';

  @override
  void initState(){
    galleryDB = FirebaseDatabase(databaseURL: DotEnv().env['DB_URL']);
    galleryDBRef = galleryDB.reference().child("Home").child("gallery");
    getGalleryItemsFromDB();
    super.initState();
  }

  void getGalleryItemsFromDB() async {
    setState(() {
      galleryText = "Please wait ...";
    });
    DataSnapshot galleryItemsTempSnapshot = await galleryDBRef.once();
    if(mounted){
      setState(() {
        galleryItemsSnapshot = galleryItemsTempSnapshot;
      });
    }
    getGalleryItemsFromSnapshot();
    setState(() {
      galleryText = "No items to view yet. Come back soon!";
    });
  }

  void getGalleryItemsFromSnapshot(){
    if(galleryItemsSnapshot==null || galleryItemsSnapshot.value == null || galleryItemsSnapshot.value.length==0){
      setState(() {
        galleryItems = null;
      });
    }
    else{
      setState(() {
        galleryItems = galleryItemsSnapshot.value.values.toList();
        dynamic galleryItemsKeys = galleryItemsSnapshot.value.keys.toList();
        for(int i = 0; i<galleryItems.length; i++){
          galleryItems[i]['key'] = galleryItemsKeys[i];
        }
        galleryItems.sort((a,b) => Utilities.compareTime(a,b));
        if(galleryItems.length!=0){
          imIndex = 0;
          caption = galleryItems[0]['caption'];
          key = galleryItems[0]['key'];
          if(galleryItems[0]['Likes']!=null){
            likeCount = galleryItems[0]['Likes'].length;
            liked = galleryItems[0]['Likes'][widget.user.uid];
          }
          else{
            likeCount = 0;
            liked = false;
          }
          if(liked == null) {
            liked = false;
          }
        }
      });
    }
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: (galleryItems==null || galleryItems.length==0)?MaterialColor(0xff262833, darkSeaGreenColorCodes):Colors.black,
      body: (galleryItems==null || galleryItems.length==0)?
          Center(
            child: SizedBox(
              height: Utilities.vScale(MediaQuery.of(context).size.height/3, context),
              width: Utilities.scale(2*MediaQuery.of(context).size.width/3, context),
              child: Center(
                child: Text(
                  galleryText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Utilities.vScale(25, context),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
          : Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: Utilities.vScale(MediaQuery.of(context).padding.top, context))),
          SizedBox(
//              width: Utilities.scale(MediaQuery.of(context).size.width, context),
            height: Utilities.vScale(MediaQuery.of(context).size.height*4.5/6, context),
            child: PhotoViewGallery.builder(
              builder: (BuildContext context, int index){
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(galleryItems[index]['url']),
                  minScale: PhotoViewComputedScale.contained
                );
              },
              itemCount: galleryItems.length,
              scrollDirection: Axis.vertical,
              pageController: pageController,
              onPageChanged: (index){
                setState(() {
                  imIndex = index;
                  key = galleryItems[index]['key'];
                  caption = galleryItems[index]['caption'];
                  if(galleryItems[index]['Likes']!=null){
                    likeCount = 0;
                    liked = galleryItems[index]['Likes'][widget.user.uid];
                    for(int i=0; i<galleryItems[index]['Likes'].values.toList().length; i++){
                      if(galleryItems[index]['Likes'].values.toList()[i] == true){
                        likeCount+=1;
                      }
                    }
                  }
                  else{
                    liked = false;
                  }
                  if(liked == null){
                    liked = false;
                  }
                });
              },
            ),
          ),
          Padding(padding: EdgeInsets.only(top: Utilities.vScale(MediaQuery.of(context).padding.top*0.5, context))),
          SizedBox(
            height: Utilities.vScale(MediaQuery.of(context).size.height*1.3/6 - MediaQuery.of(context).padding.top*2, context),
            width: MediaQuery.of(context).size.width,
            child:DecoratedBox(    //Add user name.
              decoration: BoxDecoration(
                color:  MaterialColor(0xff501f3a, darkMagentaColorCodes),
              ),
              child:  SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: <Widget>[
//                        Padding(padding: EdgeInsets.only(top: Utilities.vScale(MediaQuery.of(context).padding.top*0.5, context))),
                        Container(
                          margin: EdgeInsets.only(top: Utilities.vScale(MediaQuery.of(context).padding.top*0.5, context), left: Utilities.vScale(MediaQuery.of(context).padding.top*0.5, context), right: Utilities.vScale(MediaQuery.of(context).padding.top*0.5, context)),
                          child: Text(
                            (caption==null)?'':caption,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Utilities.vScale(20, context),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: Utilities.vScale(MediaQuery.of(context).padding.top*0.1, context), left: Utilities.vScale(MediaQuery.of(context).padding.top*0.5, context), right: Utilities.vScale(MediaQuery.of(context).padding.top*0.5, context)),
                          child: Text(
                            "$likeCount ${(likeCount == 1)?"person likes":"people like"} this.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Utilities.vScale(15, context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
//                        Padding(padding: EdgeInsets.only(top: Utilities.vScale(MediaQuery.of(context).padding.top*0.5, context))),
                        SizedBox(
                            width: Utilities.scale(320,context),
                            height: Utilities.vScale(MediaQuery.of(context).size.height,context)/12,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: Utilities.scale(154,context),
                                  height: Utilities.vScale(MediaQuery.of(context).size.height,context)/20,
                                  child: FlatButton(
                                    onPressed: () {
                                      galleryDBRef.child(key).child('Likes/${widget.user.uid}').set(!liked);
                                      setState(() {
                                        galleryItems[imIndex]['Likes'][widget.user.uid] = !liked;
                                        liked = !liked;
                                        if(liked == true){
                                          likeCount += 1;
                                        }
                                        else{
                                          likeCount -= 1;
                                        }
                                      });
                                    },
                                    child: Icon(
                                      (liked)?Icons.favorite:Icons.favorite_border,
                                      color: (liked)?Colors.red:Colors.white,
                                      size: 30.0,
                                      semanticLabel: 'Text to announce in accessibility modes',
                                    ),
                                    color: MaterialColor(0xFF14a098, seaGreenColorCodes),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(Utilities.scale(25.0,context))
                                    ),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(left: Utilities.scale(12, context))),
                                SizedBox(
                                  width: Utilities.scale(154,context),
                                  height: Utilities.vScale(MediaQuery.of(context).size.height,context)/20,
                                  child: FlatButton(
                                    onPressed: () {
                                      Share.share("Have a look at this picture from IIIT Delhi's Induction 2020: ${galleryItems[imIndex]['url']}");
                                    },
                                    child: Icon(
                                      Icons.share,
                                      color: Colors.white,
                                      size: 30.0,
                                      semanticLabel: 'Text to announce in accessibility modes',
                                    ),
                                    color: MaterialColor(0xFF114546, darkSeaGreenColorCodes),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(Utilities.scale(25.0,context))
                                    ),
                                  ),
                                ),
                              ],
                            )
                        )
                      ],
                    ),
                  )
              ),
            ),
          ),
//          Padding(padding: EdgeInsets.only(top: Utilities.vScale(MediaQuery.of(context).padding.top, context))),
        ],
      ),
    );
//    return Container(
//      child: PhotoViewGallery(
//        pageOptions: <PhotoViewGalleryPageOptions>[
//          PhotoViewGalleryPageOptions(
//              imageProvider: AssetImage("assets/images/def_user.png"),
//              heroAttributes: const PhotoViewHeroAttributes(tag: "tag1"),
//              minScale: PhotoViewComputedScale.contained
//          ),
//          PhotoViewGalleryPageOptions(
//              imageProvider: AssetImage("assets/images/background.png"),
//              heroAttributes: const PhotoViewHeroAttributes(tag: "tag2"),
//              minScale: PhotoViewComputedScale.contained
//          ),
//          PhotoViewGalleryPageOptions(
//              imageProvider: AssetImage("assets/images/logoFullNoShadow.png"),
//              heroAttributes: const PhotoViewHeroAttributes(tag: "tag3"),
//              minScale: PhotoViewComputedScale.contained
//          ),
//        ],
////        loadingBuilder: (context, progress) => Center(
////          child: Container(
////            width: 20.0,
////            height: 20.0,
////            child: CircularProgressIndicator(
////              value: _progress == null
////                  ? null
////                  : _progress.cumulativeBytesLoaded /
////                  _progress.expectedTotalBytes,
////            ),
////          ),
////        ),
////        backgroundDecoration: widget.backgroundDecoration,
//        pageController: pageController,
////        onPageChanged: onPageChanged,
//      )
//    );
  }
}