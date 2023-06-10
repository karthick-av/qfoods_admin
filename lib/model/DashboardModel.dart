class DashboardModel {
  TopDish? topDish;
  int? subTotal;
  int? grandTotal;
  TopRestaurant? topRestaurant;
  int? deliveryCharges;

  DashboardModel(
      {this.topDish,
      this.subTotal,
      this.grandTotal,
      this.topRestaurant,
      this.deliveryCharges});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    topDish = json['top_dish'] != null
        ? new TopDish.fromJson(json['top_dish'])
        : null;
    subTotal = json['sub_total'];
    grandTotal = json['grand_total'];
    topRestaurant = json['top_restaurant'] != null
        ? new TopRestaurant.fromJson(json['top_restaurant'])
        : null;
    deliveryCharges = json['delivery_charges'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.topDish != null) {
      data['top_dish'] = this.topDish!.toJson();
    }
    data['sub_total'] = this.subTotal;
    data['grand_total'] = this.grandTotal;
    if (this.topRestaurant != null) {
      data['top_restaurant'] = this.topRestaurant!.toJson();
    }
    data['delivery_charges'] = this.deliveryCharges;
    return data;
  }
}

class TopDish {
  String? name;
  int? count;
  int? price;
  String? restaurantName;

  TopDish({this.name, this.count, this.price, this.restaurantName});

  TopDish.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    count = json['count'];
    price = json['price'];
    restaurantName = json['restaurant_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['count'] = this.count;
    data['price'] = this.price;
    data['restaurant_name'] = this.restaurantName;
    return data;
  }
}

class TopRestaurant {
  int? count;
  String? restaurantName;

  TopRestaurant({this.count, this.restaurantName});

  TopRestaurant.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    restaurantName = json['restaurant_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['restaurant_name'] = this.restaurantName;
    return data;
  }
}
