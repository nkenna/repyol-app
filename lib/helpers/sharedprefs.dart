import 'dart:convert';

import 'package:repyol/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPrefs._privateConstructor();
  static final SharedPrefs instance = SharedPrefs._privateConstructor();




  Future<String> retrieveUserData () async{
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString("user") ?? "";
  }

  setUserData(User userObject) async{
    print(userObject.image);
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    if (userObject != null) {
      myPrefs.setString("user", jsonEncode(userObject));

   }
  }

  clearData() async{
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.clear();
  }

  deleteData(String key) async{
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.remove(key);
  }

  saveInt(String key, int value) async{
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setInt(key, value);
  }

  saveString(String key, String value) async{
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString(key, value);
  }

  saveDouble(String key, double value) async{
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setDouble(key, value);
  }

  Future<List<String>> retrieveSearch() async{
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getStringList("search");
  }

  saveSearch(List<String> value) async{
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    //List<String> searches = retrieveSearch();
    print(value);
    if(value != null){
      myPrefs.setStringList("search", value);

    }

  }

}

//final sharedPrefs = SharedPrefs();