import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:repyol/screens/auth/signinscreen.dart';
import 'package:repyol/helpers/data.dart';
import 'package:repyol/providers/authprovider.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool _obscure = false;

  Widget nameField(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: TextField(
        controller: nameController,
        keyboardType: TextInputType.name,
        style: TextStyle(fontSize: 12, color: Colors.black),
        //keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          filled: true,
          fillColor: mainColor6,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide.none,
          ),
          hintText: 'Full Name',
          hintStyle: TextStyle(fontSize: 12, color: Colors.black),
          prefixIcon: Icon(Icons.person, color: mainColor5,),
          //suffixIcon: Icon(Icons.send_sharp, color: Colors.amber,)
        ),
      ),
    );
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
        obscureText: _obscure,
        style: TextStyle(fontSize: 12, color: Colors.black),
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
            Provider.of<AuthProvider>(context, listen: false).signUpUser(nameController.text, emailController.text, passwordController.text);
            //Get.to(AddProductImagesScreen());
          },
          color: mainColor3,
          child: Text('Sign up', style: TextStyle(color: Colors.white, fontSize: 14),),
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
            Get.offAll(SignInScreen());
          },
          color: mainColor7,
          child: Text('Sign in', style: TextStyle(color: mainColor3 ),),
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
            SizedBox(height: 15,),
            Image.asset("assets/images/applogo.png", height: Get.height * 0.2,),
            SizedBox(height: 15,),
            nameField(),
            emailField(),
            SizedBox(height: 10,),
            passwordField(),
            continueBtn(),

            createAcctBtn(),

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
