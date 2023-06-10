class HomeGroceryTagModel {
  int? tagId;
  String? tagName;
  String? image;
  String? thumbnailImage;
  int? visible;
  int? orderBy;
  int? id;

  HomeGroceryTagModel(
      {this.tagId,
      this.tagName,
      this.image,
      this.thumbnailImage,
      this.visible,
      this.orderBy,
      this.id});

  HomeGroceryTagModel.fromJson(Map<String, dynamic> json) {
    tagId = json['tag_id'];
    tagName = json['tag_name'];
    image = json['image'];
    thumbnailImage = json['thumbnail_image'];
    visible = json['visible'];
    orderBy = json['order_by'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag_id'] = this.tagId;
    data['tag_name'] = this.tagName;
    data['image'] = this.image;
    data['thumbnail_image'] = this.thumbnailImage;
    data['visible'] = this.visible;
    data['order_by'] = this.orderBy;
    data['id'] = this.id;
    return data;
  }
}
