class DeliveryChargesModel {
  int? id;
  int? minKms;
  int? maxKms;
  int? price;

  DeliveryChargesModel({this.id, this.minKms, this.maxKms, this.price});

  DeliveryChargesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    minKms = json['min_kms'];
    maxKms = json['max_kms'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['min_kms'] = this.minKms;
    data['max_kms'] = this.maxKms;
    data['price'] = this.price;
    return data;
  }
}
