import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:get/get.dart';

import 'package:path/path.dart';
import 'package:repyol/helpers/controlloader.dart';
import 'package:repyol/helpers/httpservice.dart';
import 'package:repyol/helpers/sharedprefs.dart';
import 'package:repyol/models/category.dart';
import 'package:repyol/models/createfavoriteproduct.dart';
import 'package:repyol/models/newproduct.dart';
import 'package:repyol/models/product.dart';
import 'package:repyol/models/searchData.dart';
import 'package:repyol/models/user.dart';
import 'package:repyol/screens/products/searchproductlistscreen.dart';

class ProductsProvider extends ChangeNotifier {
  final HttpService httpService = new HttpService();
  final uploader = FlutterUploader();
  List<Product> _allProducts = List<Product>();
  List<Product> _allCategoryProducts = List<Product>();
  List<Product> _allUserProducts = List<Product>();
  List<Product> _allFavProducts = List<Product>();
  List<Product> _allSearchProducts = List<Product>();
  List<Product> _allNewProducts = List<Product>();
  List<Product> _allPromotedProducts = List<Product>();
  List<Category> _allCategories = List<Category>();
  List<Reviews> _allReviews = List<Reviews>();
  List<String> _searches = List<String>();
  List<User> _reviewUsers = List<User>();
  Product _selectedProduct;
  Reviews _selectedReview;
  NewProduct _newProduct;

  Reviews get selectedReview => _selectedReview;
  List<Reviews> get allReviews => _allReviews;
  Product get selectProduct => _selectedProduct;
  List<Product> get allProducts => _allProducts;
  List<Product> get allSearchProducts => _allSearchProducts;
  List<Product> get allNewProducts => _allNewProducts;
  List<Product> get allPromotedProducts => _allPromotedProducts;
  List<Product> get allUserProducts => _allUserProducts;
  List<Product> get allFavProducts => _allFavProducts;
  List<Product> get allCategoryProducts => _allCategoryProducts;
  List<Category> get allCategories => _allCategories;
  List<User> get reviewUsers => _reviewUsers;
  List<String> get searches => _searches;
  NewProduct get newProduct => _newProduct;

  void setSelectedReview(Reviews rev) {
    _selectedReview = rev;
    notifyListeners();
  }

  populateReviewUsers() {
    if (_allReviews != null && _allReviews.isNotEmpty) {
      _allReviews.forEach((element) {
        if (element != null) {
          _reviewUsers.add(element.user);
        }
      });
    }
    notifyListeners();
  }

  void addSearch(String data) {
    if (data != null && data.isNotEmpty) {
      _searches.add(data);
      notifyListeners();
    }
  }

  void saveDataSearch() {
    SharedPrefs.instance.saveSearch(_searches);
  }

  retrieveDataSearch() async {
    _searches = await SharedPrefs.instance.retrieveSearch();
    if (_searches == null) {
      _searches = List<String>();
    }

    notifyListeners();
  }

  Future<bool> checkFavorite(Product p, List<Product> pps) async {
    bool ps = false;
    for (var i = 0; i < pps.length; i++) {
      //print("is inside");
      //print(p.ref);
      //print(pps[i].ref);
      print(pps[i].ref == p.ref);
      if (pps[i].ref == p.ref) {
        //pps[i].fav = true;
        ps = true;
        //notifyListeners();
        break;
      }
    }

    return ps;
  }

  void setNewProduct(NewProduct np) {
    _newProduct = np;
  }

  void setSelectedProduct(Product product) {
    _selectedProduct = product;
  }

  double calcAverageRating(Product pp) {
    if (pp.reviews.isNotEmpty) {
      return pp.reviews.map((m) => m.rating).reduce((a, b) => a + b) /
          pp.reviews.length;
    } else {
      return 0.0;
    }
  }

  getAllCategories() async {
    //showLoader("loading...");
    final response = await httpService.allCategoriesRequest();

    if (response == null) {
      dismissLoader();
      showErrorLoader("Network error. Try again.");
      return;
    }
    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    if (payload['status'] == 'success' && statusCode == 200) {
      List<Category> cats = new List<Category>();
      var data = payload['categories'];
      for (var i = 0; i < data.length; i++) {
        try {
          Category cat = Category.fromJson(data[i]);
          cats.add(cat);
        } catch (e) {
          print(e);
        }
      }
      _allCategories = cats;
      notifyListeners();

      //dismissLoader();
    } else if (payload['status'] == 'failed' && statusCode == 500) {
      dismissLoader();
      showErrorLoader(payload['message']);
    } else {
      dismissLoader();
      showErrorLoader("unknown error occurred authenicating user");
    }
  }

