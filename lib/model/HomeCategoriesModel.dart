class HomeCategoryModel {
  int? categoryId;
  String? categoryName;
  String? image;
  String? thumbnailImage;
  String? dateCreated;
  String? dateModified;
  int? visible;
  int? orderBy;
  int? id;

  HomeCategoryModel(
      {this.categoryId,
      this.categoryName,
      this.image,
      this.thumbnailImage,
      this.dateCreated,
      this.dateModified,
      this.visible,
      this.id,
      this.orderBy});

  HomeCategoryModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    image = json['image'];
    thumbnailImage = json['thumbnail_image'];
    dateCreated = json['date_created'];
    dateModified = json['date_modified'];
    visible = json['visible'];
    orderBy = json['order_by'];
    id = json["id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['image'] = this.image;
    data['thumbnail_image'] = this.thumbnailImage;
    data['date_created'] = this.dateCreated;
    data['date_modified'] = this.dateModified;
    data['visible'] = this.visible;
    data['order_by'] = this.orderBy;
    data['id'] = this.id;
    return data;
  }
}
