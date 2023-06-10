class RestaurantsReportsModel {
  String? count;
  String? restaurantName;

  RestaurantsReportsModel({this.count, this.restaurantName});

  RestaurantsReportsModel.fromJson(Map<String, dynamic> json) {
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
