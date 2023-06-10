class RestaurantModel {
  int? restaurantId;
  String? restaurantName;
  String? shortDescription;
  String? description;
  String? image;
  String? address;
  String? phoneNumber;
  int? status;
  int? visible;
  String? password;

  RestaurantModel(
      {this.restaurantId,
      this.restaurantName,
      this.shortDescription,
      this.description,
      this.image,
      this.address,
      this.phoneNumber,
      this.status,
      this.visible,
      this.password});

  RestaurantModel.fromJson(Map<String, dynamic> json) {
    restaurantId = json['restaurant_id'];
    restaurantName = json['restaurant_name'];
    shortDescription = json['short_description'];
    description = json['description'];
    image = json['image'];
    address = json['address'];
    phoneNumber = json['phone_number'];
    status = json['status'];
    visible = json['visible'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['restaurant_id'] = this.restaurantId;
    data['restaurant_name'] = this.restaurantName;
    data['short_description'] = this.shortDescription;
    data['description'] = this.description;
    data['image'] = this.image;
    data['address'] = this.address;
    data['phone_number'] = this.phoneNumber;
    data['status'] = this.status;
    data['visible'] = this.visible;
    data['password'] = this.password;
    return data;
  }
}
