class User {
  String name;
  String email;
  bool status;
  String ref;
  String createdAt;
  String updatedAt;
  String image;
  String id;

  User(
      {this.name,
        this.email,
        this.status,
        this.ref,
        this.createdAt,
        this.updatedAt,
        this.image,
        this.id});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    status = json['status'];
    ref = json['ref'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    image = json['image'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['status'] = this.status;
    data['ref'] = this.ref;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['image'] = this.image;
    data['id'] = this.id;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'ref': ref,
      'image': image ?? "",
    };
  }

  @override
  String toString() {
    return 'User{name: $name, email: $email, status: $status, ref: $ref, createdAt: $createdAt, updatedAt: $updatedAt, image: $image, id: $id}';
  }
}