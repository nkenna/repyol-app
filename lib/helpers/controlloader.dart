import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';


  void showLoader(String status) async{
    await EasyLoading.show(
      status: status,
      maskType: EasyLoadingMaskType.custom,
      dismissOnTap: false
    );
  }

  void dismissLoader() async{
    await EasyLoading.dismiss(animation: true);
  }

  void showErrorLoader(String error) async {
    await EasyLoading.showError(error, duration:  Duration(seconds: 5), maskType: EasyLoadingMaskType.black, dismissOnTap: true);
  }

  void showMessage(String info) async {
    await EasyLoading.showInfo(info, duration: Duration(seconds: 6), dismissOnTap: true);
  }

  void showDialog(Function callback) async {
    Get.defaultDialog(
        title: "Upload Info",
        content: Text("Your upload did not complete. Do you want to retry?"),
        confirm: FlatButton(
          child: Text("Ok"),
          onPressed: () => callback,
        ),
        cancel: FlatButton(
          child: Text("Cancel"),
          onPressed: () => Get.back(),
        ));
  }
