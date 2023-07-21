class GroceryCouponModel {
  int? id;
  String? couponCode;
  int? amount;
  int? minimumAmount;
  int? maximumAmount;
  int? usageLimit;
  int? usageLimitPerUser;
  String? startTime;
  String? endTime;
  int? includeProduct;
  int? type;
  String? status;
  int? appliedCount;
  List<Items>? items;

  GroceryCouponModel(
      {this.id,
      this.couponCode,
      this.amount,
      this.minimumAmount,
      this.maximumAmount,
      this.usageLimit,
      this.usageLimitPerUser,
      this.startTime,
      this.endTime,
      this.includeProduct,
      this.type,
      this.status,
      this.appliedCount,
      this.items});

  GroceryCouponModel.fromJson(Map<String, dynamic> json) {
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
    status = json['status'];
    appliedCount = json['applied_count'];
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
    data['include_product'] = this.includeProduct;
    data['type'] = this.type;
    data['status'] = this.status;
    data['applied_count'] = this.appliedCount;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? name;
  String? image;
  int? price;
  int? groceryId;
  int? salePrice;
  int? regularPrice;

  Items(
      {this.name,
      this.image,
      this.price,
      this.groceryId,
      this.salePrice,
      this.regularPrice});

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    price = json['price'];
    groceryId = json['grocery_id'];
    salePrice = json['sale_price'];
    regularPrice = json['regular_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['price'] = this.price;
    data['grocery_id'] = this.groceryId;
    data['sale_price'] = this.salePrice;
    data['regular_price'] = this.regularPrice;
    return data;
  }
}
