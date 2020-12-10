class BuyPromotion {
  String promoRef;
  String productRef;
  String ownerRef;
  String name;
  String transRef;
  int price;
  String type;
  int clicks;
  int reviewNumber;
  int subDuration;

  BuyPromotion(
      {this.promoRef,
        this.productRef,
        this.ownerRef,
        this.name,
        this.transRef,
        this.price,
        this.type,
        this.clicks,
        this.reviewNumber,
        this.subDuration});

  BuyPromotion.fromJson(Map<String, dynamic> json) {
    promoRef = json['promoRef'];
    productRef = json['productRef'];
    ownerRef = json['ownerRef'];
    name = json['name'];
    transRef = json['transRef'];
    price = json['price'];
    type = json['type'];
    clicks = json['clicks'];
    reviewNumber = json['reviewNumber'];
    subDuration = json['subDuration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['promoRef'] = this.promoRef;
    data['productRef'] = this.productRef;
    data['ownerRef'] = this.ownerRef;
    data['name'] = this.name;
    data['transRef'] = this.transRef;
    data['price'] = this.price;
    data['type'] = this.type;
    data['clicks'] = this.clicks;
    data['reviewNumber'] = this.reviewNumber;
    data['subDuration'] = this.subDuration;
    return data;
  }
}