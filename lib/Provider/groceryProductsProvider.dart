


import 'package:admin/model/GroceryProductModel.dart';
import 'package:admin/model/GroceryTagModel.dart';
import 'package:admin/model/SearchProductModel.dart';
import 'package:flutter/material.dart';

class GroceryProductsProvider extends ChangeNotifier {
  
  List<GroceryProductModel> products = [];
  List<dynamic> list = [];


  void addProducts(List<GroceryProductModel> data){
   products = [...products, ...data];
  List<dynamic> arr = [];
   data?.forEach((e){
    arr.add({
      "grocery_id", e?.groceryId,
      "status", e?.status
    });
   });
list = [...list, ...arr];
    notifyListeners();
  }
   void addAllproducts(List<GroceryProductModel> data){
   products = data;
    List<dynamic> arr = [];
   data?.forEach((e){
    arr.add({
      "grocery_id", e?.groceryId,
      "status", e?.status
    });
   });
   list = arr;
    notifyListeners();
  }

   void addNewproducts(GroceryProductModel product){
  int index = products?.indexWhere((e) => e?.groceryId ==  product?.groceryId) ?? -1;

    if(index == -1){
   
   products.insert(0, product);
   
     }
      notifyListeners();
  }

    void deleteRestaurant(int id){
   products?.removeWhere((e) => e?.groceryId == id);
    notifyListeners();
  }


  void updateProduct(GroceryProductModel product){
    int index = products?.indexWhere((e) => e?.groceryId ==  product?.groceryId) ?? -1;

    if(index != -1){
      products[index] = product;
      notifyListeners();
    }
  }
   
}







class SearchGroceryCategoryProvider extends ChangeNotifier {
  List<Category> SelectedCategories = [];
  List<Category> categories = [];

  addCategories(List<Category> data){
  categories = data;
  notifyListeners();
  }

  addSelectedCategories(List<Category> data){
  SelectedCategories = data;
  notifyListeners();
  }



  void Selected(Category cat){
   if((SelectedCategories?.where((e) => e?.categoryId == cat?.categoryId)?.length ?? 0) > 0){
                                    SelectedCategories.removeWhere((e) => e?.categoryId == cat?.categoryId);
                                                        
                                  }else{
                                    SelectedCategories.add(cat);
                                  }
notifyListeners();
  }



}



class SearchGroceryBrandsProvider extends ChangeNotifier {
  List<Brands> SelectedBrands = [];
  List<Brands> brands = [];

  addBrands(List<Brands> data){
  brands = data;
  notifyListeners();
  }

  addSelectedbrands(List<Brands> data){
  SelectedBrands = data;
  notifyListeners();
  }



  void Selected(Brands brand){
   if((SelectedBrands?.where((e) => e?.brandId == brand?.brandId)?.length ?? 0) > 0){
                                    SelectedBrands.removeWhere((e) => e?.brandId == brand?.brandId);
                                                        
                                  }else{
                                    SelectedBrands.add(brand);
                                  }
notifyListeners();
  }

}



class SearchGroceryTypesProvider extends ChangeNotifier {
  List<Types> SelectedTypes = [];
  List<Types> types = [];

  addTypes(List<Types> data){
  types = data;
  notifyListeners();
  }

  addSelectedTypes(List<Types> data){
  SelectedTypes = data;
  notifyListeners();
  }



  void Selected(Types type){
   if((SelectedTypes?.where((e) => e?.typeId == type?.typeId)?.length ?? 0) > 0){
                                    SelectedTypes.removeWhere((e) => e?.typeId == type?.typeId);
                                                        
                                  }else{
                                    SelectedTypes.add(type);
                                  }
notifyListeners();
  }

}


class SearchGroceryProductsProvider extends ChangeNotifier {
  List<SearchProductModel> SelectedProducts = [];
  List<SearchProductModel> products =  [];

  addProducts(List<SearchProductModel> data){
  products = data;
  notifyListeners();
  }

  addSelectedProducts(List<SearchProductModel> data){
  SelectedProducts = data;
  notifyListeners();
  }



  void Selected(SearchProductModel product){
   if((SelectedProducts?.where((e) => e?.groceryId == product?.groceryId)?.length ?? 0) > 0){
                                    SelectedProducts.removeWhere((e) => e?.groceryId == product?.groceryId);
                                                        
                                  }else{
                                    SelectedProducts.add(product);
                                  }
notifyListeners();
  }

}


class SearchGroceryTagsProvider extends ChangeNotifier {
  List<GroceryTagModel> SelectedTags = [];
  List<GroceryTagModel> tags = [];

  addTags(List<GroceryTagModel> data){
  tags = data;
  notifyListeners();
  }

  addSelectedTags(List<GroceryTagModel> data){
  SelectedTags = data;
  notifyListeners();
  }



  void Selected(GroceryTagModel tag){
   if((SelectedTags?.where((e) => e?.tagId == tag?.tagId)?.length ?? 0) > 0){
                                    SelectedTags.removeWhere((e) => e?.tagId == tag?.tagId);
                                                        
                                  }else{
                                    SelectedTags.add(tag);
                                  }
notifyListeners();
  }



}

