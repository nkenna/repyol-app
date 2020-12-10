import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:repyol/helpers/data.dart';
import 'package:repyol/models/product.dart';
import 'package:repyol/providers/authprovider.dart';
import 'package:repyol/providers/productsprovider.dart';
import 'package:repyol/screens/addproduct/addproductcategoryscreen.dart';
import 'package:repyol/screens/landingscreen.dart';
import 'package:repyol/screens/products/productviewdetailscreen.dart';
import 'package:repyol/screens/profile/editprofilescreen.dart';
import 'package:repyol/screens/promotions/promotionpackagesscreen.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _profileScreenState createState() => _profileScreenState();
}

class _profileScreenState extends State<ProfileScreen> {



  @override
  initState(){
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => initData());

  }

  initData() async {
    Provider.of<AuthProvider>(context, listen: false).retrieveUser().then((value) {
      Provider.of<ProductsProvider>(context, listen: false).getAllProductsByUser(Provider.of<AuthProvider>(context, listen: false).user.ref);
      Provider.of<ProductsProvider>(context, listen: false).getAllProducts();
    });
  }

  Widget avatarContainer(){

    return SizedBox(
      width: 150,
      height: 120,
      child: Container(

        //color: Colors.red,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: CircularProfileAvatar(
                '', //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
                radius: 50, // sets radius, default 50.0
                backgroundColor: Colors.transparent, // sets background color, default Colors.white
                borderWidth: 2,  // sets border, default 0.0
                //initialsText: Text("${authController.user != null ? authController.user.value.name.substring(0, 2) : ""}", //Obx(() => Text("${controller.name}"))//,
                // style: TextStyle(fontSize: 10, color: Colors.white),
                // ),  // sets initials text, set your own style, default Text('')
                borderColor: mainColor8, // sets border color, default Colors.white
                elevation: 5.0, // sets elevation (shadow of the profile picture), default value is 0.0
                foregroundColor: Colors.amber.withOpacity(0.2), //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
                cacheImage: true, // allow widget to cache image against provided url
                onTap: () {
                  print('adil');
                  Get.to(ProfileScreen());
                }, // sets on tap
                showInitialTextAbovePicture: true, // setting it true will show initials text above profile picture, default false
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: '${Provider.of<AuthProvider>(context, listen: false)?.user?.image != null ? Provider.of<AuthProvider>(context, listen: false)?.user?.image : "https://pixabay.com/get/57e5d3464256b10ff3d89960c62e3779103fdced5b53_640.png"}',
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.amber,),
                ),
                /**child: Image.network(
                    Provider.of<AuthProvider>(context, listen: false)?.user?.image != null ? Provider.of<AuthProvider>(context, listen: false)?.user?.image : "https://avatars0.githubusercontent.com/u/8264639?s=460&v=4",
                    fit: BoxFit.cover,
                    ), **/
              ),
            ),


          ],
        ),
      ),
    );
  }

  Widget dataContainer(String title, String subTitle){
    print(Provider.of<AuthProvider>(context, listen: false)?.user?.image);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: mainColor4.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 5,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ]
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontFamily: 'PoppinsSemiBold', fontSize: 12),),
              Text(subTitle, style: TextStyle(fontSize: 12),),
            ],
          ),
        ),
      ),
    );
  }

  Widget btnContainer(Function callback, String text, Color color){
    return InkWell(
      onTap: callback,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
        child: Container(
            width: Get.width * 0.4,
            height: 50,
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: mainColor4.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ]
            ),
            child: Center(
              child: Text(text, style: TextStyle(fontSize: 12, color: Colors.white),),
            )
        ),
      ),
    );
  }

  Widget randomProducts(){
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

  Widget myProducts(){
    return Provider.of<ProductsProvider>(context, listen: true).allUserProducts.isNotEmpty ? SizedBox(
      width: Get.width,
      height: Get.height * 0.37,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: Provider.of<ProductsProvider>(context, listen: true).allUserProducts.length > 10 ? 10 : Provider.of<ProductsProvider>(context, listen: true).allUserProducts.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int i){
            return myProductContainer(Provider.of<ProductsProvider>(context, listen: true).allUserProducts[i]);
          }
      ),
    ) : Container();
  }

  Widget myProductContainer(Product product){

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

            /** Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: InkWell(
                onTap: (){
                  Provider.of<ProductsProvider>(context,listen: false).setSelectedProduct(product);
                  Get.to(PromotionPackagesScreen());
                },
                child: Container(
                  width: double.infinity,
                  height: Get.height * 0.05,
                  decoration: BoxDecoration(
                      color: product.promotiontrans.length > 0 ? mainColor3 : mainColor7,
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
                    child: Text("Promote", style: TextStyle(color: product.promotiontrans.length > 0 ? mainColor7 : mainColor3, fontSize: 12),),
                  ),
                ),
              ),
            ) **/

          ],
        ),
      ),
    );
  }

  Widget mainContainer(){
    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            avatarContainer(),
            dataContainer("Name", Provider.of<AuthProvider>(context, listen: false)?.user?.name?.capitalize ?? ""),
            dataContainer("Email", Provider.of<AuthProvider>(context, listen: false)?.user?.email ?? ""),
            dataContainer("Ref", Provider.of<AuthProvider>(context, listen: false)?.user?.ref ?? ""),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                btnContainer((){
                  Provider.of<ProductsProvider>(context,listen: false).setSelectedProduct(new Product());
                  Get.to(AddProductCategoryScreen(isUpdate: false,));
                }, "Create Product", mainColor3),

                btnContainer((){
                  Get.to(EditProfileScreen());
                }, "Edit Profile", Colors.amber),
              ],
            ),
            Provider.of<ProductsProvider>(context, listen: true).allUserProducts.isNotEmpty ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Text('My Products', style: TextStyle(color: mainColor8, fontFamily: 'PoppinsBold', fontSize: 18),),
            ) : Container(),
            myProducts(),
            Provider.of<ProductsProvider>(context, listen: true).allProducts.isNotEmpty ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Text('Products you might like', style: TextStyle(color: mainColor8, fontFamily: 'PoppinsBold', fontSize: 18),),
            ) : Container(),
            randomProducts()
          ],
        ),
      ),

    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () => Get.offAll(LandingScreen()),
              child: Icon(Icons.arrow_back_ios, size: 18, color: Colors.black,)),
          title: Text('My Profile', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'PoppinsSemiBold')),
          backgroundColor: Colors.white,
          centerTitle: true,

        ),
        backgroundColor: Colors.white,
        body: mainContainer(),
      ),
    );
  }
}
