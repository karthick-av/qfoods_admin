class DeliveryPersonsModel {
  int? personId;
  String? name;
  String? image;
  int? phoneNumber;
  String? gender;
  String? password;

  DeliveryPersonsModel(
      {this.personId,
      this.name,
      this.image,
      this.phoneNumber,
      this.gender,
      this.password});

  DeliveryPersonsModel.fromJson(Map<String, dynamic> json) {
    personId = json['person_id'];
    name = json['name'];
    image = json['image'];
    phoneNumber = json['phone_number'];
    gender = json['gender'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['person_id'] = this.personId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['phone_number'] = this.phoneNumber;
    data['gender'] = this.gender;
    data['password'] = this.password;
    return data;
  }
}
