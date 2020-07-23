import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:induction/Utilities.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'ColorCodes.dart';
import 'Gallery.dart';

class GalleryState extends State<Gallery> {
  String caption;
  List<dynamic> galleryItems;
  FirebaseDatabase galleryDB;
  DatabaseReference galleryDBRef;
  DataSnapshot galleryItemsSnapshot;

  @override
  void initState(){
    galleryDB = FirebaseDatabase(databaseURL: DotEnv().env['DB_URL']);
    galleryDBRef = galleryDB.reference().child("Home").child("gallery");
    getGalleryItemsFromDB();
    super.initState();
  }

  void getGalleryItemsFromDB() async {
    DataSnapshot galleryItemsTempSnapshot = await galleryDBRef.once();
    if(mounted){
      setState(() {
        galleryItemsSnapshot = galleryItemsTempSnapshot;
      });
    }
    getGalleryItemsFromSnapshot();
  }

  void getGalleryItemsFromSnapshot(){
    if(galleryItemsSnapshot.value == null || galleryItemsSnapshot.value.length==0){
      setState(() {
        galleryItems = null;
      });
    }
    else{
      setState(() {
        galleryItems = galleryItemsSnapshot.value.values.toList();
        if(galleryItems.length!=0){
          caption = galleryItems[0]['caption'];
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
                  "No items to view yet. Come back soon!",
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
                  caption = galleryItems[index]['caption'];
                });
              },
            ),
          ),
          Padding(padding: EdgeInsets.only(top: Utilities.vScale(MediaQuery.of(context).padding.top*0.5, context))),
          SizedBox(
            height: Utilities.vScale(MediaQuery.of(context).size.height*1.3/6 - MediaQuery.of(context).padding.top*3, context),
            child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        (caption==null)?"":caption,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Utilities.vScale(20, context)
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ),
          Padding(padding: EdgeInsets.only(top: Utilities.vScale(MediaQuery.of(context).padding.top, context))),
        ],
      ),
    );
    return Container(
      child: PhotoViewGallery(
        pageOptions: <PhotoViewGalleryPageOptions>[
          PhotoViewGalleryPageOptions(
              imageProvider: AssetImage("assets/images/def_user.png"),
              heroAttributes: const PhotoViewHeroAttributes(tag: "tag1"),
              minScale: PhotoViewComputedScale.contained
          ),
          PhotoViewGalleryPageOptions(
              imageProvider: AssetImage("assets/images/background.png"),
              heroAttributes: const PhotoViewHeroAttributes(tag: "tag2"),
              minScale: PhotoViewComputedScale.contained
          ),
          PhotoViewGalleryPageOptions(
              imageProvider: AssetImage("assets/images/logoFullNoShadow.png"),
              heroAttributes: const PhotoViewHeroAttributes(tag: "tag3"),
              minScale: PhotoViewComputedScale.contained
          ),
        ],
//        loadingBuilder: (context, progress) => Center(
//          child: Container(
//            width: 20.0,
//            height: 20.0,
//            child: CircularProgressIndicator(
//              value: _progress == null
//                  ? null
//                  : _progress.cumulativeBytesLoaded /
//                  _progress.expectedTotalBytes,
//            ),
//          ),
//        ),
//        backgroundDecoration: widget.backgroundDecoration,
        pageController: pageController,
//        onPageChanged: onPageChanged,
      )
    );
  }
}