import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:repyol/helpers/controlloader.dart';

import 'package:repyol/helpers/data.dart';
import 'package:repyol/models/category.dart';
import 'package:repyol/models/createfavoriteproduct.dart';
import 'package:repyol/models/product.dart';
import 'package:repyol/providers/authprovider.dart';
import 'package:repyol/providers/productsprovider.dart';
import 'package:repyol/screens/auth/signinscreen.dart';
import 'package:repyol/screens/auth/signupscreen.dart';
import 'package:repyol/screens/products/allproductsscreen.dart';
import 'package:repyol/screens/products/productcategorylistscreen.dart';
import 'package:repyol/screens/products/productviewdetailscreen.dart';
import 'package:repyol/screens/profile/profilescreen.dart';
import 'package:repyol/screens/searchscreen.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  initState(){
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => initData());
  }



  initData() async{
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
    await Provider.of<AuthProvider>(context, listen: false).retrieveUser().then((value) {
      Provider.of<ProductsProvider>(context, listen: false).getAllFavProductsByUser(Provider.of<AuthProvider>(context, listen: false)?.user?.ref ?? "");
      Provider.of<AuthProvider>(context, listen: false).userProfileLanding(Provider.of<AuthProvider>(context, listen: false)?.user?.ref ?? "" , Provider.of<AuthProvider>(context, listen: false)?.user?.email ?? "");
    });
    Provider.of<ProductsProvider>(context, listen: false).getAllProducts();
    Provider.of<ProductsProvider>(context, listen: false).getAllCategories();
    Provider.of<ProductsProvider>(context, listen: false).getNewProducts();
    //Provider.of<ProductsProvider>(context, listen: false).getAllFavProductsByUser(Provider.of<AuthProvider>(context, listen: false).user.ref);

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      //assert(token != null);
      print(token);
      if(token != null && token.isNotEmpty){
        Provider.of<AuthProvider>(context, listen: false).addToken(token, Provider.of<AuthProvider>(context, listen: false)?.user?.ref ?? "", Platform.isIOS ? "ios" : "android");
      }
    });

  }

  Widget topHeader(){
    return SizedBox(
      height: Get.height * 0.2,
      width: Get.width,

      child: Container(
        //color: Colors.red,
        child: Stack(
          children: [
              Container(
                  width: Get.width,
                  height: Get.height * 0.16,
                  //color: Colors.amber,
                  decoration: BoxDecoration(
                      color: mainColor3,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32))
                  ),

        ),

              Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                      text: TextSpan(
                          text: "Hey, ",
                          style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular', color:  Colors.white),
                          children: [
                            TextSpan(
                              text: "${Provider.of<AuthProvider>(context, listen: true)?.user?.name?.capitalize ?? "Stranger"}",
                              style: TextStyle(fontSize: 14, fontFamily: 'PoppinsSemiBold', color:  Colors.white),
                            )
                          ]
                      )
                  ),

                  CircularProfileAvatar(
                    '', //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
                    radius: 20, // sets radius, default 50.0
                    backgroundColor: Colors.transparent, // sets background color, default Colors.white
                    borderWidth: 2,  // sets border, default 0.0
                    //initialsText: Text("${authController.user != null ? authController.user.value.name.substring(0, 2) : ""}", //Obx(() => Text("${controller.name}"))//,
                    // style: TextStyle(fontSize: 10, color: Colors.white),
                    // ),  // sets initials text, set your own style, default Text('')
                    borderColor: mainColor8, // sets border color, default Colors.white
                    elevation: 5.0, // sets elevation (shadow of the profile picture), default value is 0.0
                    foregroundColor: Colors.brown.withOpacity(0.5), //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
                    cacheImage: true, // allow widget to cache image against provided url
                    onTap: () {
                      print('adil');
                      if(Provider.of<AuthProvider>(context, listen: false).user != null){
                        Get.to(ProfileScreen());
                      }else{
                        showErrorLoader("You need to create an account to continue.");
                        Get.to(SignInScreen());
                      }

                    }, // sets on tap
                    showInitialTextAbovePicture: true, // setting it true will show initials text above profile picture, default false
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: '${Provider.of<AuthProvider>(context, listen: false).user != null ? Provider.of<AuthProvider>(context, listen: false)?.user?.image : 'https://firebasestorage.googleapis.com/v0/b/talkabout-bf655.appspot.com/o/avatar%2Fman.jpg?alt=media'}',
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error, color: mainColor3,),
                    ),
                  )


                ],
              ),
            ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: searchField()
            )
          ],
        ),
      ),
    );
  }

  Widget searchField(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: InkWell (
        onTap: (){
          Get.to(SearchScreen());
        },
        child: Container(
          height: Get.height * 0.08,
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Search here", style: TextStyle(fontSize: 12, color: Colors.black),),
                Icon(Icons.search_sharp, color: mainColor3,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget favProducts(){
    return Provider.of<ProductsProvider>(context, listen: true).allFavProducts.isNotEmpty ? SizedBox(
      width: Get.width,
      height: Get.height * 0.3,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: Provider.of<ProductsProvider>(context, listen: true).allFavProducts.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int i){
            return newProductContainer(Provider.of<ProductsProvider>(context, listen: true).allFavProducts[i]);
          }
      ),
    ) : Container();
  }

  Widget newProductContainer(Product product){

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        //height: 350,
        width: Get.width * 0.35,
        //color: Colors.blue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                Provider.of<ProductsProvider>(context, listen: false).setSelectedProduct(product);
                Get.to(ProductViewDetail());
              },
              child: CachedNetworkImage(
                imageUrl: "${
                    product.images.isNotEmpty 
                        ? product.images[0] != null ? product.images[0] : 'https://firebasestorage.googleapis.com/v0/b/talkabout-bf655.appspot.com/o/avatar%2Fapplogo.png?alt=media'  
                        : 'https://firebasestorage.googleapis.com/v0/b/talkabout-bf655.appspot.com/o/avatar%2Fapplogo.png?alt=media'
                }",
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Container(
                    width: double.infinity,
                    height: Get.height * 0.17,
                  child: Image.network('https://firebasestorage.googleapis.com/v0/b/talkabout-bf655.appspot.com/o/avatar%2Fapplogo.png?alt=media'),
                ),
                imageBuilder: (context, imageProvider) => Container(
                  width: double.infinity,
                  height: Get.height * 0.17,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          //colorFilter: ColorFilter.mode(mainColor3, BlendMode.difference)
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ]
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, top: 8),
              child: Text('${product?.name?.capitalize ?? ""}', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12),),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, top: 1),
              child: SmoothStarRating(
                  allowHalfRating: false,
                  onRated: (v) {
                  },
                  starCount: 5,
                  rating: Provider.of<ProductsProvider>(context, listen: true).calcAverageRating(product),
                  size: 15.0,
                  isReadOnly:true,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half_outlined,
                  color: mainColor3,
                  borderColor: mainColor3,
                  spacing:1.0
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, top: 1),
              child: Text('${product?.reviews?.length ?? 0} review(s)',overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, fontFamily: 'PoppinsSemiBold'),),
            ),
          ],
        ),
      ),
    );
  }

  Widget newProducts(){
    return Provider.of<ProductsProvider>(context, listen: true).allNewProducts.isNotEmpty ? SizedBox(
      width: Get.width,
      height: Get.height * 0.3,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: Provider.of<ProductsProvider>(context, listen: true).allNewProducts.length > 10 ? 10 : Provider.of<ProductsProvider>(context, listen: true).allNewProducts.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int i){
            return newProductContainer(Provider.of<ProductsProvider>(context, listen: true).allNewProducts[i]);
          }
      ),
    ) : Container();
  }

  Widget popularProductContainer(Product product) {
    bool check = false;
    Provider.of<ProductsProvider>(context, listen: true).checkFavorite(product, Provider.of<ProductsProvider>(context, listen: true).allFavProducts)
    .then((value) => check = value);
    //print(check);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: Get.height * 0.15,
        width: Get.width,
        //color: Colors.blue,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                Provider.of<ProductsProvider>(context, listen: false).setSelectedProduct(product);
                Get.to(ProductViewDetail());
              },
              child: CachedNetworkImage(
                imageUrl: "${product.images.isNotEmpty ? product.images[0] : 'https://firebasestorage.googleapis.com/v0/b/talkabout-bf655.appspot.com/o/avatar%2Fapplogo.png?alt=media'}",
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Container(
                  width: Get.width * 0.3,
                  //height: Get.height * 0.17,
                  child: Image.network('https://firebasestorage.googleapis.com/v0/b/talkabout-bf655.appspot.com/o/avatar%2Fapplogo.png?alt=media'),
                ),
                imageBuilder: (context, imageProvider) => Container(
                  width: Get.width * 0.3,
                  //height: Get.height * 0.17,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          //colorFilter:
                          //ColorFilter.mode(Colors.amber, BlendMode.colorBurn)
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ]
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8,right: 8, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(product?.name?.capitalize ?? "", overflow: TextOverflow.ellipsis, style: TextStyle(color: mainColor8, fontSize: 12, fontFamily: 'PoppinsSemiBold'),)),
                        InkWell(
                            onTap: (){

                              CreateFavoriteProduct cfp = new CreateFavoriteProduct(
                                  name: product?.name ?? "",
                                  ref: product?.ref ?? "",
                                  description: product?.description ?? "",
                                  //estimatedPrice: product.e
                                  images: product?.images,
                                  ownerRef: product.ownerRef ?? "",
                                  category: product?.category ?? "",
                                  favoriteOwnerRef: Provider.of<AuthProvider>(context,listen: false).user.ref ?? "",
                                  stores: product?.stores,
                                  verified: product.verified,
                                  status: product.status
                              );
                              Provider.of<ProductsProvider>(context,listen: false).createFavoriteProduct(cfp);
                            },
                            child:  Icon(check ? Icons.favorite : Icons.favorite_outline_sharp, color: Colors.green,)
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 1),
                    child: Text(product?.category?.toUpperCase() ?? "",overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12,),),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SmoothStarRating(
                            allowHalfRating: false,
                            onRated: (v) {
                            },
                            starCount: 5,
                            rating: Provider.of<ProductsProvider>(context, listen: true).calcAverageRating(product),
                            size: 15.0,
                            isReadOnly:true,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_half_outlined,
                            color: mainColor3,
                            borderColor: mainColor3,
                            spacing:1.0
                        ),
                        Text('${product?.reviews?.length} review(s)',overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12,),),
                      ],
                    ),
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget popularProducts(){

    return Provider.of<ProductsProvider>(context, listen: true).allProducts.isNotEmpty ? SizedBox(
      width: Get.width,

      child:  Column(
        children: List.generate(Provider.of<ProductsProvider>(context, listen: true).allProducts.length > 10 ? 10 : Provider.of<ProductsProvider>(context, listen: true).allProducts.length, (index) {
          return popularProductContainer(Provider.of<ProductsProvider>(context, listen: true).allProducts[index]);
        }),

      ),
    )  : Container();
  }

  Widget productCategoriesContainer(Category category){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => Get.to(ProductCategoryListScreen(category: category)),
        child: Container(
          //height: 350,
          width: Get.width * 0.23,
          //color: Colors.blue,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: Get.height * 0.06,
                decoration: BoxDecoration(
                    color: mainColor3,
                    borderRadius: BorderRadius.all(Radius.circular(10)),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ]
                ),
                child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(category?.name.toUpperCase() ?? "", overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontSize: 12, fontFamily: 'PoppinsSemiBold'),),
                    )
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget productCategories(){
    return SizedBox(
      width: Get.width,
      height: Get.height * 0.1,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: Provider.of<ProductsProvider>(context, listen: true).allCategories.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int i){
            return productCategoriesContainer( Provider.of<ProductsProvider>(context, listen: true).allCategories[i]);
          }
      ),
    );
  }

  Widget promotedProducts(){
    return Provider.of<ProductsProvider>(context, listen: true).allPromotedProducts.isNotEmpty ? SizedBox(
      width: Get.width,
      height: Get.height * 0.3,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: Provider.of<ProductsProvider>(context, listen: true).allPromotedProducts.length > 10 ? 10 : Provider.of<ProductsProvider>(context, listen: true).allPromotedProducts.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int i){
            return newProductContainer(Provider.of<ProductsProvider>(context, listen: true).allPromotedProducts[i]);
          }
      ),
    ) : Container();
  }

  Widget mainContainer(){
    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topHeader(),
            //SearchField(),
           Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Featured', style: TextStyle(color:  mainColor8, fontFamily: 'PoppinsBold', fontSize: 18),),
                  OutlineButton(
                    textColor: mainColor1,
                    highlightedBorderColor: mainColor1,
                    highlightColor: mainColor3,
                      highlightElevation: 5,
                      onPressed: (){
                        Get.to(AllProductsScreen(chosenProducts: Provider.of<ProductsProvider>(context, listen: false).allPromotedProducts,));
                      },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text("See More (${Provider.of<ProductsProvider>(context, listen: true).allPromotedProducts.length})", style: TextStyle(color:  mainColor8, fontSize: 12),),
                  )
                ],
              ),
            ),

            promotedProducts(),
            productCategories(),

            Provider.of<ProductsProvider>(context, listen: true).allNewProducts.length > 0 ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recently added', style: TextStyle(color:  mainColor8, fontFamily: 'PoppinsBold', fontSize: 18),),
                  OutlineButton(
                    textColor: mainColor1,
                    highlightedBorderColor: mainColor1,
                    highlightColor: mainColor3,
                    highlightElevation: 5,
                    onPressed: (){
                      Get.to(AllProductsScreen(chosenProducts: Provider.of<ProductsProvider>(context, listen: false).allNewProducts,));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text("See More (${Provider.of<ProductsProvider>(context, listen: true).allNewProducts.length})", style: TextStyle(color:  mainColor8, fontSize: 12),),
                  )
                ],
              ),
            ) : Container(),

            newProducts(),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Popular Products', style: TextStyle(color:  mainColor8, fontFamily: 'PoppinsBold', fontSize: 18),),
                  OutlineButton(
                    textColor: mainColor1,
                    highlightedBorderColor: mainColor1,
                    highlightColor: mainColor3,
                    highlightElevation: 5,
                    onPressed: (){
                      Get.to(AllProductsScreen(chosenProducts: Provider.of<ProductsProvider>(context, listen: false).allProducts,));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text("See More (${Provider.of<ProductsProvider>(context, listen: true).allProducts.length})", style: TextStyle(color:  mainColor8, fontSize: 12),),
                  )
                ],
              ),
            ),
            popularProducts(),

            Provider.of<ProductsProvider>(context, listen: true).allFavProducts.isNotEmpty ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Text('Your Favourite Products', style: TextStyle(color:  mainColor8, fontFamily: 'PoppinsBold', fontSize: 18),),
            ) : Container(),
            favProducts(),


          ],
        ),
      ),
    );
  }

  Widget drawerContainer(){
    return Container(
      height: Get.height,
      width: Get.width * 0.8,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20))
      ),
      child: Column(
        children: [

          SizedBox(height: 20,),

          Image.asset("assets/images/applogo.png", height: Get.height * 0.2 ,),

          Provider.of<AuthProvider>(context, listen: false).user == null ? ListTile(
            leading: Icon(Icons.person_add, color: mainColor3,),
            title: Text('Create Account', style: TextStyle(color: mainColor3, fontSize: 12),),
            onTap: (){
              Get.offAll(SignupScreen());
            },
          ) : Container(),

          Provider.of<AuthProvider>(context, listen: false).user != null ? ListTile(
            leading: Icon(Icons.lock, color: mainColor3,),
            title: Text('Change Password', style: TextStyle(color: mainColor3, fontSize: 12),),
            onTap: (){},
          ) : Container(),

          Provider.of<AuthProvider>(context, listen: false).user != null ? ListTile(
            leading: Icon(Icons.ad_units_rounded, color: mainColor3,),
            title: Text('Create Product', style: TextStyle(color: mainColor3, fontSize: 12),),
            onTap: (){},
          ) : Container(),

          /**ListTile(
            leading: Icon(Icons.support_agent_sharp, color: mainColor3,),
            title: Text('Support', style: TextStyle(color: mainColor3, fontSize: 12),),
            onTap: (){},
          ),**/

          /**ListTile(
            leading: Icon(Icons.book_sharp, color: mainColor3,),
            title: Text('Privacy Policy & Terms of use', style: TextStyle(color: mainColor3, fontSize: 12),),
            onTap: (){},
          ), **/



          ListTile(
            leading: Icon(Icons.exit_to_app_sharp, color: mainColor3,),
            title: Text('Log out', style: TextStyle(color: mainColor3, fontSize: 12),),
            onTap: (){
              Provider.of<AuthProvider>(context, listen: false).signOutUser();
            },
          ),

          Expanded(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Text('v${_packageInfo.version}', style: TextStyle(color: mainColor3, fontSize: 14, fontFamily: 'PoppinsBold'),)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              _scaffoldKey.currentState.openDrawer();
            },
            icon: Icon(Icons.sort, color: Colors.white,),
            color: mainColor3,
          ),
          elevation: 0,
        ),
        drawer: Drawer(
          child: drawerContainer(),
        ),
        drawerScrimColor: mainColor2.withOpacity(0.7),
        endDrawerEnableOpenDragGesture: true,
        drawerEdgeDragWidth: 20,
        backgroundColor: Colors.white,
        body: mainContainer(),
      ),
    );
  }
}
