class DishesModel {
  int? menuId;
  String? menuName;
  int? position;
  List<Dishes>? dishes;

  DishesModel({this.menuId, this.menuName, this.position, this.dishes});

  DishesModel.fromJson(Map<String, dynamic> json) {
    menuId = json['menu_id'];
    menuName = json['menu_name'];
    position = json['position'];
    if (json['dishes'] != null) {
      dishes = <Dishes>[];
      json['dishes'].forEach((v) {
        dishes!.add(new Dishes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menu_id'] = this.menuId;
    data['menu_name'] = this.menuName;
    data['position'] = this.position;
    if (this.dishes != null) {
      data['dishes'] = this.dishes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Dishes {
  String? name;
  int? combo;
  String? image;
  int? price;
  int? offers;
  int? status;
  String? weight;
  int? dishId;
  int? position;
  int? variants;
  int? vegType;
  List<int>? menuList;
  int? priceType;
  int? salePrice;
  String? description;
  int? menuItemId;
  List<DishVariants>? dishVariants;
  int? regularPrice;
  int? restaurantId;
  String? comboDescription;
  int? offersPercentage;

  Dishes(
      {this.name,
      this.combo,
      this.image,
      this.price,
      this.offers,
      this.status,
      this.weight,
      this.dishId,
      this.position,
      this.variants,
      this.vegType,
      this.menuList,
      this.priceType,
      this.salePrice,
      this.description,
      this.menuItemId,
      this.dishVariants,
      this.regularPrice,
      this.restaurantId,
      this.comboDescription,
      this.offersPercentage});

  Dishes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    combo = json['combo'];
    image = json['image'];
    price = json['price'];
    offers = json['offers'];
    status = json['status'];
    weight = json['weight'];
    dishId = json['dish_id'];
    position = json['position'];
    variants = json['variants'];
    vegType = json['veg_type'];
    menuList = json['menu_list'].cast<int>();
    priceType = json['price_type'];
    salePrice = json['sale_price'];
    description = json['description'];
    menuItemId = json['menu_item_id'];
    if (json['dish_variants'] != null) {
      dishVariants = <DishVariants>[];
      json['dish_variants'].forEach((v) {
        dishVariants!.add(new DishVariants.fromJson(v));
      });
    }
    regularPrice = json['regular_price'];
    restaurantId = json['restaurant_id'];
    comboDescription = json['combo_description'];
    offersPercentage = json['offers_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['combo'] = this.combo;
    data['image'] = this.image;
    data['price'] = this.price;
    data['offers'] = this.offers;
    data['status'] = this.status;
    data['weight'] = this.weight;
    data['dish_id'] = this.dishId;
    data['position'] = this.position;
    data['variants'] = this.variants;
    data['veg_type'] = this.vegType;
    data['menu_list'] = this.menuList;
    data['price_type'] = this.priceType;
    data['sale_price'] = this.salePrice;
    data['description'] = this.description;
    data['menu_item_id'] = this.menuItemId;
    if (this.dishVariants != null) {
      data['dish_variants'] =
          this.dishVariants!.map((v) => v.toJson()).toList();
    }
    data['regular_price'] = this.regularPrice;
    data['restaurant_id'] = this.restaurantId;
    data['combo_description'] = this.comboDescription;
    data['offers_percentage'] = this.offersPercentage;
    return data;
  }
}

class DishVariants {
  String? name;
  String? type;
  int? position;
  int? priceType;
  int? variantId;
  int? visible;
  List<VariantItems>? variantItems;

  DishVariants(
      {this.name,
      this.type,
      this.position,
      this.priceType,
      this.visible,
      this.variantId,
      this.variantItems});

  DishVariants.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    position = json['position'];
    priceType = json['price_type'];
    variantId = json['variant_id'];
    visible = json['visible'];
    if (json['variant_items'] != null) {
      variantItems = <VariantItems>[];
      json['variant_items'].forEach((v) {
        variantItems!.add(new VariantItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    data['position'] = this.position;
    data['visible'] = this.visible;
    data['price_type'] = this.priceType;
    data['variant_id'] = this.variantId;
    if (this.variantItems != null) {
      data['variant_items'] =
          this.variantItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VariantItems {
  String? name;
  String? image;
  int? price;
  int? offers;
  int? status;
  String? weight;
  int? position;
  int? vegType;
  int? salePrice;
  int? variantId;
  String? description;
  int? regularPrice;
  int? variantItemId;
  int? offersPercentage;

  VariantItems(
      {this.name,
      this.image,
      this.price,
      this.offers,
      this.status,
      this.weight,
      this.position,
      this.vegType,
      this.salePrice,
      this.variantId,
      this.description,
      this.regularPrice,
      this.variantItemId,
      this.offersPercentage});

  VariantItems.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    price = json['price'];
    offers = json['offers'];
    status = json['status'];
    weight = json['weight'];
    position = json['position'];
    vegType = json['veg_type'];
    salePrice = json['sale_price'];
    variantId = json['variant_id'];
    description = json['description'];
    regularPrice = json['regular_price'];
    variantItemId = json['variant_item_id'];
    offersPercentage = json['offers_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['price'] = this.price;
    data['offers'] = this.offers;
    data['status'] = this.status;
    data['weight'] = this.weight;
    data['position'] = this.position;
    data['veg_type'] = this.vegType;
    data['sale_price'] = this.salePrice;
    data['variant_id'] = this.variantId;
    data['description'] = this.description;
    data['regular_price'] = this.regularPrice;
    data['variant_item_id'] = this.variantItemId;
    data['offers_percentage'] = this.offersPercentage;
    return data;
  }
}
