import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:repyol/helpers/data.dart';
import 'package:repyol/models/createfavoriteproduct.dart';
import 'package:repyol/models/product.dart';
import 'package:repyol/providers/authprovider.dart';
import 'package:repyol/providers/productsprovider.dart';
import 'package:repyol/screens/products/productviewdetailscreen.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class AllProductsScreen extends StatefulWidget {
  final List<Product> chosenProducts;

  const AllProductsScreen({Key key, this.chosenProducts}) : super(key: key);

  @override
  _AllProductsScreenState createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  initState(){
    super.initState();
    print(widget.chosenProducts.length);
    //initData();
  }

  initData() async{
    //Provider.of<ProductsProvider>(context, listen: false).getAllProductsByCategory(widget.category.name ?? "");

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

    return widget.chosenProducts.length == 0 ?
    Center(
      child: Text("No data yet"),
    )
        : ListView.builder(
      //scrollDirection: Axis.horizontal,
        itemCount: widget.chosenProducts.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int i){
          return popularProductContainer(widget.chosenProducts[i]);
        }
    );
  }



  Widget mainContainer(){
    return Container(
        width: Get.width,
        height: Get.height,
        color: Colors.white,
        child: popularProducts()

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
          title: Text("", overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'PoppinsSemiBold')),
          backgroundColor: Colors.white,
          centerTitle: true,

        ),
        backgroundColor: Colors.white,
        body: mainContainer(),
      ),
    );
  }
}