  getAllProducts() async {
    //showLoader("loading...");
    final response = await httpService.allProductsRequest();

    if (response == null) {
      //dismissLoader();
      showErrorLoader("Network error. Try again.");
      return;
    }
    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    if (payload['status'] == 'success' && statusCode == 200) {
      List<Product> cats = new List<Product>();
      List<Product> catsPromo = new List<Product>();
      var data = payload['products'];
      for (var i = 0; i < data.length; i++) {
        try {
          Product cat = Product.fromJson(data[i]);
          cats.add(cat);
          if (cat.promotiontrans.length > 0) {
            catsPromo.add(cat);
          }
        } catch (e) {
          print(e);
        }
      }
      _allProducts = cats;
      if (catsPromo.length == 0) {
        _allProducts.shuffle();
        _allPromotedProducts = cats;
      } else {
        _allPromotedProducts = catsPromo;
      }

      notifyListeners();

      //dismissLoader();
    } else if (payload['status'] == 'failed' && statusCode == 500) {
      dismissLoader();
      showErrorLoader(payload['message']);
    } else {
      dismissLoader();
      showErrorLoader("unknown error occurred authenicating user");
    }
  }

  createReview(String content, double rating, String reviewerRef,
      String reviewedRef) async {
    showLoader("loading...");
    final response = await httpService.createReviewRequest(
        content, rating, reviewerRef, reviewedRef);

    if (response == null) {
      dismissLoader();
      showErrorLoader("Network error. Try again.");
      return;
    }
    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    if (payload['status'] == 'success' && statusCode == 200) {
      dismissLoader();
      productReviews(_selectedProduct.ref ?? "");
    } else if (payload['status'] == 'failed' && statusCode == 500) {
      dismissLoader();
      showErrorLoader(payload['message']);
    } else {
      dismissLoader();
      showErrorLoader("unknown error occurred authenicating user");
    }
  }

  editReview(String id, String content) async {
    showLoader("loading...");
    final response = await httpService.editReviewRequest(id, content);

    if (response == null) {
      dismissLoader();
      showErrorLoader("Network error. Try again.");
      return;
    }
    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    if (payload['status'] == 'success' && statusCode == 200) {
      dismissLoader();
      productReviews(_selectedProduct.ref ?? "");
    } else if (payload['status'] == 'failed' && statusCode == 500) {
      dismissLoader();
      showErrorLoader(payload['message']);
    } else {
      dismissLoader();
      showErrorLoader("unknown error occurred authenicating user");
    }
  }

  mentionUser(Map<String, dynamic> user, String mentionedBy, String prodRef) async {
    //showLoader("loading...");
    String userRef = user['ref'] ?? "";
    print("user ref to use: ${userRef}");
    final response = await httpService.mentionUserRequest(userRef, mentionedBy, prodRef);

    if (response == null) {
      //dismissLoader();
      //showErrorLoader("Network error. Try again.");
      return;
    }
    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    if (payload['status'] == 'success' && statusCode == 200) {
      //dismissLoader();
      //productReviews(_selectedProduct.ref ?? "");
    } else if (payload['status'] == 'failed' && statusCode == 500) {
      //dismissLoader();
      //showErrorLoader(payload['message']);
    } else if (payload['status'] == 'failed' && statusCode == 404) {
      //dismissLoader();
      //showErrorLoader(payload['message']);
    } else {
      //dismissLoader();
      //showErrorLoader("unknown error occurred authenicating user");
    }
  }



  productReviews(String prodRef) async {
    showLoader("loading...");
    final response = await httpService.productReviewsRequest(prodRef);

    if (response == null) {
      dismissLoader();
      showErrorLoader("Network error. Try again.");
      return;
    }
    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);
    //reviews

