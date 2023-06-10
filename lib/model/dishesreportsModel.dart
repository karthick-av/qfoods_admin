class DishesReportsModel {
  String? count;
  String? name;
  String? restaurantName;

  DishesReportsModel({this.count, this.name, this.restaurantName});

  DishesReportsModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    name = json['name'];
    restaurantName = json['restaurant_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['name'] = this.name;
    data['restaurant_name'] = this.restaurantName;
    return data;
  }
}
