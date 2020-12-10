import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:repyol/helpers/data.dart';
import 'package:repyol/models/buypromotion.dart';
import 'package:repyol/models/promotionpackage.dart';
import 'package:repyol/providers/authprovider.dart';
import 'package:repyol/providers/productsprovider.dart';
import 'package:repyol/providers/promotionprovider.dart';

class PromotionPackagesScreen extends StatefulWidget {
  @override
  _PromotionPackagesScreenState createState() => _PromotionPackagesScreenState();
}

class _PromotionPackagesScreenState extends State<PromotionPackagesScreen> {

  @override
  initState(){
    super.initState();
    PaystackPlugin.initialize(publicKey: Data.PAYSTACK_API_KEY);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => initData());

  }

  initData() async {
    Provider.of<PromotionProvider>(context, listen: false).getAllPromoPackages();
  }

  Widget promoContainer(PromotionPackage pp, BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Container(
        width: Get.width,
        height: Get.height * 0.2,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [

              BoxShadow(
                color: Colors.amber.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 5,
                offset: Offset(0, 1), // changes position of shadow
              ),
            ]
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(pp?.name?.toUpperCase() ?? "", style: TextStyle(fontFamily: 'PoppinsBold', fontSize: 16),),
              Text('NGN ${pp.price}', style: TextStyle(fontFamily: 'PoppinsSemiBold', fontSize: 14),),

              pp.type == 'pc' ?
              Text('${pp.clicks} clicks', style: TextStyle(fontSize: 14),)
                  : pp.type == 'sub' ?
              Text('${pp.subDuration} day(s)', style: TextStyle(fontSize: 14),)
                  : Text('${pp.reviewNumber} reviews', style: TextStyle(fontSize: 14),),

              InkWell(
                onTap: () async{

                  Charge charge = Charge()
                    ..amount = pp.price * 100
                    ..reference = "REP${DateTime.now().millisecondsSinceEpoch}YOL"
                  // or ..accessCode = _getAccessCodeFrmInitialization()
                    ..email = '${Provider.of<AuthProvider>(context,listen: false).user?.email ?? ""}';

                  CheckoutResponse response = await PaystackPlugin.checkout(
                    context,
                    fullscreen: true,
                    logo: Image.asset("assets/images/applogo.png", height: Get.height * 0.1,),
                    method: CheckoutMethod.card,
                    charge: charge,
                  );

                  print(response.reference);

                  print(response);
                  if(response.message.toLowerCase().contains("success")){
                    // call backend api
                    BuyPromotion bp = new BuyPromotion(
                        name: pp.name,
                        promoRef: pp.ref,
                        productRef: Provider.of<ProductsProvider>(context,listen: false).selectProduct.ref,
                        ownerRef: Provider.of<AuthProvider>(context,listen: false).user.ref,
                        transRef: response.reference ?? "",
                        price: pp.price,
                        type: pp.type,
                        clicks: 0,
                        reviewNumber: 0,
                        subDuration: pp?.subDuration ?? 0

                    );
                    Provider.of<PromotionProvider>(context,listen: false).buyPromotion(bp);
                  }




                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Center(
                      child: Text('Choose', style: TextStyle(color: Colors.white),)
                  ),
                ),
              )
            ],
          ),
        ),
      ),

    );
  }


  Widget mainContainer(BuildContext context){
    var promoProvider = Provider.of<PromotionProvider>(context, listen: true);
    return SizedBox(
      width: Get.width,
      height: Get.height,
      //color: Colors.white,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: promoProvider.promoPackages.length,
          itemBuilder: (BuildContext context, int i){
            return promoContainer(promoProvider.promoPackages[i], context);
          }
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
          title: Text('Promotion Packages', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'PoppinsSemiBold')),
          backgroundColor: Colors.white,
          centerTitle: true,

        ),
        backgroundColor: Colors.white,
        body: mainContainer(context),
      ),
    );
  }
}
