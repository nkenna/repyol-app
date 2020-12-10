

import 'package:repyol/models/storelisting.dart';
import 'package:repyol/models/user.dart';

class Product {
  String sId;
  List<String> images;
  String name;
  String ref;
  String description;
  int estimatedPrice;
  String ownerRef;
  String category;
  List<AddproductStoreListing> stores; // editable
  bool verified;
  bool status;
  String createdAt;
  String updatedAt;
  int iV;
  List<Reviews> reviews;
  List<Promotiontrans> promotiontrans;
  bool fav = false;

  Product(
      {this.sId,
        this.images,
        this.name,
        this.ref,
        this.description,
        this.estimatedPrice,
        this.ownerRef,
        this.category,
        this.stores,
        this.verified,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.reviews,
        this.fav,
        this.promotiontrans});

  Product.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    images = json['images'].cast<String>();
    name = json['name'];
    ref = json['ref'];
    description = json['description'];
    estimatedPrice = json['estimatedPrice'];
    ownerRef = json['ownerRef'];
    category = json['category'];
    if(json['stores'] != null){
      stores = new List<AddproductStoreListing>();
      json['stores'].forEach((v) {
        stores.add(new AddproductStoreListing.fromJson(v));
      });
    }
    verified = json['verified'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    if (json['reviews'] != null) {
      reviews = new List<Reviews>();
      json['reviews'].forEach((v) {
        reviews.add(new Reviews.fromJson(v));
      });
    }
    if (json['promotiontrans'] != null) {
      promotiontrans = new List<Promotiontrans>();
      json['promotiontrans'].forEach((v) {
        promotiontrans.add(new Promotiontrans.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['images'] = this.images;
    data['name'] = this.name;
    data['ref'] = this.ref;
    data['description'] = this.description;
    data['estimatedPrice'] = this.estimatedPrice;
    data['ownerRef'] = this.ownerRef;
    data['category'] = this.category;
    data['stores'] = this.stores;
    data['verified'] = this.verified;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.reviews != null) {
      data['reviews'] = this.reviews.map((v) => v.toJson()).toList();
    }
    if (this.promotiontrans != null) {
      data['promotiontrans'] =
          this.promotiontrans.map((v) => v.toJson()).toList();
    }
    if(this.stores != null){
      data['stores'] = this.stores.map((v) => v.toJson()).toList();
    }
    return data;
  }
}





class Promotiontrans {
  String sId;
  String name;
  String ref;
  String transRef;
  String transDate;
  int price;
  String type;
  int clicks;
  String promoRef;
  String productRef;
  String ownerRef;
  bool status;
  String createdAt;
  String updatedAt;
  int iV;

  Promotiontrans(
      {this.sId,
        this.name,
        this.ref,
        this.transRef,
        this.transDate,
        this.price,
        this.type,
        this.clicks,
        this.promoRef,
        this.productRef,
        this.ownerRef,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Promotiontrans.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    ref = json['ref'];
    transRef = json['transRef'];
    transDate = json['transDate'];
    price = json['price'];
    type = json['type'];
    clicks = json['clicks'];
    promoRef = json['promoRef'];
    productRef = json['productRef'];
    ownerRef = json['ownerRef'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['ref'] = this.ref;
    data['transRef'] = this.transRef;
    data['transDate'] = this.transDate;
    data['price'] = this.price;
    data['type'] = this.type;
    data['clicks'] = this.clicks;
    data['promoRef'] = this.promoRef;
    data['productRef'] = this.productRef;
    data['ownerRef'] = this.ownerRef;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}



class Reviews {
  String sId;
  String content;
  String reviewerRef;
  String reviewedRef;
  double rating;
  String createdAt;
  String updatedAt;
  User user;

  Reviews(
      {this.sId,
        this.content,
        this.reviewerRef,
        this.reviewedRef,
        this.rating,
        this.createdAt,
        this.updatedAt,
        this.user});

  Reviews.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    content = json['content'];
    reviewerRef = json['reviewerRef'];
    reviewedRef = json['reviewedRef'];
    rating = json['rating'].toDouble();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['content'] = this.content;
    data['reviewerRef'] = this.reviewerRef;
    data['reviewedRef'] = this.reviewedRef;
    data['rating'] = this.rating;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

