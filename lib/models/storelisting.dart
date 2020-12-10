class AddproductStoreListing {
  String storeName;
  String storeLink;

  AddproductStoreListing({this.storeName, this.storeLink});

  AddproductStoreListing.fromJson(Map<String, dynamic> json) {
    storeName = json['storeName'];
    storeLink = json['storeLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['storeName'] = this.storeName;
    data['storeLink'] = this.storeLink;
    return data;
  }
}