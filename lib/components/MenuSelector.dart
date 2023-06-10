

import 'dart:convert';

import 'package:admin/Provider/DishesProvider.dart';
import 'package:admin/constants/CustomSnackBar.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/dishesModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';


import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void MenuSelector(BuildContext context, Dishes dish){
     showDialog(
      context: context,
      builder: (BuildContext context) {
            return Dialog(
              insetPadding: EdgeInsets.zero,
              child: MenuSelect(dish: dish,)
            );
          
      }
     );

 
}

class MenuSelect extends StatefulWidget {
  final Dishes dish;
  const MenuSelect({super.key, required this.dish});


  @override
  State<MenuSelect> createState() => _MenuSelectState();
}

class _MenuSelectState extends State<MenuSelect> {
 List<int>? selectedList = [];

bool loading = false;

 void initState(){
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

selectedList = widget.dish?.menuList ?? [];
setState(() {});
  });

  super.initState();
 }



void UpdateMenuHandler() async{
    final menuList = Provider.of<DishesProvider>(context, listen: false).menu;
print(menuList);
final unSelected = menuList?.where((e) => (selectedList?.contains(e) ?? false) == false);

loading = true;
setState((){});

 try{
  List<dynamic> selected_ = [];
selectedList?.forEach((e) {
  selected_.add({
   "menu_id": e?.toString(),
   "dish_id": widget?.dish?.dishId?.toString(),
   "restaurant_id": widget?.dish?.restaurantId?.toString()
  });
});  

final data = {
   "restaurant_id": widget?.dish?.restaurantId?.toString(),
  "selected": selected_,
  "unselected": {
   "dish_id": widget?.dish?.dishId?.toString(),
   "list": unSelected?.toList()
  }
};

         var header ={
  'Content-type': 'application/json'
 };
 final req_body = json.encode(data);
 print(req_body);
    var response = await http.put(Uri.parse("${ApiServices.updatemenu}"), body: req_body,headers: header);
    print(response.statusCode);

loading = false;
setState((){});

     if(response.statusCode == 200){
        List<DishesModel> _dishes = [];
  
        var response_body = json.decode(response.body);
        CustomSnackBar().ErrorMsgSnackBar("Menu Updated");
  Navigator.of(context).pop();
   for(var json in response_body){
     
      _dishes.add(DishesModel.fromJson(json));
       }
       Provider.of<DishesProvider>(context, listen: false).addDishes(_dishes);
      
     }
    }catch(e){
print(e);
CustomSnackBar().ErrorSnackBar();

 Navigator.of(context).pop();
  
  
loading = false;
setState((){});
    }
}

 
  @override
  Widget build(BuildContext context) {
    final menus = Provider.of<DishesProvider>(context, listen: true).menus;
 double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
  
  
    return Scaffold(
               bottomNavigationBar: Container( 
           height: height * 0.08,
         width: width,
         alignment: Alignment.center,
         padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 4),
                                        blurRadius: 20,
                                        color: const Color(0xFFB0CCE1).withOpacity(0.29),
                                      ),
                                    ],
                                  ),
        
          child: 
          loading
          ? Container( 
             height: height * 0.055,
            width: width * 0.90,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration( 
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10)
            ),
            child: SizedBox(
              height: ScreenUtil().setSp(20),
              width: ScreenUtil().setSp(20),
              child: CircularProgressIndicator(color: AppColors.whitecolor, )),
          )
         

          :
          
          InkWell( 
            onTap: (){
            UpdateMenuHandler();
            
            },
            child:  Container( 
             height: height * 0.055,
            width: width * 0.90,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration( 
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Text("Update", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),),
          ),
         ),
          ),
      
                 appBar: AppBar(
                  title: const Text('Select Menu',
                  style: TextStyle(color: AppColors.whitecolor),
                  ),
                  centerTitle: false,
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ),
                body: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: menus.length,
                  itemBuilder: (BuildContext cxt, int index){
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(width: 0.5, color: AppColors.lightgreycolor))
                      ),
                      margin: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                             Checkbox(
                                              activeColor: AppColors.primaryColor,
                                              hoverColor: AppColors.primaryColor,
                                            
                                              value: selectedList?.contains(menus[index]?.menuId), 
                                              onChanged: ((value) {
                                                print("object");
                                                if(selectedList!.contains(menus[index].menuId)){
                                                  selectedList!.remove(menus[index].menuId);
                                                }else{
                                                  int add = menus[index]?.menuId ?? 0;
                                                  if(add != 0){
                                               selectedList!.add(add);
                                                   }
                                                    }
                                                    setState(() { });
                                             })),
                                             SizedBox(width: 10,),

                                
                          Text(menus[index]?.menuName ?? '',
                          style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY,
                          fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500
                          ),
                          )
                        ],
                      ),
                    );

                  },
                ),
              );
  }
}