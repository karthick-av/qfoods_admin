class GroceryDashboardModel {
  int? subTotal;
  TopBrand? topBrand;
  int? grandTotal;
  TopCategory? topCategory;
  TopProducts? topProducts;
  int? deliveryCharges;

  GroceryDashboardModel(
      {this.subTotal,
      this.topBrand,
      this.grandTotal,
      this.topCategory,
      this.topProducts,
      this.deliveryCharges});

  GroceryDashboardModel.fromJson(Map<String, dynamic> json) {
    subTotal = json['sub_total'];
    topBrand = json['top_brand'] != null
        ? new TopBrand.fromJson(json['top_brand'])
        : null;
    grandTotal = json['grand_total'];
    topCategory = json['top_category'] != null
        ? new TopCategory.fromJson(json['top_category'])
        : null;
    topProducts = json['top_products'] != null
        ? new TopProducts.fromJson(json['top_products'])
        : null;
    deliveryCharges = json['delivery_charges'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sub_total'] = this.subTotal;
    if (this.topBrand != null) {
      data['top_brand'] = this.topBrand!.toJson();
    }
    data['grand_total'] = this.grandTotal;
    if (this.topCategory != null) {
      data['top_category'] = this.topCategory!.toJson();
    }
    if (this.topProducts != null) {
      data['top_products'] = this.topProducts!.toJson();
    }
    data['delivery_charges'] = this.deliveryCharges;
    return data;
  }
}

class TopBrand {
  int? count;
  String? brandName;

  TopBrand({this.count, this.brandName});

  TopBrand.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    brandName = json['brand_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['brand_name'] = this.brandName;
    return data;
  }
}

class TopCategory {
  int? count;
  String? categoryName;

  TopCategory({this.count, this.categoryName});

  TopCategory.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['category_name'] = this.categoryName;
    return data;
  }
}

class TopProducts {
  String? name;
  int? count;
  int? price;

  TopProducts({this.name, this.count, this.price});

  TopProducts.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    count = json['count'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['count'] = this.count;
    data['price'] = this.price;
    return data;
  }
}
