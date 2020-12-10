import 'dart:io';

import 'package:repyol/models/storelisting.dart';


class NewProduct {
  List<File> images;
  List<String> imageFiles;
  String name;
  String description;
  String ownerRef;
  String category;
  List<AddproductStoreListing> stores;
  int estimatedPrice;
  String ref;
  bool isUpdate = false;

  NewProduct({this.images, this.name, this.description, this.ownerRef,
      this.category, this.stores, this.estimatedPrice, this.ref, this.imageFiles, this.isUpdate});

  @override
  String toString() {
    return 'NewProduct{images: $images, name: $name, description: $description, ownerRef: $ownerRef, category: $category, stores: $stores, estimatedPrice: $estimatedPrice}';
  }
}