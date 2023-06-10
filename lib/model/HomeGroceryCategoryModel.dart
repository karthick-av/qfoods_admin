class HomeGroceryCategoryModel {
  int? categoryId;
  String? categoryName;
  String? image;
  String? thumbnailImage;
  int? visible;
  int? orderBy;
  int? id;

  HomeGroceryCategoryModel(
      {this.categoryId,
      this.categoryName,
      this.image,
      this.thumbnailImage,
      this.visible,
      this.orderBy,
      this.id});

  HomeGroceryCategoryModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    image = json['image'];
    thumbnailImage = json['thumbnail_image'];
    visible = json['visible'];
    orderBy = json['order_by'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['image'] = this.image;
    data['thumbnail_image'] = this.thumbnailImage;
    data['visible'] = this.visible;
    data['order_by'] = this.orderBy;
    data['id'] = this.id;
    return data;
  }
}
