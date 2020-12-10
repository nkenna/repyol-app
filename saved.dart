import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:repyol/helpers/data.dart';
import 'package:repyol/models/category.dart';
import 'package:repyol/models/createfavoriteproduct.dart';
import 'package:repyol/models/product.dart';
import 'package:repyol/providers/authprovider.dart';
import 'package:repyol/providers/productsprovider.dart';
import 'package:repyol/screens/auth/signupscreen.dart';
import 'package:repyol/screens/products/productcategorylistscreen.dart';
import 'package:repyol/screens/products/productviewdetailscreen.dart';
import 'package:repyol/screens/profile/profilescreen.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {

  @override
  initState(){
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => initData());
  }

  initData() async{
    await Provider.of<AuthProvider>(context, listen: false).retrieveUser().then((value) {
      Provider.of<ProductsProvider>(context, listen: false).getAllFavProductsByUser(Provider.of<AuthProvider>(context, listen: false).user.ref ?? "");
      Provider.of<AuthProvider>(context, listen: false).userProfileLanding(Provider.of<AuthProvider>(context, listen: false)?.user?.ref ?? "" , Provider.of<AuthProvider>(context, listen: false)?.user?.email ?? "");
    });
    Provider.of<ProductsProvider>(context, listen: false).getAllProducts();
    Provider.of<ProductsProvider>(context, listen: false).getAllCategories();
    //Provider.of<ProductsProvider>(context, listen: false).getAllFavProductsByUser(Provider.of<AuthProvider>(context, listen: false).user.ref);

  }

  Widget topHeader(){
    return Container(
      width: Get.width,
      height: Get.height * 0.08,
      //color: Colors.amber,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
                text: TextSpan(
                    text: "Hey, ",
                    style: TextStyle(fontSize: 14, fontFamily: 'PoppinsRegular', color:  mainColor8),
                    children: [
                      TextSpan(
                        text: "${Provider.of<AuthProvider>(context, listen: true)?.user?.name?.capitalize ?? "Stranger"}",
                        style: TextStyle(fontSize: 14, fontFamily: 'PoppinsSemiBold', color:  mainColor8),
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
                Get.to(ProfileScreen());
              }, // sets on tap
              showInitialTextAbovePicture: true, // setting it true will show initials text above profile picture, default false
              child: CachedNetworkImage(
                imageUrl: '${Provider.of<AuthProvider>(context, listen: false).user != null ? Provider.of<AuthProvider>(context, listen: false)?.user?.image : 'https://avatars0.githubusercontent.com/u/8264639?s=460&v=4'}',
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error, color: mainColor3,),
              ),
            )


          ],
        ),
      ),
    );
  }

  Widget SearchField(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: TextField(
        style: TextStyle(fontSize: 12, color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.withAlpha(50),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide.none,
          ),
          hintText: 'Search here',
          hintStyle: TextStyle(fontSize: 12, color: Colors.black),
          prefixIcon: Icon(Icons.search,color: Colors.black,),
          //suffixIcon: Icon(Icons.send_sharp, color: Colors.amber,)
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
                imageUrl: "${product.images.isNotEmpty ? product.images[0] : ''}",
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                imageBuilder: (context, imageProvider) => Container(
                  width: double.infinity,
                  height: Get.height * 0.17,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          colorFilter:
                          ColorFilter.mode(Colors.amber, BlendMode.colorBurn)
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
    return Provider.of<ProductsProvider>(context, listen: true).allProducts.isNotEmpty ? SizedBox(
      width: Get.width,
      height: Get.height * 0.3,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: Provider.of<ProductsProvider>(context, listen: true).allProducts.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int i){
            return newProductContainer(Provider.of<ProductsProvider>(context, listen: true).allProducts[i]);
          }
      ),
    ) : Container();
  }

  Widget popularProductContainer(Product product) {
    bool check = false;
    Provider.of<ProductsProvider>(context, listen: true).checkFavorite(product, Provider.of<ProductsProvider>(context, listen: true).allProducts).then((value) => check = value);
    print(check);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: Get.height * 0.15,
        width: Get.width * 0.35,
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
                imageUrl: "${product.images.isNotEmpty ? product.images[0] : ''}",
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                imageBuilder: (context, imageProvider) => Container(
                  width: Get.width * 0.3,
                  //height: Get.height * 0.17,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          colorFilter:
                          ColorFilter.mode(Colors.amber, BlendMode.colorBurn)
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
                        Text(product?.name?.capitalize ?? "", overflow: TextOverflow.ellipsis, style: TextStyle(color: mainColor8, fontSize: 12, fontFamily: 'PoppinsSemiBold'),),
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
      height: Get.height *0.75,
      child:  ListView.builder(
        //scrollDirection: Axis.horizontal,
          itemCount: Provider.of<ProductsProvider>(context, listen: true).allProducts.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int i){
            return popularProductContainer(Provider.of<ProductsProvider>(context, listen: true).allProducts[i]);
          }
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
          itemCount: Provider.of<ProductsProvider>(context, listen: true).allPromotedProducts.length,
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
              child: Text('Product Categories', style: TextStyle(color:  mainColor8, fontFamily: 'PoppinsBold', fontSize: 18),),
            ),
            productCategories(),
            promotedProducts(),
            Provider.of<ProductsProvider>(context, listen: true).allFavProducts.isNotEmpty ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Text('Favourite Products', style: TextStyle(color:  mainColor8, fontFamily: 'PoppinsBold', fontSize: 18),),
            ) : Container(),
            favProducts(),
            newProducts(),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Text('Popular Products', style: TextStyle(color:  mainColor8, fontFamily: 'PoppinsBold', fontSize: 18),),
            ),
            popularProducts()
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

          Provider.of<AuthProvider>(context, listen: false).user == null ? ListTile(
            leading: Icon(Icons.lock, color: mainColor3,),
            title: Text('Change Password', style: TextStyle(color: mainColor3, fontSize: 12),),
            onTap: (){},
          ) : Container(),

          ListTile(
            leading: Icon(Icons.ad_units_rounded, color: mainColor3,),
            title: Text('Create Product', style: TextStyle(color: mainColor3, fontSize: 12),),
            onTap: (){},
          ),

          ListTile(
            leading: Icon(Icons.support_agent_sharp, color: mainColor3,),
            title: Text('Support', style: TextStyle(color: mainColor3, fontSize: 12),),
            onTap: (){},
          ),

          ListTile(
            leading: Icon(Icons.book_sharp, color: mainColor3,),
            title: Text('Privacy Policy & Terms of use', style: TextStyle(color: mainColor3, fontSize: 12),),
            onTap: (){},
          ),



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
                child: Text('v1.0.0', style: TextStyle(color: mainColor3, fontSize: 14, fontFamily: 'PoppinsBold'),)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
