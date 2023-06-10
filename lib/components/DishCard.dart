import 'dart:convert';

import 'package:admin/Provider/DishesProvider.dart';
import 'package:admin/components/MenuSelector.dart';
import 'package:admin/constants/CustomSnackBar.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/dishesModel.dart';
import 'package:admin/model/restaurantModel.dart';
import 'package:admin/screen/EditDishScreen/EditDishScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class DishCard extends StatelessWidget {
  final Dishes? dish;
  final RestaurantModel restaurant;
  final int menuIndex;
  final int dishIndex;
  final BuildContext cxt;
  const DishCard({super.key, required this.restaurant,required this.dish, required this.menuIndex, required this.dishIndex, required this.cxt});

void deleteDishHandler() async{
   final SharedPreferences prefs = await SharedPreferences.getInstance();
  


 try{
      
         var header ={
  'Content-type': 'application/json'
 };
    var response = await http.delete(Uri.parse("${ApiServices.delete_dish}/${restaurant?.restaurantId}/${dish?.dishId}"));
    print(response.statusCode);

     if(response.statusCode == 200){
        List<DishesModel> _dishes = [];
  
        var response_body = json.decode(response.body);
//         if(response_body["message"] != null){
//  CustomSnackBar().ErrorMsgSnackBar(response_body?["message"] ?? '');
//   return;
// }
        CustomSnackBar().ErrorMsgSnackBar("Dish Deleted");
   for(var json in response_body){
     
      _dishes.add(DishesModel.fromJson(json));
       }
       Provider.of<DishesProvider>(cxt, listen: false).addDishes(_dishes);
      
     }
    }catch(e){
print(e);
CustomSnackBar().ErrorSnackBar();
 
    }
  
}


  @override
  Widget build(BuildContext context) {

       return Container(
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(width: 0.5, color: AppColors.lightgreycolor))
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${dish?.name ?? ''}",
                                maxLines: 2,style: TextStyle(fontFamily: FONT_FAMILY, overflow: TextOverflow.ellipsis,fontWeight: FontWeight.w600, color: AppColors.blackcolor,fontSize: ScreenUtil().setSp(14.0)),
                                ),
                                SizedBox(height: 5.0,),
                                  Text(
                                  "Rs ${dish?.price ?? ''}",
                                maxLines: 2,style: TextStyle(fontFamily: FONT_FAMILY, overflow: TextOverflow.ellipsis,fontWeight: FontWeight.normal, color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(14.0)),
                                ),
                                 SizedBox(height: 5.0,),
                                 Text("${dish?.description ?? ''}",
                                maxLines: 2,style: TextStyle(fontFamily: FONT_FAMILY, overflow: TextOverflow.ellipsis,fontWeight: FontWeight.normal, color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(12.0)),
                                ),


                InkWell(
                  onTap: (){
                    final m =dish?.menuList?.toList() ?? [];
                    Provider.of<DishesProvider>(context, listen: false).addmenu(m);
                     Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => 
                         MenuSelect(dish: dish!,)),
                        );
                  },
                  child: Text("Select Menu", style: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(13), fontWeight: FontWeight.w500),),
                ),
                    SizedBox(height: 5.0,),
                             

     // if(dish?.image != "")
                                                                      InkWell(
                                        onTap: (){
                                           showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
    title: Text("Confirmation"),
    content: Text("Are you sure want to delete this ?"),
    actions: [
       TextButton(
    child: Text("yes"),
    onPressed:  () {
           Navigator.of(context).pop();
           deleteDishHandler();
    },
  ),
       TextButton(
    child: Text("no"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  ),
    ],
  );
    },
                                   );
                                        },
                                        child: Icon(Icons.delete, color: AppColors.primaryColor, size: ScreenUtil().setSp(20),),
                                      )

                                  ],
                                ),
                              
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Switch(value: dish?.status == 1 ? true : false,
                                  onChanged: (value){
                                    final dishes = Provider.of<DishesProvider>(context, listen: false).dishes;
//      final dishes_ = dishes[menuIndex]?.dishes;
//           dishes_?[dishIndex].status =  dish?.status == 1 ? 0 : 1;
// final j = json.encode(dishes_?[dishIndex]);
dishes?.forEach((e) {
  e.dishes?.forEach((d) {
    if(d?.dishId == dish?.dishId){
      d.status =  dish?.status == 1 ? 0 : 1;
    }
   });
});
         
    Provider.of<DishesProvider>(context, listen: false).addDishes(dishes);
      
                                  }, 
                                  
                                     activeColor: AppColors.primaryColor,  
                  activeTrackColor: Color(0xFFFDD4D7),  
                  inactiveThumbColor: AppColors.greyBlackcolor,  
                  inactiveTrackColor: AppColors.lightgreycolor,  
              
                                  ),

                                 dish?.image  == ""
                                 ?
                                      InkWell(
                                        onTap: (){
                                          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => 
                         EditDishScreen(dish_: dish,)),
                        );
                                        },
                                        child: Container(
                                      //  margin:  EdgeInsets.only(right: ScreenUtil().setHeight(14.0)),
                                        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0 ),
                                        decoration: BoxDecoration(
                                          color: AppColors.whitecolor,
                                          borderRadius: BorderRadius.circular(5.0),
                                          border: Border.all(width: 1, color: AppColors.primaryColor),
                                             boxShadow: [
                                                            BoxShadow(
                                                              offset: Offset(0, 4),
                                                              blurRadius: 20,
                                                              color: const Color(0xFFB0CCE1).withOpacity(0.29),
                                                            ),
                                                          ],
                                        ),
                                        child: Text("Edit", style: TextStyle(letterSpacing: 1.0,color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(14.0)),),
                                      ),
                                      )

                                  : Container(
                                  margin: const EdgeInsets.only(bottom: 10.0),
                                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                  child: Stack(
                                    alignment: new Alignment(0.0, 1.5),
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child:  (dish?.status == 0)
                               
                                          ? ColorFiltered(child: Image.network("${dish?.image ?? ''}", fit: BoxFit.cover,height: ScreenUtil().setHeight(80.0), width: ScreenUtil().setWidth(100.0),),
                                            colorFilter: ColorFilter.mode(
    Colors.grey,
    BlendMode.saturation,
  ),
                                          )
                                          : Image.network("${dish?.image ?? ''}", fit: BoxFit.cover,height: ScreenUtil().setHeight(80.0), width: ScreenUtil().setWidth(100.0),)),
                                   (
                                    InkWell(
                                       onTap: (){
                                      //  EditDishModal(context);
                                         Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => 
                         EditDishScreen(dish_: dish,)),
                        );
                                  },
                                      child:  Container(
                                        
                                       padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0 ),
                                                                     decoration: BoxDecoration(
                                                                        color: AppColors.whitecolor,
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(width: 1, color: AppColors.primaryColor),
                                         boxShadow: [
                                                            BoxShadow(
                                                              offset: Offset(0, 4),
                                                              blurRadius: 20,
                                                              color: const Color(0xFFB0CCE1).withOpacity(0.29),
                                                            ),
                                                          ],
                                      ),
                                        child: Text("Edit", style: TextStyle(letterSpacing: 1.0,color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(14.0)),)),
                                    )
                                  )
                                    ],
                                  ),
                                )
                                ],
                              )
                              ]
                            )
                          );
  }
}