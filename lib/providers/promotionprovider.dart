import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:repyol/helpers/controlloader.dart';
import 'package:repyol/helpers/httpservice.dart';
import 'package:repyol/models/buypromotion.dart';
import 'package:repyol/models/promotionpackage.dart';
import 'package:repyol/screens/profile/profilescreen.dart';

class PromotionProvider with ChangeNotifier {
  final HttpService httpService = new HttpService();
  List<PromotionPackage> _promoPackages = new List<PromotionPackage>();
  PromotionPackage _selectedPackage;

  List<PromotionPackage> get promoPackages => _promoPackages;
  PromotionPackage get selectedPackage => _selectedPackage;

  getAllPromoPackages() async{
    showLoader("loading...");
    final response = await httpService.allPromotionPackagesRequest();

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
      List<PromotionPackage> promos = new List<PromotionPackage>();
      var data = payload['promotions'];
      for(var i = 0 ; i < data.length; i++){
        try {
          PromotionPackage promo = PromotionPackage.fromJson(data[i]);
          promos.add(promo);
        }catch(e){
          print(e);
        }
      }
      _promoPackages = promos;
      notifyListeners();

      dismissLoader();
    }else if(payload['status'] == 'failed' && statusCode == 500){
      dismissLoader();
      showErrorLoader(payload['message']);
    }else {
      dismissLoader();
      showErrorLoader("unknown error occurred authenicating user");
    }

  }

  buyPromotion(BuyPromotion bp) async{
    showLoader("loading...");
    final response = await httpService.buyPromotionRequest(bp);

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
      showMessage("Promotion started successfully");
      Future.delayed(Duration(seconds: 4), (){
        Get.off(ProfileScreen());
      });

    }else if(payload['status'] == 'failed' && statusCode == 500){
      dismissLoader();
      showErrorLoader(payload['message'] + ". If you have been debited, please contact support and do not repeat the transaction.");
    }else if(payload['status'] == 'failed' && statusCode == 404){
      dismissLoader();
      showErrorLoader(payload['message']);
    }else {
      dismissLoader();
      showErrorLoader("unknown error occurred authenicating user");
    }

  }

}