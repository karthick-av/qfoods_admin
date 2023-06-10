class CategoryModel {
  int? categoryId;
  String? categoryName;
  String? image;
  String? thumbnailImage;


  CategoryModel(
      {this.categoryId,
      this.categoryName,
      this.image,
      this.thumbnailImage});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    image = json['image'];
    thumbnailImage = json['thumbnail_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['image'] = this.image;
    data['thumbnail_image'] = this.thumbnailImage;
 
    return data;
  }
}
