import 'package:flutter/material.dart';

class Data {
  static String PAYSTACK_API_KEY = "pk_test_12412906c5bffc67c25e4b82355b935c933c2914";
}

Color mainColor1 = Color(0xffffbf00);
Color mainColor2 = Color(0xff6400fe);
Color mainColor3 = Color(0xff422F8F);
Color mainColor4 = Color(0xffa9fe00);
Color mainColor5 = Color(0xff77b200);
Color mainColor6 = Color(0xffEBF6E3);
Color mainColor7 = Color(0xffD0BBFE);
Color mainColor8 = Color(0xff93A2B5);

Map<int, Color> cColor = {
  50: Color.fromRGBO(66, 47, 143, .1),
  100: Color.fromRGBO(66, 47, 143, .2),
  200: Color.fromRGBO(66, 47, 143, .3),
  300: Color.fromRGBO(66, 47, 143, .4),
  400: Color.fromRGBO(66, 47, 143, .5),
  500: Color.fromRGBO(66, 47, 143, .6),
  600: Color.fromRGBO(66, 47, 143, .7),
  700: Color.fromRGBO(766, 47, 143, .8),
  800: Color.fromRGBO(66, 47, 143, .9),
  900: Color.fromRGBO(66, 47, 143, 1),
};

MaterialColor materialMainColor = MaterialColor(
    0xff4600b2,
    cColor);