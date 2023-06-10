class CategoryDishesModel {
  int? dishId;
  int? restaurantId;
  String? name;
  String? image;
  int? price;
  int? salePrice;
  int? regularPrice;
  String? restaurantName;

  CategoryDishesModel(
      {this.dishId,
      this.restaurantId,
      this.name,
      this.image,
      this.price,
      this.salePrice,
      this.regularPrice,
      this.restaurantName});

  CategoryDishesModel.fromJson(Map<String, dynamic> json) {
    dishId = json['dish_id'];
    restaurantId = json['restaurant_id'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
    salePrice = json['sale_price'];
    regularPrice = json['regular_price'];
    restaurantName = json['restaurant_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dish_id'] = this.dishId;
    data['restaurant_id'] = this.restaurantId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['price'] = this.price;
    data['sale_price'] = this.salePrice;
    data['regular_price'] = this.regularPrice;
    data['restaurant_name'] = this.restaurantName;
    return data;
  }
}
