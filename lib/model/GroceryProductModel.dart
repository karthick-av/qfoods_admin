class GroceryProductModel {
  int? groceryId;
  String? name;
  String? description;
  int? price;
  int? regularPrice;
  int? salePrice;
  int? combo;
  String? comboDescription;
  String? weight;
  String? image;
  int? offers;
  int? variants;
  int? status;
  int? visible;
  String? keywords;
  List<Brands>? brands;
  List<Category>? category;
  List<Types>? types;
  List<VariantItems>? variantItems;

  GroceryProductModel(
      {this.groceryId,
      this.name,
      this.description,
      this.price,
      this.regularPrice,
      this.salePrice,
      this.combo,
      this.comboDescription,
      this.weight,
      this.image,
      this.offers,
      this.variants,
      this.status,
      this.keywords,
      this.visible,
      this.brands,
      this.category,
      this.types,
      this.variantItems});

  GroceryProductModel.fromJson(Map<String, dynamic> json) {
    groceryId = json['grocery_id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    combo = json['combo'];
    comboDescription = json['combo_description'];
    weight = json['weight'];
    image = json['image'];
    offers = json['offers'];
    variants = json['variants'];
    status = json['status'];
    visible = json['visible'];
    keywords = json['keywords'];
    if (json['brands'] != null) {
      brands = <Brands>[];
      json['brands'].forEach((v) {
        brands!.add(new Brands.fromJson(v));
      });
    }
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(new Category.fromJson(v));
      });
    }
    if (json['types'] != null) {
      types = <Types>[];
      json['types'].forEach((v) {
        types!.add(new Types.fromJson(v));
      });
    }
    if (json['variant_items'] != null) {
      variantItems = <VariantItems>[];
      json['variant_items'].forEach((v) {
        variantItems!.add(new VariantItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['grocery_id'] = this.groceryId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['regular_price'] = this.regularPrice;
    data['sale_price'] = this.salePrice;
    data['combo'] = this.combo;
    data['combo_description'] = this.comboDescription;
    data['weight'] = this.weight;
    data['image'] = this.image;
    data['offers'] = this.offers;
    data['variants'] = this.variants;
    data['status'] = this.status;
    data['visible'] = this.visible;
    data['keywords'] = this.keywords;
    if (this.brands != null) {
      data['brands'] = this.brands!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    if (this.types != null) {
      data['types'] = this.types!.map((v) => v.toJson()).toList();
    }
    if (this.variantItems != null) {
      data['variant_items'] =
          this.variantItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Brands {
  String? image;
  int? brandId;
  String? brandName;

  Brands({this.image, this.brandId, this.brandName});

  Brands.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    brandId = json['brand_id'];
    brandName = json['brand_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['brand_id'] = this.brandId;
    data['brand_name'] = this.brandName;
    return data;
  }
}

class Category {
  String? image;
  int? categoryId;
  String? categoryName;

  Category({this.image, this.categoryId, this.categoryName});

  Category.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    return data;
  }
}

class Types {
  String? image;
  int? typeId;
  String? typeName;

  Types({this.image, this.typeId, this.typeName});

  Types.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    typeId = json['type_id'];
    typeName = json['type_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['type_id'] = this.typeId;
    data['type_name'] = this.typeName;
    return data;
  }
}

class VariantItems {
  int? id;
  String? name;
  int? position;
  int? visible;
  List<Items>? items;

  VariantItems({this.id, this.name, this.items, this.position, this.visible});

  VariantItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    position = json['position'];
    visible = json['visible'];
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
    data['name'] = this.name;
    data['position'] = this.position;
    data['visible'] = this.visible;
    
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
  int? offers;
  int? status;
  String? weight;
  int? visible;
  int? salePrice;
  String? description;
  int? regularPrice;
  int? offersPercentage;
  int? position;

  Items(
      {this.id,
      this.name,
      this.image,
      this.price,
      this.offers,
      this.status,
      this.weight,
      this.visible,
      this.salePrice,
      this.description,
      this.regularPrice,
      this.position,
      this.offersPercentage});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    price = json['price'];
    offers = json['offers'];
    status = json['status'];
    weight = json['weight'];
    visible = json['visible'];
    salePrice = json['sale_price'];
    description = json['description'];
    regularPrice = json['regular_price'];
    offersPercentage = json['offers_percentage'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['price'] = this.price;
    data['offers'] = this.offers;
    data['status'] = this.status;
    data['weight'] = this.weight;
    data['visible'] = this.visible;
    data['sale_price'] = this.salePrice;
    data['description'] = this.description;
    data['regular_price'] = this.regularPrice;
    data['offers_percentage'] = this.offersPercentage;
    data['position'] = this.position;
    return data;
  }
}
