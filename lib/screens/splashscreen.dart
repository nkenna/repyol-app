import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:repyol/screens/auth/signinscreen.dart';
import 'package:repyol/providers/authprovider.dart';
import 'package:repyol/screens/landingscreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //checkAuth();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => checkAuth());


  }

  checkAuth() async{
    await Provider.of<AuthProvider>(context, listen: false).retrieveUser();
    Future.delayed(Duration(seconds: 1), () async {

        if(Provider.of<AuthProvider>(context, listen: false).user == null){
          print("should see user email::::::::::::::::::;1");
          //print(Provider.of<AuthProvider>(context, listen: false).user.email);
          Get.offAll(SignInScreen(), curve: Curves.easeInCirc, duration: Duration(milliseconds: 500), transition: Transition.downToUp);
        }else{
          print("should see user email::::::::::::::::::;2");
          print(Provider.of<AuthProvider>(context, listen: false).user.email);
          Get.offAll(LandingScreen(), curve: Curves.easeInCirc, duration: Duration(milliseconds: 500), transition: Transition.downToUp);
        }


    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.white,
      child: Image.asset("assets/images/splash.png", height: Get.height, width: Get.width, fit: BoxFit.cover,)
    );
  }
}
