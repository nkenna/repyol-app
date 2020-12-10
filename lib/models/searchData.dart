class SearchData {
  String query;

  SearchData({this.query});

  SearchData.fromJson(Map<String, dynamic> json) {
    query = json['query'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['query'] = this.query;
    return data;
  }
}