import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:repyol/helpers/data.dart';
import 'package:repyol/models/newproduct.dart';
import 'package:repyol/models/storelisting.dart';
import 'package:repyol/providers/authprovider.dart';
import 'package:repyol/providers/productsprovider.dart';
import 'package:repyol/screens/landingscreen.dart';

class AddProductFinalScreen extends StatefulWidget {
  @override
  _AddProductFinalScreenState createState() => _AddProductFinalScreenState();
}

class _AddProductFinalScreenState extends State<AddProductFinalScreen> {
  List<AddproductStoreListing> sls = new List<AddproductStoreListing>();
  TextEditingController storeNameController = new TextEditingController();
  TextEditingController storeLinkontroller = new TextEditingController();

  @override
  initState(){
    super.initState();
    if(Provider.of<ProductsProvider>(context, listen: false).newProduct.isUpdate){
      sls = Provider.of<ProductsProvider>(context, listen: false).selectProduct.stores;
    }
  }

  Widget nameField(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: TextField(
        controller: storeNameController,
        style: TextStyle(fontSize: 12, color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: mainColor6,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide.none,
          ),
          hintText: 'Store Name',
          hintStyle: TextStyle(fontSize: 12, color: Colors.black),


        ),
      ),
    );
  }

  Widget linkField(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: TextField(
        controller: storeLinkontroller,
        style: TextStyle(fontSize: 12, color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: mainColor6,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide.none,
          ),
          hintText: 'Product link in store',
          hintStyle: TextStyle(fontSize: 12, color: Colors.black),


        ),
      ),
    );
  }

  Widget addBtn(){
    return SizedBox(
      width: double.infinity,
      height: Get.height * 0.12,

      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: RaisedButton(
          onPressed: (){
            AddproductStoreListing apsl = new AddproductStoreListing(
                storeName: storeNameController.text,
                storeLink: storeLinkontroller.text
            );
            setState(() {
              sls.add(apsl);
            });
          },
          color: mainColor7,
          child: Text('Add Store listing', style: TextStyle(decoration: TextDecoration.underline, color: mainColor2),),
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
            Provider.of<AuthProvider>(context, listen: false).retrieveUser();
            if(Provider.of<ProductsProvider>(context, listen: false).newProduct.isUpdate){
              NewProduct np = new NewProduct(
                name: Provider.of<ProductsProvider>(context, listen: false).newProduct.name,
                description: Provider.of<ProductsProvider>(context, listen: false).newProduct.description,
                estimatedPrice: Provider.of<ProductsProvider>(context, listen: false).newProduct.estimatedPrice,
                category: Provider.of<ProductsProvider>(context, listen: false).newProduct.category,
                //images: Provider.of<ProductsProvider>(context, listen: false).newProduct.images,
                //imageFiles: Provider.of<ProductsProvider>(context, listen: false).selectProduct.images,
                stores: sls,
                ref: Provider.of<ProductsProvider>(context, listen: false).selectProduct.ref,
                //isUpdate: Provider.of<ProductsProvider>(context, listen: false).selectProduct.images.length > 0 ? true : false

              );
              print(np);
              Provider.of<ProductsProvider>(context, listen: false).setNewProduct(np);
              Provider.of<ProductsProvider>(context, listen: false).updateProduct();

            }else{
              NewProduct np = new NewProduct(
                name: Provider.of<ProductsProvider>(context, listen: false).newProduct.name,
                description: Provider.of<ProductsProvider>(context, listen: false).newProduct.description,
                estimatedPrice: Provider.of<ProductsProvider>(context, listen: false).newProduct.estimatedPrice,
                category: Provider.of<ProductsProvider>(context, listen: false).newProduct.category,
                images: Provider.of<ProductsProvider>(context, listen: false).newProduct.images,
                //imageFiles: Provider.of<ProductsProvider>(context, listen: false).selectProduct.images,
                stores: Provider.of<ProductsProvider>(context, listen: false).selectProduct.stores,
                ref: Provider.of<ProductsProvider>(context, listen: false).selectProduct.ref,
                //isUpdate: Provider.of<ProductsProvider>(context, listen: false).selectProduct.images.length > 0 ? true : false

              );
              print(np);
              Provider.of<ProductsProvider>(context, listen: false).setNewProduct(np);
              Provider.of<ProductsProvider>(context, listen: false).createNewProduct(Provider.of<AuthProvider>(context, listen: false).user.ref ?? "");

            }


            Get.to(LandingScreen());
          },
          color: mainColor3,
          child: Text('Submit', style: TextStyle(color: Colors.white),),
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
              linkField(),
              addBtn(),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Column(
                  children: List.generate(sls.length, (index) =>
                      Container(
                        width: double.infinity,
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Store name: ${sls[index].storeName}', style: TextStyle(fontSize: 12),),
                                Text("Product Link: ${sls[index].storeLink}", style: TextStyle(fontSize: 12),)
                              ],
                            ),

                            InkWell(
                                onTap: (){
                                  setState(() {
                                    sls.removeAt(index);
                                  });
                                },
                                child: Icon(Icons.close))
                          ],
                        ),
                      )
                  ),
                ),
              ),

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
          title: Text('Add Product - Store listings', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'PoppinsSemiBold')),
          backgroundColor: Colors.white,
          centerTitle: true,

        ),
        backgroundColor: Colors.white,
        body: mainContainer(),
      ),
    );
  }
}
