class SearchProductModel {
  int? groceryId;
  String? name;
  String? image;
  int? price;
  int? regularPrice;
  int? salePrice;

  SearchProductModel(
      {this.groceryId,
      this.name,
      this.image,
      this.price,
      this.regularPrice,
      this.salePrice});

  SearchProductModel.fromJson(Map<String, dynamic> json) {
    groceryId = json['grocery_id'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['grocery_id'] = this.groceryId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['price'] = this.price;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    return data;
  }
}
