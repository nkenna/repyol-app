import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:repyol/helpers/data.dart';
import 'package:repyol/models/newproduct.dart';
import 'package:repyol/models/product.dart';
import 'package:repyol/providers/authprovider.dart';
import 'package:repyol/providers/productsprovider.dart';
import 'package:repyol/screens/addproduct/addproductcategoryscreen.dart';
import 'package:repyol/screens/products/reviewscreen.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProductViewDetail extends StatefulWidget {

  @override
  _ProductViewDetailState createState() => _ProductViewDetailState();
}

class _ProductViewDetailState extends State<ProductViewDetail> {



  bool _isEdit = false;

  @override
  initState(){
    super.initState();
    initData();
  }

  initData() async {
    Provider.of<ProductsProvider>(context, listen: false).productReviews( Provider.of<ProductsProvider>(context, listen: false)?.selectProduct?.ref ?? "");
    Provider.of<AuthProvider>(context, listen: false).checkForUser(Provider.of<ProductsProvider>(context, listen: false)?.selectProduct?.ownerRef).then((value) => _isEdit = value);
  }

  Widget topBox(){
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: SizedBox(
        width: Get.width,
        height: Get.height * 0.35,
        child: Stack(
          children: [
            Positioned(
                top: 0,
                bottom: 0,
                right: 0,
                child: SizedBox(
                  width: Get.width,
                  height: double.infinity,
                  child: CarouselSlider.builder(
                    options: CarouselOptions(
                      height: double.infinity,
                      aspectRatio: 16/9,
                      disableCenter: true,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: false,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      //onPageChanged: callbackFunction,
                      scrollDirection: Axis.horizontal,
                    ),
                    itemCount: Provider.of<ProductsProvider>(context, listen: true).selectProduct.images.length,
                    itemBuilder: (BuildContext context, int itemIndex) => Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                            color: mainColor8,
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60), topLeft: Radius.circular(10)),
                            image: DecorationImage(
                                image: NetworkImage(Provider.of<ProductsProvider>(context, listen: true).selectProduct.images[itemIndex]),
                                fit: BoxFit.cover
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
                )
            ),

            /**Positioned(
                top: 20,
                left: 15,
                child: InkWell(
                onTap: () => Get.back(),
                child: Container(
                decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle
                ),
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Icon(Icons.arrow_back_ios, size: 18,)),
                )))
                ), **/

          ],
        ),
      ),
    );
  }



  Widget discriptionContainer(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Container(
        child: Text(Provider.of<ProductsProvider>(context, listen: true).selectProduct.description),
      ),
    );
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

  Widget similarProducts(){
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



  Widget showReviewBtn(){
    return SizedBox(
      width: double.infinity,
      height: Get.height * 0.12,

      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: (){
            Get.to(ReviewsScreen());
          },
          color: mainColor6,
          child: Text('Add and read reviews', style: TextStyle(fontFamily: 'PoppinSemiBold'),),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topBox(),
            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15, top:10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Provider.of<ProductsProvider>(context, listen: false).selectProduct?.name?.capitalize ?? "", overflow: TextOverflow.ellipsis, style: TextStyle(color: mainColor8, fontSize: 16, fontFamily: 'PoppinsBold'),),
                        SmoothStarRating(
                            allowHalfRating: true,
                            onRated: (v) {
                            },
                            starCount: 5,
                            rating: Provider.of<ProductsProvider>(context, listen: true).calcAverageRating(Provider.of<ProductsProvider>(context, listen: true).selectProduct),
                            size: 14.0,
                            isReadOnly:true,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_border_outlined,
                            color: mainColor3,
                            borderColor: mainColor3,
                            spacing:1.0
                        ),
                      ],
                    ),
                  ),
                  Text('${Provider.of<ProductsProvider>(context, listen: true).selectProduct?.reviews.length} review(s)', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, fontFamily: 'PoppinsSemiBold'),),
                ],
              ),
            ),
            showReviewBtn(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Text('Description', style: TextStyle(color: mainColor8, fontFamily: 'PoppinsBold', fontSize: 14),),
            ),
            discriptionContainer(),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Text('Similar Products', style: TextStyle(color: mainColor8, fontFamily: 'PoppinsBold', fontSize: 14),),
            ),
            similarProducts(),

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
              onTap: () => Get.back(),
              child: Icon(Icons.arrow_back_ios, size: 18, color: Colors.black,)),
          //title: Text('My Profile', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'PoppinsSemiBold')),
          backgroundColor: Colors.white,
          centerTitle: true,
          actions: [

            _isEdit ? InkWell(
              onTap: (){
                NewProduct np = new NewProduct(
                    name: Provider.of<ProductsProvider>(context, listen: false).selectProduct.name ?? "",
                    description: Provider.of<ProductsProvider>(context, listen: false).selectProduct.description ?? "",
                    category: Provider.of<ProductsProvider>(context, listen: false).selectProduct.category ?? "",
                    estimatedPrice: Provider.of<ProductsProvider>(context, listen: false).selectProduct.estimatedPrice ?? 0,
                    stores: Provider.of<ProductsProvider>(context, listen: false).selectProduct.stores,
                    imageFiles: Provider.of<ProductsProvider>(context, listen: false).selectProduct.images
                );
                Provider.of<ProductsProvider>(context, listen: false).setNewProduct(np);
                Get.to(AddProductCategoryScreen(isUpdate: true,));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Icon(Icons.edit, color: mainColor3,),
              ),
            ) : Container()
          ],

        ),
        backgroundColor: Colors.white,
        body: mainContainer(),
      ),
    );
  }
}
