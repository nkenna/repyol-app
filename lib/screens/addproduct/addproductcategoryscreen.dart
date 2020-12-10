import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:repyol/models/newproduct.dart';
import 'package:repyol/providers/productsprovider.dart';
import 'package:repyol/screens/addproduct/addproductbasicscreen.dart';

class AddProductCategoryScreen extends StatefulWidget {
  bool isUpdate = false;

  AddProductCategoryScreen({this.isUpdate});

  @override
  _AddProductCategoryScreenState createState() => _AddProductCategoryScreenState();
}

class _AddProductCategoryScreenState extends State<AddProductCategoryScreen> {


  @override
  initState(){
    super.initState();
    //initData();
  }

  Widget listedCategories(){
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: Provider.of<ProductsProvider>(context, listen: true).allCategories.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int i){
          return Container(
            child: ListTile(
              onTap: (){
                NewProduct np = new NewProduct(
                    name: Provider.of<ProductsProvider>(context, listen: false).selectProduct.name ?? "",
                    description: Provider.of<ProductsProvider>(context, listen: false).selectProduct.description ?? "",
                    estimatedPrice: Provider.of<ProductsProvider>(context, listen: false).selectProduct.estimatedPrice ?? 0,
                    isUpdate: widget.isUpdate,

                    category: Provider.of<ProductsProvider>(context, listen: false).allCategories[i]?.name ?? "",
                    stores: Provider.of<ProductsProvider>(context, listen: false).selectProduct.stores,
                    imageFiles: Provider.of<ProductsProvider>(context, listen: false).selectProduct.images,
                    ref: Provider.of<ProductsProvider>(context, listen: false).selectProduct.ref ?? ""
                );
                Provider.of<ProductsProvider>(context, listen: false).setNewProduct(np);
                Get.to(AddProductBasicScreen(isUpdate: widget.isUpdate));
              },
              leading: Icon(
                Provider.of<ProductsProvider>(context, listen: false).selectProduct.category == Provider.of<ProductsProvider>(context, listen: true).allCategories[i]?.name
                    ?  Icons.star : Icons.star_border_outlined, color: Colors.green,),
              title: Text(Provider.of<ProductsProvider>(context, listen: true).allCategories[i]?.name.toUpperCase()?? "", style: TextStyle(fontSize: 14),),
            ),
          );
        }
    );
  }


  Widget mainContainer(){
    return SizedBox(
        width: Get.width,
        height: Get.height,
        //color: Colors.white,

        child: listedCategories()
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
          title: Text('Add Product - Select Category', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'PoppinsSemiBold')),
          backgroundColor: Colors.white,
          centerTitle: true,

        ),
        backgroundColor: Colors.white,
        body: mainContainer(),
      ),
    );
  }
}
