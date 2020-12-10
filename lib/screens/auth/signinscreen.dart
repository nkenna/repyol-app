import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:repyol/screens/auth/forgotpasswordscreen.dart';
import 'package:repyol/screens/auth/sendemailscreen.dart';
import 'package:repyol/screens/auth/signupscreen.dart';
import 'package:repyol/helpers/data.dart';
import 'package:repyol/providers/authprovider.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool _obscure = true;


  @override
  initState(){
    super.initState();
    initData();

  }

  void initData() async {
    await requestPermission();
    //await requestPermission(Permission.storage);
  }

  requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.mediaLibrary,

    ].request();
    print(statuses);
  }


  Widget emailField(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: TextField(
        controller: emailController,
        style: TextStyle(fontSize: 12, color: Colors.black),
        keyboardType: TextInputType.emailAddress,
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

  Widget passwordField(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: TextField(
        controller: passwordController,
        style: TextStyle(fontSize: 12, color: Colors.black),
        keyboardType: TextInputType.text,
        obscureText: _obscure,
        decoration: InputDecoration(
          filled: true,
          fillColor: mainColor6,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide.none,
          ),
          hintText: 'Password',
          hintStyle: TextStyle(fontSize: 12, color: Colors.black),
          prefixIcon: Icon(Icons.lock,color: mainColor5,),
          suffixIcon: IconButton(
            onPressed: (){
              setState(() {
                _obscure = _obscure ? false : true;
              });
            },
            icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: mainColor5),
          )
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
            Provider.of<AuthProvider>(context, listen: false).signInUser(emailController.text, passwordController.text);
            //Get.to(AddProductImagesScreen());
          },
          color: mainColor3,
          child: Text('Sign in', style: TextStyle(color: Colors.white, fontSize: 14),),
        ),
      ),
    );
  }

  Widget createAcctBtn(){
    return SizedBox(
      width: double.infinity,
      height: Get.height * 0.12,

      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: () async{
            //Provider.of<AuthProvider>(context, listen: false).signInUser(emailController.text, passwordController.text);
            Get.offAll(SignupScreen());
          },
          color: mainColor7,
          child: Text('Create account', style: TextStyle(color: mainColor3 ),),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            Image.asset("assets/images/applogo.png", height: Get.height * 0.2,),
            SizedBox(height: 20,),

            emailField(),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Container(
                  width: double.infinity,
                  child: InkWell(
                      onTap: (){
                        Get.to(SendEmailScreen());
                      },
                      child: Text("Forgot Password", textAlign: TextAlign.right, style: TextStyle(decoration: TextDecoration.underline, fontSize: 12, fontFamily: 'PoppinsSemiBold'),))),
            ),
            passwordField(),
            continueBtn(),

            createAcctBtn()

          ],
        ),
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
