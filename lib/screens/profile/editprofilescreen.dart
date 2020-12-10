import 'dart:io';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:repyol/helpers/data.dart';
import 'package:repyol/providers/authprovider.dart';
import 'package:repyol/screens/profile/profilescreen.dart';


class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController;
  File _file;
  final ImagePicker _picker = ImagePicker();

  @override
  initState(){
    super.initState();
    nameController = new TextEditingController(
        text: Provider.of<AuthProvider>(context, listen: false)?.user?.name?.capitalize ?? ""
    );
    initData();
  }

  void initData() async {
    //await requestPermission(Permission.mediaLibrary);
    //await requestPermission(Permission.storage);
  }

  Widget nameField(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: TextField(
        controller: nameController,
        style: TextStyle(fontSize: 12, color: Colors.black),
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          filled: true,
          fillColor: mainColor6,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide.none,
          ),
          hintText: 'Full Name',
          hintStyle: TextStyle(fontSize: 12, color: Colors.black),
          prefixIcon: Icon(Icons.person_outlined, color: mainColor5,),
          //suffixIcon: Icon(Icons.send_sharp, color: Colors.amber,)
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
          onPressed: () async{
            Provider.of<AuthProvider>(context, listen: false).updateUser(Provider.of<AuthProvider>(context, listen: false).user.ref, nameController.text, _file);
            //Get.to(AddProductImagesScreen());
          },
          color: mainColor2,
          child: Text('Save', style: TextStyle(color: Colors.white, fontSize: 14),),
        ),
      ),
    );
  }

  Widget avatarContainer(){
    print(Get.height * 0.2);
    return SizedBox(
      width: 150,
      height: 135,
      child: Container(

        //color: Colors.red,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: CircularProfileAvatar(
                "", //sets image path, it should be a URL string. default value is empty string, if path is empty it will display only initials
                radius: 55, // sets radius, default 50.0
                backgroundColor: Colors.transparent, // sets background color, default Colors.white
                borderWidth: 2,  // sets border, default 0.0
                //initialsText: Text("${authController.user != null ? authController.user.value.name.substring(0, 2) : ""}", //Obx(() => Text("${controller.name}"))//,
                // style: TextStyle(fontSize: 10, color: Colors.white),
                // ),  // sets initials text, set your own style, default Text('')
                borderColor: mainColor3, // sets border color, default Colors.white
                elevation: 5.0, // sets elevation (shadow of the profile picture), default value is 0.0
                foregroundColor: mainColor3.withOpacity(0.2), //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
                cacheImage: true, // allow widget to cache image against provided url
                onTap: () {
                  print('adil');
                  Get.to(ProfileScreen());
                }, // sets on tap
                child: _file == null ?
                Image.asset("assets/images/applogo.png")
                    :
                Image.file(_file, fit: BoxFit.cover,)
                ,
              ),
            ),

            Positioned(
              top: 50,
              right: 7,
              //alignment: Alignment.centerRight,
              child: InkWell(
                onTap: ()async {
                  //FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.custom,
                  //  allowedExtensions: ['jpg', 'jpeg', 'png'],);

                  final PickedFile fileImage = await _picker.getImage(
                      source: ImageSource.gallery
                  );

                  if(PickedFile != null) {
                    //File file = File(PickedFilepath);
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
                        _file = croppedFile;
                      });
                    }
                  } else {
                    // User canceled the picker
                  }
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: mainColor3.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ]
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Center(
                      //heightFactor: 1,
                      child: Icon(Icons.camera_enhance_rounded, size: 16,color: mainColor3,),
                    ),
                  ),
                ),
              ),
            )
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          avatarContainer(),
          nameField(),
          continueBtn()
        ],
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
