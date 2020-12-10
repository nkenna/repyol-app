import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:repyol/helpers/controlloader.dart';
import 'package:repyol/helpers/data.dart';
import 'package:repyol/models/newproduct.dart';
import 'package:repyol/providers/productsprovider.dart';
import 'package:repyol/screens/addproduct/addproductfinalscreen.dart';
import 'package:repyol/screens/addproduct/addproductimagescreen.dart';

class AddProductBasicScreen extends StatefulWidget {
  bool isUpdate = false;

  AddProductBasicScreen({Key key, this.isUpdate}) : super(key: key);

  @override
  _AddProductBasicScreenState createState() => _AddProductBasicScreenState();
}

class _AddProductBasicScreenState extends State<AddProductBasicScreen> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController descController = new TextEditingController();

  @override
  initState(){
    super.initState();
    initData();
  }

  initData() async {
    nameController.text = Provider.of<ProductsProvider>(context, listen: false).newProduct.name ?? "";
    priceController.text = Provider.of<ProductsProvider>(context, listen: false).newProduct.estimatedPrice.toString() ?? "";
    descController.text = Provider.of<ProductsProvider>(context, listen: false).newProduct.description ?? "";
    //Provider.of<ProductsProvider>(context, listen: false).productReviews( Provider.of<ProductsProvider>(context, listen: false)?.selectProduct?.ref ?? "");

  }

  Widget nameField(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: TextField(
        controller: nameController,
        style: TextStyle(fontSize: 12, color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: mainColor6,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide.none,
          ),
          hintText: 'Product Name',
          hintStyle: TextStyle(fontSize: 12, color: Colors.black),


        ),
      ),
    );
  }

  Widget discField(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: TextField(
        controller: descController,
        textCapitalization: TextCapitalization.sentences,
        maxLines: 15,
        style: TextStyle(fontSize: 12, color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide.none,
          ),
          fillColor: mainColor6,
          hintText: 'Product Description',
          hintStyle: TextStyle(fontSize: 12, color: Colors.black),


        ),
      ),
    );
  }

  Widget priceField(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: TextField(
        controller: priceController,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(fontSize: 12, color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.withAlpha(50),
          border: InputBorder.none,
          hintText: 'Product Estimated Price',
          hintStyle: TextStyle(fontSize: 12, color: Colors.black),


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
          onPressed: (){
            if(nameController.text.isEmpty){
              showErrorLoader("Product name is required");
              return;
            }else if(descController.text.isEmpty){
              showErrorLoader("Product decription is required");
              return;
            }
            print(widget.isUpdate);

            NewProduct np = new NewProduct(
                name: nameController.text ?? "",
                description: descController.text ?? "",
                estimatedPrice: int.parse(priceController.text) ?? 0,
                isUpdate: widget.isUpdate,

                category: widget.isUpdate ? Provider.of<ProductsProvider>(context, listen: false).selectProduct.category ?? "" : Provider.of<ProductsProvider>(context, listen: false).newProduct.category,
                stores: Provider.of<ProductsProvider>(context, listen: false).selectProduct.stores,
                imageFiles: Provider.of<ProductsProvider>(context, listen: false).selectProduct.images,
                ref: Provider.of<ProductsProvider>(context, listen: false).selectProduct.ref ?? ""
            );
            Provider.of<ProductsProvider>(context, listen: false).setNewProduct(np);
            if(widget.isUpdate){
              Get.to(AddProductFinalScreen());
            }else{
              Get.to(AddProductImagesScreen());
            }
          },
          color: mainColor3,
          child: Text('Continue', style: TextStyle(color: Colors.white),),
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
              nameField(),
              discField(),
              //priceField(),
              continueBtn()

            ],
          ),
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
          title: Text('Add Product - Basic Info', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'PoppinsSemiBold')),
          backgroundColor: Colors.white,
          centerTitle: true,

        ),
        backgroundColor: Colors.white,
        body: mainContainer(),
      ),
    );
  }
}
