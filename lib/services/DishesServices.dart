import 'dart:convert';

import 'package:admin/constants/api_services.dart';
import 'package:admin/model/MenusModel.dart';
import 'package:admin/model/dishesModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DishesServices{
  Future<List<MenusModel>> getMenuServices(String restaurant_id) async{
   List<MenusModel> _menus = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
  if(restaurant_id == null) return _menus;
 print("${ApiServices.menus_list}${restaurant_id}");
  var response = await http.get(Uri.parse("${ApiServices.menus_list}${restaurant_id}"));
     if(response.statusCode == 200){
        var response_body = json.decode(response.body);
  for(var json in response_body){
     
      _menus.add(MenusModel.fromJson(json));
       }
     }

 return _menus;
}

  Future<List<DishesModel>> getDishesServices(String restaurant_id) async{
   List<DishesModel> _dishes = [];
    final SharedPreferences prefs = await SharedPreferences.getInstance();
 if(restaurant_id == null) return _dishes;
 
  var response = await http.get(Uri.parse("${ApiServices.dishes_list}${restaurant_id}"));
     if(response.statusCode == 200){
        var response_body = json.decode(response.body);
  for(var json in response_body){
     
      _dishes.add(DishesModel.fromJson(json));
       }
     }

 return _dishes;
}


 Future<List<DishesModel>> UpdateDishesServices(final req_data) async{
   List<DishesModel> _dishes = [];
  final jsonData = json.encode(req_data?.toList());
   var header ={
  'Content-type': 'application/json'
 };
    final response = await http.put(Uri.parse("${ApiServices.update_menu_dishes}"), body: jsonData, headers: header);
   if(response.statusCode == 200){
        var response_body = json.decode(response.body);
  for(var json in response_body){
     
      _dishes.add(DishesModel.fromJson(json));
       }
     }

 return _dishes;
}
}