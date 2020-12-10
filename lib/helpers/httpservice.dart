import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:repyol/models/buypromotion.dart';
import 'package:repyol/models/createfavoriteproduct.dart';
import 'package:repyol/models/newproduct.dart';


class HttpService {
  String baseUrl = "https://talkaboutserver.herokuapp.com/";//"http://192.168.0.160:8080/";

  Future<Response> signinUserRequest(String email, String password) async{
    print("insode http");
    var url = baseUrl + "v1/api/users/login-user";
    print(url);
    var dio = Dio();
    try {
      dio.options.headers = {
        HttpHeaders.acceptHeader: ' application/json',
        HttpHeaders.contentTypeHeader: 'application/json'
      };
      var body = jsonEncode(
          <String, dynamic>{
            "email": email,
            "password": password,
          }
      );
      print(body);
      //print(image.path);
      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: ' application/json'
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      print("");
      print("");
      print(response.data);
      return response;
    } on DioError catch (e) {
      print(e?.response ?? "");
      return e.response != null ? e.response : null;
    }
  }

  Future<Response> signUpUserRequest(String name, String email, String password) async{
    print("insode http");
    var url = baseUrl + "v1/api/users/create-user";
    print(url);
    var dio = Dio();
    try {
      dio.options.headers = {
        HttpHeaders.acceptHeader: ' application/json',
        HttpHeaders.contentTypeHeader: 'application/json'
      };
      var body = jsonEncode(
          <String, dynamic>{
            "name":  name,
            "email": email,
            "password": password,
          }
      );
      print(body);
      //print(image.path);
      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: ' application/json'
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      print("");
      print("");
      print(response.data);
      return response;
    } on DioError catch (e) {
      print(e?.response ?? "");
      return e.response != null ? e.response : null;
    }
  }

  Future<Response> sendResetEmailRequest(String email) async{
    print("insode http");
    var url = baseUrl + "v1/api/users/send-reset-email";
    print(url);
    var dio = Dio();
    try {
      dio.options.headers = {
        HttpHeaders.acceptHeader: ' application/json',
        HttpHeaders.contentTypeHeader: 'application/json'
      };
      var body = jsonEncode(
          <String, dynamic>{
            "email": email
          }
      );
      print(body);
      //print(image.path);
      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: ' application/json'
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      print("");
      print("");
      print(response.data);
      return response;
    } on DioError catch (e) {
      print(e?.response ?? "");
      return e.response != null ? e.response : null;
    }
  }

  Future<Response> addTokenRequest(String token, String ref, String dos) async{
    print("insode http");
    var url = baseUrl + "v1/api/devices/add-token";
    print(url);
    var dio = Dio();
    try {
      dio.options.headers = {
        HttpHeaders.acceptHeader: ' application/json',
        HttpHeaders.contentTypeHeader: 'application/json'
      };
      var body = jsonEncode(
          <String, dynamic>{
            "token": token,
            "userRef": ref,
            "dos": dos,

          }
      );
      print(body);
      //print(image.path);
      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: ' application/json'
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      print("");
      print("");
      print(response.data);
      return response;
    } on DioError catch (e) {
      print(e?.response ?? "");
      return e.response != null ? e.response : null;
    }
  }

  Future<Response> resetPasswordRequest(String email, String password, String code) async{
    print("insode http");
    var url = baseUrl + "v1/api/users/reset-password";
    print(url);
    var dio = Dio();
    try {
      dio.options.headers = {
        HttpHeaders.acceptHeader: ' application/json',
        HttpHeaders.contentTypeHeader: 'application/json'
      };
      var body = jsonEncode(
          <String, dynamic>{
            "resetCode": code,
            "newPassword": password,
            "email": email
          }
      );
      print(body);
      //print(image.path);
      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: ' application/json'
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      print("");
      print("");
      print(response.data);
      return response;
    } on DioError catch (e) {
      print(e?.response ?? "");
      return e.response != null ? e.response : null;
    }
  }

