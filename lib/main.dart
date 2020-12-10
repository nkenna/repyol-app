import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:repyol/providers/authprovider.dart';
import 'package:repyol/providers/productsprovider.dart';
import 'package:repyol/providers/promotionprovider.dart';
import 'package:repyol/screens/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/data.dart';
import 'helpers/sharedprefs.dart';

final ThemeData kIOSTheme = new ThemeData(
    primarySwatch: materialMainColor,
    primaryColor: mainColor3,
    primaryIconTheme: IconThemeData(color: Colors.white),
    primaryColorBrightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'PoppinsRegular'

);

final ThemeData kDefaultTheme = new ThemeData(
    primarySwatch: materialMainColor,
    primaryColor: mainColor3,
    accentColor: mainColor3,
    primaryIconTheme: IconThemeData(color: Colors.white),
    primaryColorBrightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'PoppinsRegular'

);

//void main() {
//  runApp(MyApp());
//}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 500)
    ..indicatorType = EasyLoadingIndicatorType.wanderingCubes
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = mainColor3
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  configLoading();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: mainColor3,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: mainColor3,
      )
  );
  runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) =>AuthProvider()),
        ChangeNotifierProvider(create: (context) =>ProductsProvider()),
        ChangeNotifierProvider(create: (context) =>PromotionProvider()),

      ],
        child: MyApp(),
      )
  );

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Repyol',
        debugShowCheckedModeBanner: false,
        theme: Platform.isIOS ? kIOSTheme : kDefaultTheme,
        home: SplashScreen(),//SignInScreen(),
        /**builder: (_, child){
        Portal(child: child);
        EasyLoading.init();
      }, **/
        builder: EasyLoading.init(
          builder: (_, child) => Portal(child: child)
        ),
    );
  }
}


