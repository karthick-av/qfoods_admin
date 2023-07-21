


import 'package:admin/model/CategoryDishesModel.dart';
import 'package:admin/model/CategoryModel.dart';
import 'package:flutter/material.dart';

class SelectedCategoryProvider extends ChangeNotifier {
  List<CategoryDishesModel> SelectedDishes = [];
  List<CategoryDishesModel> dishes = [];

  addDishes(List<CategoryDishesModel> data){
  dishes = data;
  notifyListeners();
  }
  addSelectedDishes(List<CategoryDishesModel> data){
    print("SelectedDishes ${SelectedDishes?.length}");
  SelectedDishes = data;
  notifyListeners();
  }



  void Selected(CategoryDishesModel dish){
   if((SelectedDishes?.where((e) => e?.dishId == dish?.dishId)?.length ?? 0) > 0){
                                    SelectedDishes.removeWhere((e) => e?.dishId == dish?.dishId);
                                                        
                                  }else{
                                    SelectedDishes.add(dish);
                                  }
notifyListeners();
  }

}



class SearchCategoryProvider extends ChangeNotifier {
  List<CategoryModel> SelectedCategories = [];
  List<CategoryModel> categories = [];

  addCategories(List<CategoryModel> data){
  categories = data;
  notifyListeners();
  }

  addSelectedCategories(List<CategoryModel> data){
  SelectedCategories = data;
  notifyListeners();
  }



  void Selected(CategoryModel cat){
   if((SelectedCategories?.where((e) => e?.categoryId == cat?.categoryId)?.length ?? 0) > 0){
                                    SelectedCategories.removeWhere((e) => e?.categoryId == cat?.categoryId);
                                                        
                                  }else{
                                    SelectedCategories.add(cat);
                                  }
notifyListeners();
  }

}