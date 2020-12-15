import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:repyol/helpers/controlloader.dart';
import 'package:repyol/helpers/data.dart';
import 'package:repyol/providers/authprovider.dart';

class SendEmailScreen extends StatefulWidget {
  @override
  _SendEmailScreenState createState() => _SendEmailScreenState();
}

class _SendEmailScreenState extends State<SendEmailScreen> {
  TextEditingController emailController = new TextEditingController();


  @override
  initState(){
    super.initState();
  }

  Widget emailField(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: TextField(
        controller: emailController,
        style: TextStyle(fontSize: 12, color: Colors.black),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          filled: true,
          fillColor: mainColor6,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide.none,
          ),
          hintText: 'Email Address',
          hintStyle: TextStyle(fontSize: 12, color: Colors.black),
          prefixIcon: Icon(Icons.email, color: mainColor5,),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () async{
            if(emailController.text.isNotEmpty){
              Provider.of<AuthProvider>(context, listen: false).sendResetEmail(emailController.text);
            }else{
              showMessage("Email is required");
            }
            //Get.to(AddProductImagesScreen());
          },
          color: mainColor3,
          child: Text('Send Reset Code', style: TextStyle(color: Colors.white, fontSize: 14),),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Text(
              "Enter your email address. We will send a reset code to it.",
              style: TextStyle(color: Colors.black, fontFamily: 'PoppinsRegular'),
            ),
          ),

          emailField(),

          continueBtn(),
        ],
      ),


    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: mainContainer(),
      ),
    );
  }
}
