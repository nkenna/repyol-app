import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:repyol/helpers/data.dart';
import 'package:repyol/models/category.dart';
import 'package:repyol/models/product.dart';
import 'package:repyol/providers/productsprovider.dart';
import 'package:repyol/screens/addproduct/addproductbasicscreen.dart';
import 'package:repyol/screens/products/productviewdetailscreen.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProductCategoryListScreen extends StatefulWidget {
  final Category category;

  const ProductCategoryListScreen({Key key, this.category}) : super(key: key);


  @override
  _ProductCategoryListScreenState createState() => _ProductCategoryListScreenState();
}

class _ProductCategoryListScreenState extends State<ProductCategoryListScreen> {

  @override
  initState(){
    super.initState();
    initData();
  }

  initData() async{
    Provider.of<ProductsProvider>(context, listen: false).getAllProductsByCategory(widget.category.name ?? "");

  }



  Widget SearchField(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: TextField(
        style: TextStyle(fontSize: 12, color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: mainColor6,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide.none,
          ),
          hintText: 'Search here',
          hintStyle: TextStyle(fontSize: 12, color: Colors.black),
          prefixIcon: Icon(Icons.search,color: mainColor5,),
          //suffixIcon: Icon(Icons.send_sharp, color: Colors.amber,)
        ),
      ),
    );
  }



  Widget popularProductContainer(Product product){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){
          Provider.of<ProductsProvider>(context, listen: false).setSelectedProduct(product);
          Get.to(ProductViewDetail());
        },
        child: Container(
          height: Get.height * 0.15,
          width: Get.width * 0.35,
          //color: Colors.blue,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Get.width * 0.3,
                //height: Get.height * 0.17,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                        image: NetworkImage(product.images.isNotEmpty ? product.images[0] : 'https://firebasestorage.googleapis.com/v0/b/talkabout-bf655.appspot.com/o/avatar%2Fapplogo.png?alt=media'),
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
                          Icon(Icons.favorite_outline_sharp, color: Colors.green,)
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
      ),
    );
  }

  Widget popularProducts(){
    var pProvider = Provider.of<ProductsProvider>(context, listen: true).allCategoryProducts;
    return Expanded(
      //width: Get.width,
      //height: Get.height *0.75,
      child: pProvider.length == 0 ?
      Center(
        child: Text("No data yet"),
      )
          : ListView.builder(
        //scrollDirection: Axis.horizontal,
          itemCount: pProvider.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int i){
            return popularProductContainer(pProvider[i]);
          }
      ),
    );
  }



  Widget mainContainer(){
    return Container(
        width: Get.width,
        height: Get.height,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SearchField(),

            popularProducts()
          ],
        )
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
          title: Text(widget.category?.name.toUpperCase() ?? "", overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'PoppinsSemiBold')),
          backgroundColor: Colors.white,
          centerTitle: true,
          actions: [
            InkWell(
                onTap: () {
                  Provider.of<ProductsProvider>(context,listen: false).setSelectedProduct(new Product());
                  Get.to(AddProductBasicScreen(isUpdate: false,));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.add, size: 18, color: Colors.black,),
                ))
          ],
        ),
        backgroundColor: Colors.white,
        body: mainContainer(),
      ),
    );
  }
}
