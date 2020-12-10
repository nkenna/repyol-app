import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';

import 'package:repyol/helpers/controlloader.dart';
import 'package:repyol/helpers/httpservice.dart';
import 'package:repyol/helpers/sharedprefs.dart';
import 'package:repyol/models/user.dart';
import 'package:repyol/screens/auth/forgotpasswordscreen.dart';
import 'package:repyol/screens/auth/signinscreen.dart';
import 'package:repyol/screens/landingscreen.dart';
import 'package:repyol/screens/profile/profilescreen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final HttpService httpService = new HttpService();
  User _user;
  User get user => _user;

  Future<bool> checkForUser(String ref) async{
    if(_user.ref == ref){
      return true;
    }else{
      return false;
    }
  }

  saveUser(User userObject){

    if(userObject != null){
      print(userObject);
      SharedPrefs.instance.setUserData(userObject);

    }
  }

  Future<void> retrieveUser() async{

      print("THIS ISSSSSS FFFFFFF");
      Map<String, dynamic> userMap;
      //print(sharedPrefs.userJson);
      String userStr = await SharedPrefs.instance.retrieveUserData();// sharedPrefs.userJson;
      print(userStr);
     // _user = tuser.User.fromJson(sph.getString("user") ?? {});
      if (userStr != null) {
        if(userStr.isNotEmpty){
          try{
            print("happening inside here");
            print(userStr);
            userMap = jsonDecode(userStr) as Map<String, dynamic>;
          }catch(e){
            print(e);
          }
        }

      }
      if (userMap != null) {
        _user = User.fromJson(userMap);
        print(_user);
        //return user;
      }
      notifyListeners();
  }

  signOutUser() {
    SharedPrefs.instance.clearData();//clearData();
    Get.offAll(SignInScreen());
  }

  signInUser(String email, String password) async{
    showLoader("loading...");
    final response = await httpService.signinUserRequest(email, password);

    if(response == null){
      dismissLoader();
      showErrorLoader("Network error. Try again.");
      return;
    }
    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    if (payload['status'] == 'success' && statusCode == 200){
      try{
        User userJ = User.fromJson(payload['user']);
        saveUser(userJ);
        Get.offAll(LandingScreen());
      }catch(e){
        print(e);
      }
      dismissLoader();
    }else if(payload['status'] == 'failed' && statusCode == 404){
      dismissLoader();
      showErrorLoader(payload['message']);
    }else if(payload['status'] == 'failed' && statusCode == 500){
      dismissLoader();
      showErrorLoader(payload['message']);
    }else {
      dismissLoader();
      showErrorLoader("unknown error occurred authenicating user");
    }

  }

  signUpUser(String name, String email, String password) async{
    showLoader("loading...");
    final response = await httpService.signUpUserRequest(name, email, password);

    if(response == null){
      dismissLoader();
      showErrorLoader("Network error. Try again.");
      return;
    }
    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    if (payload['status'] == 'success' && statusCode == 200){
      dismissLoader();
      Get.offAll(SignInScreen());

    }else if(payload['status'] == 'failed' && statusCode == 400){
      dismissLoader();
      showErrorLoader(payload['message']);
    }else if(payload['status'] == 'failed' && statusCode == 500){
      dismissLoader();
      showErrorLoader(payload['message']);
    }else {
      dismissLoader();
      showErrorLoader("unknown error occurred creating user");
    }

  }

  sendResetEmail(String email) async{
    showLoader("loading...");
    final response = await httpService.sendResetEmailRequest(email);

    if(response == null){
      dismissLoader();
      showErrorLoader("Network error. Try again.");
      return;
    }
    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    if (payload['status'] == 'success' && statusCode == 200){
      dismissLoader();
      Get.to(ForgotPasswordScreen(email: email));

    }else if(payload['status'] == 'failed' && statusCode == 400){
      dismissLoader();
      showErrorLoader(payload['message']);
    }else if(payload['status'] == 'failed' && statusCode == 500){
      dismissLoader();
      showErrorLoader(payload['message']);
    }else {
      dismissLoader();
      showErrorLoader("unknown error occurred creating user");
    }

  }

  addToken(String token, String ref, String dos) async{
    showLoader("loading...");
    final response = await httpService.addTokenRequest(token, ref, dos);

    if(response == null){
      return;
    }
    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    if (payload['status'] == 'success' && statusCode == 200){

    }else if(payload['status'] == 'failed' && statusCode == 400){

    }else if(payload['status'] == 'failed' && statusCode == 500){

    }else {

    }

  }

  resetPassword(String email, String password, String code) async{
    showLoader("loading...");
    final response = await httpService.resetPasswordRequest(email, password, code);

    if(response == null){
      dismissLoader();
      showErrorLoader("Network error. Try again.");
      return;
    }
    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    if (payload['status'] == 'success' && statusCode == 200){
      dismissLoader();
      Get.to(SignInScreen());
      showMessage("Password reset was successful");
    }else if(payload['status'] == 'failed' && statusCode == 400){
      dismissLoader();
      showErrorLoader(payload['message']);
    }else if(payload['status'] == 'failed' && statusCode == 500){
      dismissLoader();
      showErrorLoader(payload['message']);
    }else {
      dismissLoader();
      showErrorLoader("unknown error occurred creating user");
    }

  }


  updateUser(String userRef, String name, File image) async{
    showLoader("loading...");
    final response = await httpService.updateUserRequest(userRef, name, image);

    if(response == null){
      dismissLoader();
      showErrorLoader("Network error. Try again.");
      return;
    }
    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    if (payload['status'] == 'success' && statusCode == 200){
      try{
        //User userJ = User.fromJson(payload['user']);
        //saveUser(payload['user']);
        userProfile(_user.ref ?? "", _user.email ?? "");

      }catch(e){
        print(e);
      }
      dismissLoader();
    }else if(payload['status'] == 'failed' && statusCode == 404){
      dismissLoader();
      showErrorLoader(payload['message']);
    }else if(payload['status'] == 'failed' && statusCode == 500){
      dismissLoader();
      showErrorLoader(payload['message']);
    }else {
      dismissLoader();
      showErrorLoader("unknown error occurred authenicating user");
    }

  }

  userProfileLanding(String userRef, String email) async{
    //showLoader("loading...");
    final response = await httpService.userProfileRequest(userRef, email);

    if(response == null){
      dismissLoader();
      showErrorLoader("Network error. Try again.");
      return;
    }
    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    if (payload['status'] == 'success' && statusCode == 200){
      try{
        User userJ = User.fromJson(payload['user']);
        _user = userJ;
        saveUser(userJ);
        notifyListeners();
        //Get.off(ProfileScreen());
      }catch(e){
        print(e);
      }
      dismissLoader();
    }else if(payload['status'] == 'failed' && statusCode == 404){
      dismissLoader();
      showErrorLoader(payload['message']);
    }else if(payload['status'] == 'failed' && statusCode == 500){
      dismissLoader();
      showErrorLoader(payload['message']);
    }else {
      dismissLoader();
      showErrorLoader("unknown error occurred authenicating user");
    }

  }

  userProfile(String userRef, String email) async{
    showLoader("loading...");
    final response = await httpService.userProfileRequest(userRef, email);

    if(response == null){
      dismissLoader();
      showErrorLoader("Network error. Try again.");
      return;
    }
    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    if (payload['status'] == 'success' && statusCode == 200){
      try{
        User userJ = User.fromJson(payload['user']);
        _user = userJ;
        saveUser(userJ);
        notifyListeners();
        Get.off(ProfileScreen());
      }catch(e){
        print(e);
      }
      dismissLoader();
    }else if(payload['status'] == 'failed' && statusCode == 404){
      dismissLoader();
      showErrorLoader(payload['message']);
    }else if(payload['status'] == 'failed' && statusCode == 500){
      dismissLoader();
      showErrorLoader(payload['message']);
    }else {
      dismissLoader();
      showErrorLoader("unknown error occurred authenicating user");
    }

  }

  Future<int> userProfileOAuth(String email) async{
    showLoader("loading...");
    final response = await httpService.userProfileRequest("", email);

    if(response == null){
      dismissLoader();
      showErrorLoader("Network error. Try again.");
      return 0;
    }
    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    if (payload['status'] == 'success' && statusCode == 200){

      dismissLoader();
      return 1;
    }else if(payload['status'] == 'failed' && statusCode == 404){
      dismissLoader();
      return 2;
    }else if(payload['status'] == 'failed' && statusCode == 500){
      dismissLoader();
      showErrorLoader(payload['message']);
      return 3;
    }else {
      dismissLoader();
      showErrorLoader("unknown error occurred authenicating user");
      return 4;
    }

  }

}