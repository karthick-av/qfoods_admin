class CouponModel {
  int? id;
  String? couponCode;
  int? amount;
  int? minimumAmount;
  int? maximumAmount;
  int? usageLimit;
  int? usageLimitPerUser;
  int? appliedCount;
  String? startTime;
  String? endTime;
  int? includeProduct;
  int? type;
  String? status;
  List<Items>? items;

  CouponModel(
      {this.id,
      this.couponCode,
      this.amount,
      this.minimumAmount,
      this.maximumAmount,
      this.appliedCount,
      this.usageLimit,
      this.usageLimitPerUser,
      this.startTime,
      this.endTime,
      this.includeProduct,
      this.type,
      this.status,
      this.items});

  CouponModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    couponCode = json['coupon_code'];
    amount = json['amount'];
    minimumAmount = json['minimum_amount'];
    maximumAmount = json['maximum_amount'];
    usageLimit = json['usage_limit'];
    usageLimitPerUser = json['usage_limit_per_user'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    includeProduct = json['include_product'];
    type = json['type'];
    appliedCount = json['applied_count'];
    status = json['status'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['coupon_code'] = this.couponCode;
    data['amount'] = this.amount;
    data['minimum_amount'] = this.minimumAmount;
    data['maximum_amount'] = this.maximumAmount;
    data['usage_limit'] = this.usageLimit;
    data['usage_limit_per_user'] = this.usageLimitPerUser;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['applied_count'] = this.appliedCount;
    data['include_product'] = this.includeProduct;
    data['type'] = this.type;
    data['status'] = this.status;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? id;
  String? name;
  String? image;
  int? price;
  int? dishId;
  int? salePrice;
  int? regularPrice;
  int? restaurantId;
  String? restaurantName;

  Items(
      {this.id,
      this.name,
      this.image,
      this.price,
      this.dishId,
      this.salePrice,
      this.regularPrice,
      this.restaurantId,
      this.restaurantName});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
    dishId = json['dish_id'];
    salePrice = json['sale_price'];
    regularPrice = json['regular_price'];
    restaurantId = json['restaurant_id'];
    restaurantName = json['restaurant_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['price'] = this.price;
    data['dish_id'] = this.dishId;
    data['sale_price'] = this.salePrice;
    data['regular_price'] = this.regularPrice;
    data['restaurant_id'] = this.restaurantId;
    data['restaurant_name'] = this.restaurantName;
    return data;
  }
}


