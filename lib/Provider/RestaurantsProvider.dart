
import 'package:admin/model/restaurantModel.dart';
import 'package:flutter/material.dart';

class RestaurantsProvider extends ChangeNotifier {
  
  List<RestaurantModel> restaurants = [];


  void addRestaurants(List<RestaurantModel> data){
   restaurants = [...restaurants, ...data];
    notifyListeners();
  }
   void addAllRestaurants(List<RestaurantModel> data){
   restaurants = data;
    notifyListeners();
  }
    void deleteRestaurant(int id){
   restaurants?.removeWhere((e) => e?.restaurantId == id);
    notifyListeners();
  }


  void updateRestaurant(RestaurantModel restaurant){
    int index = restaurants?.indexWhere((e) => e?.restaurantId ==  restaurant?.restaurantId) ?? -1;

    if(index != -1){
      restaurants[index] = restaurant;
      notifyListeners();
    }
  }

 void CheckToAddRestaurant(RestaurantModel restaurant){
    int index = restaurants?.indexWhere((e) => e?.restaurantId ==  restaurant?.restaurantId) ?? -1;

    if(index == -1){
      restaurants.insert(0, restaurant);
      notifyListeners();
    }
  }
}


class SearchRestaurantsProvider extends ChangeNotifier {
  List<RestaurantModel> SelectedRestaurants = [];
  List<RestaurantModel> restaurants = [];

  addrestaurants(List<RestaurantModel> data){
  restaurants = data;
  notifyListeners();
  }

  addSelectedrestaurants(List<RestaurantModel> data){
  SelectedRestaurants = data;
  notifyListeners();
  }



  void Selected(RestaurantModel res){
   if((SelectedRestaurants?.where((e) => e?.restaurantId == res?.restaurantId)?.length ?? 0) > 0){
                                    SelectedRestaurants.removeWhere((e) => e?.restaurantId == res?.restaurantId);
                                                        
                                  }else{
                                    SelectedRestaurants.add(res);
                                  }
notifyListeners();
  }

}