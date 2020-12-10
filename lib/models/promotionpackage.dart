class PromotionPackage {
  String name;
  String ref;
  int price;
  String type;
  int clicks;
  int reviewNumber;
  int subDuration;
  String createdAt;
  String updatedAt;
  String id;

  PromotionPackage(
      {this.name,
        this.ref,
        this.price,
        this.type,
        this.clicks,
        this.reviewNumber,
        this.subDuration,
        this.createdAt,
        this.updatedAt,
        this.id});

  PromotionPackage.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    ref = json['ref'];
    price = json['price'];
    type = json['type'];
    clicks = json['clicks'];
    reviewNumber = json['reviewNumber'];
    subDuration = json['subDuration'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['ref'] = this.ref;
    data['price'] = this.price;
    data['type'] = this.type;
    data['clicks'] = this.clicks;
    data['reviewNumber'] = this.reviewNumber;
    data['subDuration'] = this.subDuration;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['id'] = this.id;
    return data;
  }
}