  Future<Response> allCategoriesRequest() async{
    print("insode http");
    var url = baseUrl + "v1/api/products/all-categories";
    print(url);
    var dio = Dio();
    try {
      dio.options.headers = {
        HttpHeaders.acceptHeader: ' application/json',
        HttpHeaders.contentTypeHeader: 'application/json'
      };

      //print(image.path);
      dio.options.connectTimeout = 35000;
      Response response = await dio.get(
        url,

        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: ' application/json'
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      print("");
      print("");
      print(response.data);
      return response;
    } on DioError catch (e) {
      print(e?.response ?? "");
      return e.response != null ? e.response : null;
    }
  }

  Future<Response> allProductsRequest() async{
    print("insode http");
    var url = baseUrl + "v1/api/products/all-products";
    print(url);
    var dio = Dio();
    try {
      dio.options.headers = {
        HttpHeaders.acceptHeader: ' application/json',
        HttpHeaders.contentTypeHeader: 'application/json'
      };

      //print(image.path);
      dio.options.connectTimeout = 35000;
      Response response = await dio.get(
        url,

        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: ' application/json'
            }
        ),
      );
      print("this response");
     // print(response.statusCode);
     // print(response);
     // print("");
     // print("");
     // print(response.data);
      return response;
    } on DioError catch (e) {
      print(e?.response ?? "");
      return e.response != null ? e.response : null;
    }
  }

  Future<Response> createReviewRequest(String content, double rating, String reviewerRef, String reviewedRef) async{
    print("insode http");
    var url = baseUrl + "v1/api/reviews/create-review";
    print(url);
    var dio = Dio();
    try {
      dio.options.headers = {
        HttpHeaders.acceptHeader: ' application/json',
        HttpHeaders.contentTypeHeader: 'application/json'
      };
      var body = jsonEncode(
          <String, dynamic>{
            "content": content,
            "rating": rating,
            "reviewerRef": reviewerRef,
            "reviewedRef": reviewedRef
          }
      );
      print(body);
      //print(image.path);
      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: ' application/json'
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      print("");
      print("");
      print(response.data);
      return response;
    } on DioError catch (e) {
      print(e?.response ?? "");
      return e.response != null ? e.response : null;
    }
  }

  Future<Response> productReviewsRequest(String prodRef) async{
    print("insode http");
    var url = baseUrl + "v1/api/reviews/product-review";
    print(url);
    var dio = Dio();
    try {
      dio.options.headers = {
        HttpHeaders.acceptHeader: ' application/json',
        HttpHeaders.contentTypeHeader: 'application/json'
      };
      var body = jsonEncode(
          <String, dynamic>{
            "prodRef": prodRef
          }
      );
      print(body);
      //print(image.path);
      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: ' application/json'
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      print("");
      print("");
      print(response.data);
      return response;
    } on DioError catch (e) {
      print(e?.response ?? "");
      return e.response != null ? e.response : null;
    }
  }

  Future<Response> allProductsByCategoryRequest(String categoryName) async{
    print("insode http");
    var url = baseUrl + "v1/api/products/all-products-by-category";
    print(url);
    var dio = Dio();
    try {
      dio.options.headers = {
        HttpHeaders.acceptHeader: ' application/json',
        HttpHeaders.contentTypeHeader: 'application/json'
      };
      var body = jsonEncode(
          <String, dynamic>{
            "categoryName": categoryName
          }
      );
      print(body);
      //print(image.path);
      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: ' application/json'
            }
        ),
      );
      print("this response");
      //print(response.statusCode);
      //print(response);
      //print("");
      //print("");
      //print(response.data);
      return response;
    } on DioError catch (e) {
      print(e?.response ?? "");
      return e.response != null ? e.response : null;
    }
  }

  Future<Response> productSearchRequest(String name) async{
    print("insode http");
    var url = baseUrl + "v1/api/products/search-product";
    print(url);
    var dio = Dio();
    try {
      dio.options.headers = {
        HttpHeaders.acceptHeader: ' application/json',
        HttpHeaders.contentTypeHeader: 'application/json'
      };
      var body = jsonEncode(
          <String, dynamic>{
            "name": name
          }
      );
      print(body);
      //print(image.path);
      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: ' application/json'
            }
        ),
      );
      print("this response");
      //print(response.statusCode);
      //print(response);
      //print("");
      //print("");
      //print(response.data);
      return response;
    } on DioError catch (e) {
      print(e?.response ?? "");
      return e.response != null ? e.response : null;
    }
  }

  Future<Response> getNewProductsRequest() async{
    print("insode http");
    var url = baseUrl + "v1/api/products/newest-products";
    print(url);
    var dio = Dio();
    try {
      dio.options.headers = {
        HttpHeaders.acceptHeader: ' application/json',
        HttpHeaders.contentTypeHeader: 'application/json'
      };
      //print(image.path);
      dio.options.connectTimeout = 35000;
      Response response = await dio.get(
        url,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: ' application/json'
            }
        ),
      );
      print("this response");
      //print(response.statusCode);
      //print(response);
      //print("");
      //print("");
      //print(response.data);
      return response;
    } on DioError catch (e) {
      print(e?.response ?? "");
      return e.response != null ? e.response : null;
    }
  }

  Future<Response> createFavoriteproductRequest(CreateFavoriteProduct cfp) async{
    print("insode http");
    var url = baseUrl + "v1/api/products/create-fav-product";
    print(url);
    var dio = Dio();
    try {
      dio.options.headers = {
        HttpHeaders.acceptHeader: ' application/json',
        HttpHeaders.contentTypeHeader: 'application/json'
      };
      var body = jsonEncode(
          <String, dynamic>{
            "name": cfp.name,
            "ref": cfp.ref,
            "description": cfp.description,
            "estimatedPrice":cfp.estimatedPrice,
            "images": cfp.images,
            "ownerRef": cfp.ownerRef,
            "category": cfp.category,
            "favoriteOwnerRef": cfp.favoriteOwnerRef,
            "stores": cfp.stores,
            "verified": cfp.verified,
            "status": cfp.status
          }
      );
      print(body);
      //print(image.path);
      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: ' application/json'
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      print("");
      print("");
      print(response.data);
      return response;
    } on DioError catch (e) {
      print(e?.response ?? "");
      return e.response != null ? e.response : null;
    }
  }

  Future<Response> allFavProductsByUserRequest(String favUser) async{
    print("insode http");
    var url = baseUrl + "v1/api/products/all-user-fav-products";
    print(url);
    var dio = Dio();
    try {
      dio.options.headers = {
        HttpHeaders.acceptHeader: ' application/json',
        HttpHeaders.contentTypeHeader: 'application/json'
      };
      var body = jsonEncode(
          <String, dynamic>{
            "favUser": favUser
          }
      );
      print(body);
      //print(image.path);
      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: ' application/json'
            }
        ),
      );
      print("this response");
      //print(response.statusCode);
      //print(response);
      //print("");
      //print("");
      //print(response.data);
      return response;
    } on DioError catch (e) {
      print(e?.response ?? "");
      return e.response != null ? e.response : null;
    }
  }

  Future<Response> updateProductRequest(NewProduct np) async{
    print("insode http");
    var url = baseUrl + "v1/api/products/update-product";
    print(url);
    var dio = Dio();
    try {
      dio.options.headers = {
        HttpHeaders.acceptHeader: ' application/json',
        HttpHeaders.contentTypeHeader: 'application/json'
      };
      var body = jsonEncode(
          <String, dynamic>{
            "name": np.name,
            "description": np.description,
            "estimatedPrice": np.estimatedPrice,
            "category": np.category,
            "stores": np.stores
          }
      );

      print(body);
      //print(image.path);
      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: ' application/json'
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      print("");
      print("");
      print(response.data);
      return response;
    } on DioError catch (e) {
      print(e?.response ?? "");
      return e.response != null ? e.response : null;
    }
  }

  Future<dynamic> updateUserRequest(String userRef, String name, File image) async {
    print("inside http");
    var url = baseUrl + "v1/api/users/update-user";
    print(url);
    var dio = Dio();
    try {
      dio.options.headers = {
        HttpHeaders.acceptHeader: ' application/json',
        HttpHeaders.contentTypeHeader: 'application/json'
      };
      FormData formdata;
      if (image != null) {
        formdata = new FormData.fromMap({
          "userRef": userRef,
          "name": name,
          'image': await MultipartFile.fromFile(
              image.path, contentType: MediaType("image", "png"))
        });
      } else {
        formdata = new FormData.fromMap({
          "userRef": userRef,
          "name": name,
        });
      }
      print(image?.path ?? "");
      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: formdata,
        options: Options(contentType: 'multipart/form-data'),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      print("");
      print("");
      print(response.data);
      return response;
    } on DioError catch (e) {
      print(e?.response ?? "");
      return e.response != null ? e.response : null;
    }
  }

  Future<dynamic> userProfileRequest(String userRef, String email) async {
    print("inside http");
    var url = baseUrl + "v1/api/users/user-profile";

    print(url);
    var dio = Dio();
    try {
      dio.options.headers = {
        HttpHeaders.acceptHeader: ' application/json',
        HttpHeaders.contentTypeHeader: 'application/json'
      };
      var body = jsonEncode(
          <String, dynamic>{
            "userRef": userRef,
            "email": email
          }
      );
      print(body);
      //print(image.path);
      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: ' application/json'
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      print("");
      print("");
      print(response.data);
      return response;
    } on DioError catch (e) {
      print(e?.response ?? "");
      return e.response != null ? e.response : null;
    }
  }

  Future<Response> allProductsByUserRequest(String userRef) async{
    print("insode http");
    var url = baseUrl + "v1/api/products/all-user-products";
    print(url);
    var dio = Dio();
    try {
      dio.options.headers = {
        HttpHeaders.acceptHeader: ' application/json',
        HttpHeaders.contentTypeHeader: 'application/json'
      };
      var body = jsonEncode(
          <String, dynamic>{
            "userRef": userRef
          }
      );
      print(body);
      //print(image.path);
      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: ' application/json'
            }
        ),
      );
      print("this response");
     // print(response.statusCode);
      //print(response);
      print("");
      print("");
     // print(response.data);
      return response;
    } on DioError catch (e) {
      print(e?.response ?? "");
      return e.response != null ? e.response : null;
    }
  }

  Future<Response> allPromotionPackagesRequest() async{
    print("insode http");
    var url = baseUrl + "v1/api/promotion/all-promotions";
    print(url);
    var dio = Dio();
    try {
      dio.options.headers = {
        HttpHeaders.acceptHeader: ' application/json',
        HttpHeaders.contentTypeHeader: 'application/json'
      };

      //print(image.path);
      dio.options.connectTimeout = 35000;
      Response response = await dio.get(
        url,

        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: ' application/json'
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      print("");
      print("");
      print(response.data);
      return response;
    } on DioError catch (e) {
      print(e?.response ?? "");
      return e.response != null ? e.response : null;
    }
  }

  Future<Response> buyPromotionRequest(BuyPromotion bp) async{
    print("insode http");
    var url = baseUrl + "v1/api/promotion/buy-promotion-trans";
    print(url);
    var dio = Dio();
    try {
      dio.options.headers = {
        HttpHeaders.acceptHeader: ' application/json',
        HttpHeaders.contentTypeHeader: 'application/json'
      };
      var body = jsonEncode(
          <String, dynamic>{
            "promoRef": bp.promoRef,
            "productRef": bp.productRef,
            "ownerRef": bp.ownerRef,
            "name": bp.name,
            "transRef": bp.transRef,
            "price": bp.price,
            "type": bp.type,
            "clicks": bp.clicks,
            "reviewNumber": bp.reviewNumber,
            "subDuration": bp.subDuration
          }
      );

      print(body);
      //print(image.path);
      dio.options.connectTimeout = 35000;
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
            contentType: 'application/json',
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: ' application/json'
            }
        ),
      );
      print("this response");
      print(response.statusCode);
      print(response);
      print("");
      print("");
      print(response.data);
      return response;
    } on DioError catch (e) {
      print(e?.response ?? "");
      return e.response != null ? e.response : null;
    }
  }


}