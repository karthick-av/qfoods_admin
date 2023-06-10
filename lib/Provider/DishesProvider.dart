
import 'dart:convert';

import 'package:admin/constants/CustomSnackBar.dart';
import 'package:admin/model/MenusModel.dart';
import 'package:admin/model/dishesModel.dart';
import 'package:admin/services/DishesServices.dart';
import 'package:flutter/cupertino.dart';

class DishesProvider extends ChangeNotifier {
  
  final _service = DishesServices();

  bool isLoading = false;
  bool updateLoading = false;
  List<DishesModel> dishes = [];
  List<dynamic> dishes_ = [];

  List menu = [];
  
  List<MenusModel> menus = [];

 Future<void> getMenus(String res_Id) async{
   isLoading = true;
    notifyListeners();

 try{
    menus = await _service.getMenuServices(res_Id);
    isLoading = false;
    notifyListeners();

 }
 catch(e){
    isLoading = false;
    notifyListeners();
    print(e);
 }
  } 


 void addMenus(List<MenusModel> __menus){
    menus = __menus;
    notifyListeners();
  }

  Future<void> getDishes(String res_Id) async{
   isLoading = true;
    notifyListeners();

 try{
  List<dynamic> org = [];
  List<DishesModel>  data = await _service.getDishesServices(res_Id);
   data?.forEach((m) {
       m?.dishes?.forEach((v) {
    
     org?.add({
       "menu_id": m?.menuId,
      "menu_item_id": v?.menuItemId,
      "product_id": v?.dishId,
      "status": v?.status,
      "position": v?.position,
      "restaurant_id": v?.restaurantId
     });
       });
   });

     dishes = data;
     dishes_ = org?.toList() ?? [];
    isLoading = false;
    notifyListeners();

 }
 catch(e){
    isLoading = false;
    notifyListeners();
    print(e);
 }
  } 


  void addDishes(List<DishesModel> _dishes){
    dishes = _dishes;
    notifyListeners();
  }


  Future<void> UpdateDishes() async{
    updateLoading = true;
    notifyListeners();
   try{
    List<dynamic> updateData = [];
   dishes?.forEach((m) {
       m?.dishes?.forEach((v) {
         final isExist = updateData?.where((element) => element?["product_id"] == v?.dishId);
         if(isExist?.length == 0){
          updateData.add({
      "menu_id": m?.menuId,
      "menu_item_id": v?.menuItemId,
      "product_id": v?.dishId,
      "status": v?.status,
      "position": v?.position,
      "restaurant_id": v?.restaurantId
     }); 
         }

       });
   });

  final changedData = updateData?.where((e) {
     return (dishes_?.where((v)  {
    if(v["product_id"] ==  e["product_id"]){
        print("${v["position"]}  position   ${ e["position"]} pro  ${v["product_id"]}  ${e["product_id"]}  ,  ${v["position"] != e["position"]}");
     
    }
     return( v["status"] != e["status"] || v["position"] != e["position"]) && (v["product_id"] == e["product_id"] && v["menu_id"] == e["menu_id"] && v["menu_item_id"] == e["menu_item_id"]);
     })?.length ?? 0) > 0 ;
  }) ?? []; 

if(changedData?.length  == 0) return;

List<DishesModel> _resp_dishes = await _service.UpdateDishesServices(changedData);

    updateLoading = false;
   notifyListeners();
 if((_resp_dishes?.length ?? 0) > 0){
   CustomSnackBar().ErrorMsgSnackBar("Updated !!!");

   dishes = _resp_dishes;

    List<dynamic> org = [];
   _resp_dishes?.forEach((m) {
       m?.dishes?.forEach((v) {
    
     org?.add({
       "menu_id": m?.menuId,
      "menu_item_id": v?.menuItemId,
      "product_id": v?.dishId,
      "status": v?.status,
      "position": v?.position,
      "restaurant_id": v?.restaurantId
     });
       });
   });

     dishes_ = org?.toList() ?? [];
   notifyListeners();

 }

   }catch(e){
    print(e);
    updateLoading = false;
   notifyListeners();
   }
  }





void addDishesList(Dishes dish){
  List<DishesModel> mDishes = dishes;
 for(int i = 0; i < mDishes.length; i++){
  for(int j = 0; j < (mDishes[i]?.dishes?.length ?? 0); j++){
     if(mDishes[i]?.dishes?[j]?.dishId == dish?.dishId){
        mDishes[i]?.dishes?[j] = dish;
     }
 }
 }
 dishes = mDishes;
 notifyListeners();
}


void addmenu(List data){
  menu = data;
  notifyListeners();
}
}