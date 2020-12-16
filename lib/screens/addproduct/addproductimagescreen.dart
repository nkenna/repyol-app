import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:repyol/helpers/controlloader.dart';
import 'package:repyol/helpers/data.dart';
import 'package:repyol/models/newproduct.dart';
import 'package:repyol/providers/productsprovider.dart';
import 'package:repyol/screens/addproduct/addproductfinalscreen.dart';

class AddProductImagesScreen extends StatefulWidget {
  @override
  _AddProductImagesScreenState createState() => _AddProductImagesScreenState();
}

class _AddProductImagesScreenState extends State<AddProductImagesScreen> {
  List<File> _files = List<File>(4);
  final ImagePicker _picker = ImagePicker();
  PickedFile _imageFile;



  @override
  initState(){
    super.initState();
    initData();
    for(var i = 0; i < _files.length; i++){
      _files[i] = new File("");
    }
  }

  void initData() async {
    //await requestPermission(Permission.mediaLibrary);
    //await requestPermission(Permission.storage);
  }





  Widget imageContainer(int i){
    //print(i);
    // print(i < Provider.of<ProductsProvider>(context, listen: false).newProduct.imageFiles.length ? Provider.of<ProductsProvider>(context, listen: false).newProduct.imageFiles[i] : "" );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          //FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.custom,
          //  allowedExtensions: ['jpg', 'jpeg', 'png'],);
          
          final PickedFile fileImage = await _picker.getImage(
              source: ImageSource.gallery
          );

          //_imageFile = fileImage;

          if(fileImage != null) {
           // File file = File(fileImage.path);
            File croppedFile = await ImageCropper.cropImage(
                sourcePath: fileImage.path,
                aspectRatioPresets: Platform.isAndroid
                    ? [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9
                ]
                    : [
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio5x3,
                  CropAspectRatioPreset.ratio5x4,
                  CropAspectRatioPreset.ratio7x5,
                  CropAspectRatioPreset.ratio16x9
                ],
                androidUiSettings: AndroidUiSettings(
                    toolbarTitle: 'Edit Image',
                    toolbarColor: Colors.amber,
                    toolbarWidgetColor: Colors.white,
                    initAspectRatio: CropAspectRatioPreset.original,
                    lockAspectRatio: false),
                iosUiSettings: IOSUiSettings(
                  title: 'Edit Image',
                ));
            if(croppedFile != null){
              print(croppedFile.path);
              setState(() {
                _files[i] = croppedFile;
              });
            }
          } else {
            // User canceled the picker
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              color: mainColor7,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              image: _files[i].isNull ? DecorationImage(
                  image: AssetImage("assets/images/applogo.png"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.amber, BlendMode.colorBurn)
              ):
              DecorationImage(
                  image: FileImage(_files[i]),
                  fit: BoxFit.fill
              )
          ),

        ),
      ),
    );
  }


  Widget mainContainer(){
    return Container(
        width: Get.width,
        height: Get.height,
        color: Colors.white,

        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Tap on any of these boxes to add your Product or Brand Image. You can select a minimum of two (2) and maximum of four(4).",
                style: TextStyle(color: mainColor3, fontSize: 12, fontFamily: 'PoppinsSemiBold'),
              ),
            ),
            Expanded(
                child: Row(
                  children: [
                    Expanded(child: imageContainer(0)),
                    Expanded(child: imageContainer(1)),
                  ],
                )
            ),
            Expanded(
                child: Row(
                  children: [
                    Expanded(child: imageContainer(2)),
                    Expanded(child: imageContainer(3)),
                  ],
                )
            ),
          ],
        )
    );
  }

  int checkEmptyIndex(List<File> fss){
    List<int> data = new List<int>();
    if(fss[0].isNull == false){
      data.add(1);
    }

    if(fss[1].isNull == false){
      data.add(1);
    }

    if(fss[2].isNull == false){
      data.add(1);
    }

    if(fss[3].isNull == false){
      data.add(1);
    }
    print("CCC");
    print(data.length);
    return data.length;
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
              onTap: () => Get.back(),
              child: Icon(Icons.arrow_back_ios, size: 18, color: Colors.black,)),
          title: Text('Add Product - Images', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'PoppinsSemiBold')),
          backgroundColor: Colors.white,
          centerTitle: true,
          actions: [
            InkWell(
                onTap: () {
                  print(checkEmptyIndex(_files));
                  if(Provider.of<ProductsProvider>(context, listen: false).selectProduct.images == null || Provider.of<ProductsProvider>(context, listen: false).selectProduct.images.length == 0){
                    if(_files.isEmpty){
                      showErrorLoader("Select atleast two image to continue");
                      return;
                    }else if(checkEmptyIndex(_files) < 2){
                      showErrorLoader("Select atleast two images to continue");
                      return;
                    }
                  }else{

                  }

                  NewProduct np = new NewProduct(
                      name: Provider.of<ProductsProvider>(context, listen: false).newProduct.name,
                      description: Provider.of<ProductsProvider>(context, listen: false).newProduct.description,
                      estimatedPrice: Provider.of<ProductsProvider>(context, listen: false).newProduct.estimatedPrice,
                      category: Provider.of<ProductsProvider>(context, listen: false).newProduct.category,
                      images: checkEmptyIndex(_files) > 0 ? _files : new List<File>(),
                      stores: Provider.of<ProductsProvider>(context, listen: false).selectProduct.stores,
                      isUpdate: false,

                      //ategory: Provider.of<ProductsProvider>(context, listen: false).selectProduct.category ?? "",
                      //stores: Provider.of<ProductsProvider>(context, listen: false).selectProduct.stores,
                      imageFiles: Provider.of<ProductsProvider>(context, listen: false).selectProduct.images,
                      ref: Provider.of<ProductsProvider>(context, listen: false).newProduct.ref
                  );
                  Provider.of<ProductsProvider>(context, listen: false).setNewProduct(np);
                  Get.to(AddProductFinalScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.send_sharp, size: 18, color: mainColor3,),
                ))
          ],

        ),
        backgroundColor: Colors.white,
        body: mainContainer(),
      ),
    );
  }
}
