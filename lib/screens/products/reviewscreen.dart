

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:provider/provider.dart';
import 'package:repyol/helpers/data.dart';
import 'package:repyol/models/product.dart';
import 'package:repyol/providers/authprovider.dart';
import 'package:repyol/providers/productsprovider.dart';
import 'package:repyol/screens/auth/signinscreen.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReviewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    //appBar: AppBar(title: const Text("Keyboard Attachable demo")),
    body: FooterLayout(
      footer: KeyboardAttachableFooter(),
      child: ReviewsList(),
    ),
  );
}

class KeyboardAttachableFooter extends StatefulWidget {
  @override
  _KeyboardAttachableFooterState createState() => _KeyboardAttachableFooterState();
}

class _KeyboardAttachableFooterState extends State<KeyboardAttachableFooter> {
  GlobalKey<FlutterMentionsState> key = GlobalKey<FlutterMentionsState>();
  double rating = 0.0;
  bool _showList = false;
  List<Map<String, dynamic>> _users = List<Map<String, dynamic>>();

  @override
  void initState() {
    print(key.currentState?.controller?.markupText);
    key.currentState?.controller?.addListener(() {
      print(key.currentState?.controller?.text);
    });


    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => initData());
  }

  initData() async {
    Provider.of<ProductsProvider>(context, listen: false).populateReviewUsers();

    Timer(Duration(seconds: 3), () {
      _users.clear();
      setState(() {
        Provider.of<ProductsProvider>(context, listen: false).reviewUsers.forEach((user) {
          Map<String, dynamic> map1 = {};//user.toMap();
          map1["id"] = user.name;
          map1["display"] = user.name;
          map1["image"] = user.image;
          print(map1);
          _users.add(map1);
        });
        print(_users);
      });
    });
  }

  TextEditingController reviewController = new TextEditingController();

  Widget reviewField(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ]
        ),
        child: TextField(
          controller: reviewController,
          style: TextStyle(fontSize: 12, color: Colors.black),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
            //filled: true,
            //fillColor: Colors.grey.withAlpha(50),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              borderSide: BorderSide.none,
            ),

            hintText: 'Write your review',
            hintStyle: TextStyle(fontSize: 12, color: Colors.black),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(5.0),
              child: CachedNetworkImage(
                imageUrl: "${Provider.of<AuthProvider>(context, listen: false)?.user?.image != null ? Provider.of<AuthProvider>(context, listen: false)?.user?.image : "https://firebasestorage.googleapis.com/v0/b/talkabout-bf655.appspot.com/o/avatar%2Fman.jpg?alt=media"}",
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Container(
                  height: 25,
                  width: 25,
                  child: Image.network('https://firebasestorage.googleapis.com/v0/b/talkabout-bf655.appspot.com/o/avatar%2Fman.jpg?alt=media'),
                ),
                imageBuilder: (context, imageProvider) => Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        colorFilter:
                        ColorFilter.mode(Colors.amber, BlendMode.colorBurn)
                    ),
                  ),
                ),
              ),
            ),

          ),
        ),
      ),
    );
  }

  Widget bottomContainer(BuildContext context){
    var arr = <Map<String, dynamic>>[];
    return Container(
      width: double.infinity,
      //height: 200,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [


            //reviewField(context),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ]
                ),
                child: FlutterMentions(
                  textInputAction: TextInputAction.done,

                  key: key,
                  style: TextStyle(fontSize: 12, color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 20.0),
                    //filled: true,
                    //fillColor: Colors.grey.withAlpha(50),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide.none,
                    ),

                    hintText: 'Write your review',
                    hintStyle: TextStyle(fontSize: 12, color: Colors.black),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CachedNetworkImage(
                        imageUrl: "${Provider.of<AuthProvider>(context, listen: false)?.user?.image != null ? Provider.of<AuthProvider>(context, listen: false)?.user?.image : "https://firebasestorage.googleapis.com/v0/b/talkabout-bf655.appspot.com/o/avatar%2Fman.jpg?alt=media"}",
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Container(
                          height: 25,
                          width: 25,
                          child: Image.network('https://firebasestorage.googleapis.com/v0/b/talkabout-bf655.appspot.com/o/avatar%2Fman.jpg?alt=media'),
                        ),
                        imageBuilder: (context, imageProvider) => Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                                colorFilter:
                                ColorFilter.mode(Colors.amber, BlendMode.colorBurn)
                            ),
                          ),
                        ),
                      ),
                    ),

                  ),
                  suggestionListHeight: Get.height * 0.5,
                  suggestionPosition: SuggestionPosition.Top,
                  onMarkupChanged: (val) {
                    print("is this here: ${val}");
                    print(val);
                  },
                  onSuggestionVisibleChanged: (val) {
                    setState(() {
                      _showList = val;
                    });
                  },
                  onSearchChanged: (
                      trigger,
                      value,
                      ) {
                    print('again | $trigger | $value ');
                  },
                  hideSuggestionList: false,
                  onEditingComplete: () {
                    //key.currentState.controller.clear();
                    // key.currentState.controller.text = '';
                  },
                  //maxLines: 3,
                  //minLines: 1,
                  mentions: [
                    Mention(
                        trigger: r'@',
                        style: TextStyle(
                          color: Colors.amber,
                        ),
                        matchAll: false,

                        data: _users,
                        suggestionBuilder: (data) {
                          print("SOMETHINGGGGGGGGG");
                            //print(data);
                          return Container(

                            decoration: BoxDecoration(
                              color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: Offset(0, 1), // changes position of shadow
                                  ),
                                ]
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                    backgroundImage: NetworkImage(
                                    data['image'] ?? "https://firebasestorage.googleapis.com/v0/b/talkabout-bf655.appspot.com/o/avatar%2Fman.jpg?alt=media",
                                    ),
                                    ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                Column(
                                  children: <Widget>[
                                    Text(data['display']),
                                    //ext('@${data['user']}'),
                                  ],
                                )
                              ],
                            ),
                          );
                        }
                        ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15, top:5, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SmoothStarRating(
                      allowHalfRating: true,
                      onRated: (double v) {
                        setState(() {
                          rating = v;
                        });
                      },

                      starCount: 5,
                      rating: rating,
                      size: 30.0,
                      isReadOnly:false,
                      filledIconData: Icons.star,
                      halfFilledIconData: Icons.star_border_outlined,
                      color: mainColor3,
                      borderColor: mainColor3,
                      spacing:1.0
                  ),

                  SizedBox(
                    width: Get.width * 0.25,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      onPressed: (){
                        //Get.back();
                        Provider.of<ProductsProvider>(context, listen: false).createReview(key.currentState.controller.text, rating, Provider.of<AuthProvider>(context, listen: false).user.ref, Provider.of<ProductsProvider>(context, listen: false).selectProduct.ref);
                        setState(() {
                          rating = 0.0;
                          reviewController.clear();
                        });
                      },
                      color: mainColor3,
                      child: Text("Talk", style: TextStyle(color: Colors.white, fontSize: 12),),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget continueBtn(){
    return SizedBox(
      width: double.infinity,
      height: Get.height * 0.12,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () async{

            Get.to(SignInScreen());
          },
          color: mainColor3,
          child: Text('Create account to continue', style: TextStyle(color: Colors.white, fontSize: 14),),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => KeyboardAttachable(
      backgroundColor: Colors.blue,
      child: Provider.of<AuthProvider>(context, listen: false).user == null ? continueBtn() : bottomContainer(context)
  );
}

class ReviewsList extends StatefulWidget {
  @override
  _ReviewsListState createState() => _ReviewsListState();
}

class _ReviewsListState extends State<ReviewsList> {

  Widget reviewContainer(Reviews review){
    var inSeconds = Jiffy(DateTime.now()).diff(review.createdAt, Units.SECOND);
    var inMinutes = Jiffy(DateTime.now()).diff(review.createdAt, Units.MINUTE);
    var inHours = Jiffy(DateTime.now()).diff(review.createdAt, Units.HOUR);
    var inWeeks = Jiffy(DateTime.now()).diff(review.createdAt, Units.WEEK);
    var inDays = Jiffy(DateTime.now()).diff(review.createdAt, Units.DAY);
    var inMonths = Jiffy(DateTime.now()).diff(review.createdAt, Units.MONTH);
    var inYears = Jiffy(DateTime.now()).diff(review.createdAt, Units.YEAR);

    var elapsed = inSeconds;
    String end = "second(s)";

    if(inSeconds < 30){
      elapsed = inSeconds;
      end = "second(s)";
    }else if(inSeconds > 60 && inSeconds < 3600){

      elapsed = inMinutes;
      end = "min(s)";
    }else if(inMinutes > 60 && inMinutes < 3600){
      elapsed = inHours;
      end = "hour(s)";
    }else if(inHours > 24){
      elapsed = inDays;
      end = "day(s)";
    }else if(inDays > 7){
      elapsed = inWeeks;
      end = "week(s)";
    }else if(inWeeks > 4){
      elapsed = inMonths;
      end = "month(s)";
    }else if(inMonths > 12){
      elapsed = inYears;
      end = "year(s)";
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircularProfileAvatar(
              '', //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
              radius: 20, // sets radius, default 50.0
              backgroundColor: Colors.transparent, // sets background color, default Colors.white
              borderWidth: 2,  // sets border, default 0.0
              initialsText: Text(
                "JO",
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),  // sets initials text, set your own style, default Text('')
              borderColor: mainColor8, // sets border color, default Colors.white
              elevation: 5.0, // sets elevation (shadow of the profile picture), default value is 0.0
              foregroundColor: Colors.brown.withOpacity(0.5), //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
              cacheImage: true, // allow widget to cache image against provided url
              onTap: () {
                print('adil');
              }, // sets on tap
              showInitialTextAbovePicture: true, // setting it true will show initials text above profile picture, default false
              child: CachedNetworkImage(
                imageUrl: '${review?.user?.image != null ? review?.user?.image : "https://pixabay.com/get/57e5d3464256b10ff3d89960c62e3779103fdced5b53_640.png"}',
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.amber,),
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review?.user?.name ?? "", style: TextStyle(color: mainColor8, fontSize: 12, fontFamily: 'PoppinsSemiBold'),),
                    SizedBox(height: 10,),
                    Text(review?.content.capitalize ?? "", style: TextStyle(color: Colors.black, fontSize: 12,),),
                    Row(
                      children: [
                        Text('${elapsed} ${end}', style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'PoppinsSemiBold'),),
                        SizedBox(width: 15,),
                        Text('Edit', style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'PoppinsSemiBold'),),
                      ],
                    )
                  ],
                )
            )
          ],
        ),
      ),
    );
  }

  Widget topReviews(){
    return SizedBox(
      width: Get.width,
      height: Get.height ,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: Provider.of<ProductsProvider>(context, listen: true).allReviews.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int i){
            return reviewContainer(Provider.of<ProductsProvider>(context, listen: false).allReviews[i]);
          }
      ),
    );
  }

  @override
  Widget build(BuildContext context) => topReviews();
}