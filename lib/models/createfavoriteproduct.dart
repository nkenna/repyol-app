

import 'package:repyol/models/storelisting.dart';

class CreateFavoriteProduct {
  String name;
  String ref;
  String description;
  String estimatedPrice;
  List<String> images;
  String ownerRef;
  String category;
  String favoriteOwnerRef;
  List<AddproductStoreListing> stores;
  bool verified;
  bool status;

  CreateFavoriteProduct(
      {this.name,
        this.ref,
        this.description,
        this.estimatedPrice,
        this.images,
        this.ownerRef,
        this.category,
        this.favoriteOwnerRef,
        this.stores,
        this.verified,
        this.status});

  CreateFavoriteProduct.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    ref = json['ref'];
    description = json['description'];
    estimatedPrice = json['estimatedPrice'];
    images = json['images'].cast<String>();
    ownerRef = json['ownerRef'];
    category = json['category'];
    favoriteOwnerRef = json['favoriteOwnerRef'];
    if(json['stores'] != null){
      stores = new List<AddproductStoreListing>();
      json['stores'].forEach((v) {
        stores.add(new AddproductStoreListing.fromJson(v));
      });
    }
    verified = json['verified'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['ref'] = this.ref;
    data['description'] = this.description;
    data['estimatedPrice'] = this.estimatedPrice;
    data['images'] = this.images;
    data['ownerRef'] = this.ownerRef;
    data['category'] = this.category;
    data['favoriteOwnerRef'] = this.favoriteOwnerRef;
    if(this.stores != null){
      data['stores'] = this.stores.map((v) => v.toJson()).toList();
    }
    data['verified'] = this.verified;
    data['status'] = this.status;
    return data;
  }
}