    if (payload['status'] == 'success' && statusCode == 200) {
      List<Reviews> cats = new List<Reviews>();
      var data = payload['reviews'];
      print(data.length);
      for (var i = 0; i < data.length; i++) {
        try {
          Reviews cat = Reviews.fromJson(data[i]);
          cats.add(cat);
        } catch (e) {
          print(e);
        }
      }
      _allReviews = cats;
      _selectedProduct.reviews = _allReviews;

      dismissLoader();
      notifyListeners();
    } else if (payload['status'] == 'failed' && statusCode == 500) {
      dismissLoader();
      showErrorLoader(payload['message']);
    } else {
      dismissLoader();
      showErrorLoader("unknown error occurred authenicating user");
    }
  }

  getAllProductsByCategory(String categoryName) async {
    showLoader("loading...");
    final response =
        await httpService.allProductsByCategoryRequest(categoryName);

    if (response == null) {
      dismissLoader();
      showErrorLoader("Network error. Try again.");
      return;
    }
    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    if (payload['status'] == 'success' && statusCode == 200) {
      List<Product> cats = new List<Product>();
      var data = payload['products'];
      for (var i = 0; i < data.length; i++) {
        try {
          Product cat = Product.fromJson(data[i]);
          cats.add(cat);
        } catch (e) {
          print(e);
        }
      }
      _allCategoryProducts = cats;
      notifyListeners();

      dismissLoader();
    } else if (payload['status'] == 'failed' && statusCode == 500) {
      dismissLoader();
      showErrorLoader(payload['message']);
    } else {
      dismissLoader();
      showErrorLoader("unknown error occurred during operation");
    }
  }

  getAllProductsBySearch(String name) async {
    showLoader("loading...");
    final response = await httpService.productSearchRequest(name);

    if (response == null) {
      dismissLoader();
      showErrorLoader("Network error. Try again.");
      return;
    }
    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    if (payload['status'] == 'success' && statusCode == 200) {
      List<Product> cats = new List<Product>();
      var data = payload['products'];
      for (var i = 0; i < data.length; i++) {
        try {
          Product cat = Product.fromJson(data[i]);
          cats.add(cat);
        } catch (e) {
          print(e);
        }
      }
      _allSearchProducts = cats;
      Get.to(SearchProductListScreen());
      //notifyListeners();

      dismissLoader();
    } else if (payload['status'] == 'failed' && statusCode == 500) {
      dismissLoader();
      showErrorLoader(payload['message']);
    } else {
      dismissLoader();
      showErrorLoader("unknown error occurred during operation");
    }
  }

  getNewProducts() async {
    //showLoader("loading...");
    final response = await httpService.getNewProductsRequest();

    if (response == null) {
      dismissLoader();
      showErrorLoader("Network error. Try again.");
      return;
    }
    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    if (payload['status'] == 'success' && statusCode == 200) {
      List<Product> cats = new List<Product>();
      var data = payload['products'];
      for (var i = 0; i < data.length; i++) {
        try {
          Product cat = Product.fromJson(data[i]);
          cats.add(cat);
        } catch (e) {
          print(e);
        }
      }
      _allNewProducts = cats;
      // Get.to(SearchProductListScreen());
      notifyListeners();

      //dismissLoader();
    } else if (payload['status'] == 'failed' && statusCode == 500) {
      dismissLoader();
      showErrorLoader(payload['message']);
    } else {
      dismissLoader();
      showErrorLoader("unknown error occurred during operation");
    }
  }

  createNewProduct(String userRef) async {
    print(userRef);
    print(_newProduct.images.length);
    List<FileItem> fileItems = new List<FileItem>();
    for (var i = 0; i < _newProduct.images.length; i++) {
      if (_newProduct.images[i].existsSync()) {
        var fileItem = new FileItem(
            savedDir: dirname(_newProduct.images[i].path),
            filename: basename(_newProduct.images[i].path),
            fieldname: "images");
        print(fileItem.toString());
        fileItems.add(fileItem);
      }
    }
    print("file items length");
    print(fileItems.length);
    final taskId = await uploader.enqueue(
        url:
            "https://talkaboutserver.herokuapp.com/v1/api/products/create-product", //required: url to upload to
        files: fileItems, // required: list of files that you want to upload
        method: UploadMethod.POST, // HTTP method  (POST or PUT or PATCH)
        headers: {
          HttpHeaders.acceptHeader: ' application/json',
          HttpHeaders.contentTypeHeader: 'application/json'
        },
        data: {
          "name": _newProduct.name,
          "description": _newProduct.description,
          "ownerRef": userRef,
          "category": _newProduct.category,
          "estimatedPrice": _newProduct.estimatedPrice.toString() ?? ""
        }, // any data you want to send in upload request
        showNotification:
            true, // send local notification (android only) for upload status
        tag:
            "${DateTime.now().millisecondsSinceEpoch}"); // unique tag for upload task
    print(taskId);

    uploader.progress.listen((progress) {
      //... code to handle progress
      print("the progress::::::::::::::::::::::::::::::::::");
      //UploadTaskStatus.
      print(progress.status);
      print(progress.status.value);
      print(progress.progress);
    }).onDone(() {});

    uploader.result.listen((result) {
      //... code to handle result
      print("the response:::::::::::::::::::::::::::::::::");
      print(result.response);

      print(result.status);
      print(result.status.description);
      print(result.status.value);

      var payload = jsonDecode(result.response);
      if (payload['status'] == "success" && result.status.value == 3) {
        showMessage("product creation have been completed");
      } else {
        showDialog(createNewProduct(userRef));
      }
    }, onError: (ex, stacktrace) {
      // ... code to handle error
    });
  }

  updateProduct() async {
    showLoader("loading...");
    final response = await httpService.updateProductRequest(_newProduct);

    if (response == null) {
      dismissLoader();
      showErrorLoader("Network error. Try again.");
      return;
    }
    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    if (payload['status'] == 'success' && statusCode == 200) {
      //Get.off(LandingScreen());
      Future.delayed(Duration(seconds: 5), () {
        dismissLoader();
        //Get.off(LandingScreen());
      });
    } else if (payload['status'] == 'failed' && statusCode == 500) {
      dismissLoader();
      showErrorLoader(payload['message']);
    } else {
      dismissLoader();
      showErrorLoader("unknown error occurred during operation");
    }
  }

  createFavoriteProduct(CreateFavoriteProduct cfp) async {
    showLoader("loading...");
    final response = await httpService.createFavoriteproductRequest(cfp);

    if (response == null) {
      dismissLoader();
      showErrorLoader("Network error. Try again.");
      return;
    }
    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    if (payload['status'] == 'success' && statusCode == 200) {
      dismissLoader();
    } else if (payload['status'] == 'failed' && statusCode == 500) {
      dismissLoader();
      showErrorLoader(payload['message']);
    } else if (payload['status'] == 'failed' && statusCode == 400) {
      dismissLoader();
      showErrorLoader(payload['message']);
    } else {
      dismissLoader();
      showErrorLoader("unknown error occurred creating favorite product");
    }
  }

  getAllFavProductsByUser(String favUser) async {
    //showLoader("loading...");
    final response = await httpService.allFavProductsByUserRequest(favUser);

    if (response == null) {
      dismissLoader();
      showErrorLoader("Network error. Try again.");
      return;
    }
    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    if (payload['status'] == 'success' && statusCode == 200) {
      List<Product> cats = new List<Product>();
      var data = payload['products'];
      for (var i = 0; i < data.length; i++) {
        try {
          Product cat = Product.fromJson(data[i]);
          cats.add(cat);
        } catch (e) {
          print(e);
        }
      }
      _allFavProducts = cats;
      notifyListeners();

      //dismissLoader();
    } else if (payload['status'] == 'failed' && statusCode == 500) {
      dismissLoader();
      showErrorLoader(payload['message']);
    } else {
      dismissLoader();
      showErrorLoader("unknown error occurred during operation");
    }
  }

  getAllProductsByUser(String userRef) async {
    showLoader("loading...");
    final response = await httpService.allProductsByUserRequest(userRef);

    if (response == null) {
      dismissLoader();
      showErrorLoader("Network error. Try again.");
      return;
    }
    int statusCode = response.statusCode;
    var payload = response.data;
    print(response);
    print(payload);

    if (payload['status'] == 'success' && statusCode == 200) {
      List<Product> cats = new List<Product>();
      var data = payload['products'];
      for (var i = 0; i < data.length; i++) {
        try {
          Product cat = Product.fromJson(data[i]);
          cats.add(cat);
        } catch (e) {
          print(e);
        }
      }
      _allUserProducts = cats;
      notifyListeners();

      dismissLoader();
    } else if (payload['status'] == 'failed' && statusCode == 500) {
      dismissLoader();
      showErrorLoader(payload['message']);
    } else {
      dismissLoader();
      showErrorLoader("unknown error occurred during operation");
    }
  }
}
