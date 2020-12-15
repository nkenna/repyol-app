import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:repyol/helpers/controlloader.dart';
import 'package:repyol/helpers/data.dart';
import 'package:repyol/providers/authprovider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String email;

  const ForgotPasswordScreen({Key key, this.email}) : super(key: key);
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController codeController = new TextEditingController();

  bool _obscure = true;


  @override
  initState(){
    super.initState();
    emailController.text = widget.email;
  }

  Widget emailField(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: IgnorePointer(
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
      ),
    );
  }



  Widget codeField(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: TextField(
        controller: codeController,
        style: TextStyle(fontSize: 12, color: Colors.black),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          filled: true,
          fillColor: mainColor6,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide.none,
          ),
          hintText: 'Code',
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
            if(codeController.text.isEmpty || passwordController.text.isEmpty){
              showErrorLoader("Password or Code field cannot be empty");
              return;
            }
            Provider.of<AuthProvider>(context, listen: false).resetPassword(emailController.text, passwordController.text, codeController.text);
            //Get.to(AddProductImagesScreen());
          },
          color: mainColor3,
          child: Text('Reset Password', style: TextStyle(color: Colors.white, fontSize: 14),),
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
                "Enter the reset code sent to your email.",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.black, fontFamily: 'PoppinsRegular'),
              ),
            ),


            emailField(),
            codeField(),
            SizedBox(height: 10,),

            passwordField(),
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
