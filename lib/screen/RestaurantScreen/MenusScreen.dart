import 'dart:convert';
import 'package:admin/Provider/DishesProvider.dart';
import 'package:admin/components/AddMenusBottomSheet.dart';
import 'package:admin/constants/CustomSnackBar.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/MenusModel.dart';
import 'package:admin/model/restaurantModel.dart';
import 'package:admin/navigation/DrawerNavigation.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;


class MenusScreen extends StatefulWidget {
  final RestaurantModel restaurant;
  const MenusScreen({super.key, required this.restaurant});

  @override
  State<MenusScreen> createState() => _MenusScreenState();
}

class _MenusScreenState extends State<MenusScreen> {
  List<MenusModel> updatemenus = [];
  bool editing = false;
  final formGlobalKey = GlobalKey < FormState > ();


void initState(){
  
     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if( Provider.of<DishesProvider>(context, listen: false).menus?.length == 0){
         Provider.of<DishesProvider>(context, listen: false).getMenus(widget?.restaurant?.restaurantId ?.toString()?? '');
   
      }
    });
  super.initState();
}
  
  Future<void> AddMenuHandler(String menu, bool visible) async{
    List<MenusModel> _menus = [];
    final menus = Provider.of<DishesProvider>(context, listen: false);
  final restaurant_id = widget?.restaurant?.restaurantId?.toString() ?? '';

 
    try{
      dynamic data = {
        "restaurant_id": restaurant_id?.toString(),
        "menu_name": menu,
        "position": ((menus?.menus?.length ?? 0) + 1)?.toString(),
        "visible": visible ? "1" : "0"
      };
         var header ={
  'Content-type': 'application/json'
 };
    var response = await http.post(Uri.parse("${ApiServices.add_menu}"), body: data);
     if(response.statusCode == 200){
        var response_body = json.decode(response.body);
  for(var json in response_body){
     
      _menus.add(MenusModel.fromJson(json));
       }
    print(_menus.length);
    if(_menus.length > 0){
   menus.addMenus(_menus);
    }
     }
    }catch(e){
print(e);
    }  
  }


  void reorderData(int oldindex, int newindex) {
       final menus = Provider.of<DishesProvider>(context, listen: false).menus;
 
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = menus.removeAt(oldindex);
         menus.insert(newindex, items);

    Provider.of<DishesProvider>(context, listen: false).addMenus(menus);
  }


   Future<void> UpdateMenusHandler() async{
       final menus = Provider.of<DishesProvider>(context, listen: false).menus;

    try{
    List<MenusModel> _menus = [];
       List<MenusModel> menus_ = [];
       for(int i = 0; i < menus.length; i++){
        menus[i].position = i + 1;
        menus_.add(menus[i]);
       }
final jsonData = json.encode(menus_);
   var header ={
  'Content-type': 'application/json'
 };
    final response = await http.put(Uri.parse("${ApiServices.update_menus_list}"), body: jsonData, headers: header);
     if(response.statusCode == 200){
      CustomSnackBar().ErrorMsgSnackBar("Menus Updated");
        var response_body = json.decode(response.body);
      
  for(var json in response_body){
     
      _menus.add(MenusModel.fromJson(json));
       }
    print(_menus.length);
    if(_menus.length > 0){
       Provider.of<DishesProvider>(context, listen: false).addMenus(_menus);

    }
     }else{
      CustomSnackBar().ErrorSnackBar();
     }
    }catch(e){

      CustomSnackBar().ErrorSnackBar();
    }
   }


      Future<void> UpdateMenusNameHandler() async{
final menus =     Provider.of<DishesProvider>(context, listen: false).menus;

    try{
    List<MenusModel> _menus = [];
      
final jsonData = json.encode(updatemenus);
   var header ={
  'Content-type': 'application/json'
 };
    final response = await http.put(Uri.parse("${ApiServices.update_menus_list}"), body: jsonData, headers: header);
     if(response.statusCode == 200){
      CustomSnackBar().ErrorMsgSnackBar("Menus Updated");
        var response_body = json.decode(response.body);
         editing = false;
    setState(() { });
  for(var json in response_body){
     
      _menus.add(MenusModel.fromJson(json));
       }
    print(_menus.length);
    if(_menus.length > 0){
       Provider.of<DishesProvider>(context, listen: false).addMenus(_menus);

    }
     }else{
      CustomSnackBar().ErrorSnackBar();
     }
    }catch(e){

      CustomSnackBar().ErrorSnackBar();
    }
   }



      Future<void> DeleteMenu(String menu_id) async{
final menus =     Provider.of<DishesProvider>(context, listen: false).menus;
  final restaurant_id = widget?.restaurant?.restaurantId?.toString() ?? '';
 
    try{
    List<MenusModel> _menus = [];
      
   var header ={
  'Content-type': 'application/json'
 };
    final response = await http.delete(Uri.parse("${ApiServices.menus_list}${menu_id}/${restaurant_id}"));
     if(response.statusCode == 200){
      CustomSnackBar().ErrorMsgSnackBar("Menus Deleted");
        var response_body = json.decode(response.body);
         editing = false;
    setState(() { });
  for(var json in response_body){
     
      _menus.add(MenusModel.fromJson(json));
       }
    print(_menus.length);
    if(_menus.length > 0){
       Provider.of<DishesProvider>(context, listen: false).addMenus(_menus);

    }
     }else{
      CustomSnackBar().ErrorSnackBar();
     }
    }catch(e){

      CustomSnackBar().ErrorSnackBar();
    }
   }

   void UpdateMenuName(String menu, int index){
    updatemenus[index]?.menuName = menu;
    setState(() {});

   }

  @override
  Widget build(BuildContext context) {
    final menus =     Provider.of<DishesProvider>(context, listen: true).menus;

    double height =  MediaQuery.of(context).size.height;
    double width =  MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: 
      (menus?.length ?? 0) > 0 ?
      Container( 
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
         child: InkWell( 
          onTap: (){
            if(editing){
        if (!formGlobalKey.currentState!.validate()) {
                          return;
                        }
                        UpdateMenusNameHandler();
            }else{
              UpdateMenusHandler();
            }
          },
          child: Container( 
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
          ): SizedBox(),
      backgroundColor: AppColors.whitecolor,
       drawer: DrawerMenu(),
         appBar: AppBar( 
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: (){
               AddMenuBottomSheet(context, AddMenuHandler);
                },
                child: Icon(Icons.add_circle_outline, size: ScreenUtil().setSp(25),),
              ),
            ),
            editing ?
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: InkWell(
                onTap: (){
                 editing = false;
                 setState(() {});
                },
                child: Icon(Icons.close, size: ScreenUtil().setSp(27), color: AppColors.primaryColor,),
              ),
            ) : 
             Container(
              margin: const EdgeInsets.only(right: 20),
              child: InkWell(
                onTap: (){
                 editing = true;
                 updatemenus = menus;
                 setState(() {});
                },
                child: Icon(Icons.edit, size: ScreenUtil().setSp(27),),
              ),
            )
          ],
         iconTheme: IconThemeData(color: AppColors.greyBlackcolor),
        elevation: 0.5,
        backgroundColor: AppColors.whitecolor,
        
         title: Text('Menus',style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(16))),
         
      ),
     body: SingleChildScrollView( 
      child: Form(
          key: formGlobalKey,
        child: Column(
          children: [
            if(menus.length > 0)
            ReorderableListView(
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              shrinkWrap: true,
          onReorder: reorderData,
          children: [
           
          for(int i = 0; i < menus.length; i++) 
       
       editing
       ? Container(
                   margin: const EdgeInsets.only(top: 10),
                                 padding: const EdgeInsets.all(14.0),
                                 
                                      width: width * 0.90,
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
                              
        
                  key: ValueKey(menus[i]),
        child: UpdateMenuCard(menus[i], UpdateMenuName, i, DeleteMenu))
        :     FadeInLeft(
                    key: ValueKey(menus[i]),
          
          delay: Duration(milliseconds: 500),
          child: Container(
                   margin: const EdgeInsets.only(top: 10),
                                 padding: const EdgeInsets.all(14.0),
                                 
                                      width: width * 0.90,
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
                              
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${menus[i]?.menuName ?? ''}",
                      style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),
                      ),
                    
                    Switch(  
                  onChanged: (value){
                  menus[i]?.visible = menus[i]?.visible == 1 ? 0 : 1;
                  setState(() { });
                  },  
                  value: menus[i]?.visible == 1,  
                  activeColor: AppColors.primaryColor,  
                  activeTrackColor: Color(0xFFFDD4D7),  
                  inactiveThumbColor: AppColors.greyBlackcolor,  
                  inactiveTrackColor: AppColors.lightgreycolor,  
                )  
                    ],
                  ),
                ),
        )
          ],
          ),
      
          SizedBox(height: height * 0.80,)
          ],
        ),
      ),
     ),
    );
  }
}



Widget UpdateMenuCard(MenusModel menu, Function UpdateMenuName, int index, Function DeleteMenu){
  TextEditingController menuName = TextEditingController(text: menu?.menuName ?? '');
  menuName.selection = TextSelection.fromPosition(TextPosition(offset: menuName.text.length));
  print(menu?.menuName);
return FadeInRight(
  delay: Duration(milliseconds: 600),
  child: Row(
    
    children: [
      new Flexible(
            child: new TextFormField(
              onChanged: (value){
                UpdateMenuName(value, index);
              },
              controller: menuName,
               style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                        cursorColor: AppColors.greycolor,
                                         decoration:  InputDecoration(
                              labelText: 'Menu Name',
                              hintText: "Enter Menu Name",
                              border: OutlineInputBorder(
                              )
                              ,
                                 focusedBorder: OutlineInputBorder(
                                 borderRadius: BorderRadius.all(Radius.circular(4)),
                                 borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                               ),
                               enabledBorder: OutlineInputBorder(
                                 borderRadius: BorderRadius.all(Radius.circular(4)),
                                 borderSide: BorderSide(width: 1,color: AppColors.lightgreycolor),
                               ),
                              labelStyle: TextStyle(fontSize: ScreenUtil().setSp(12.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.greycolor)
                                        // TODO: add errorHint
                                        ),
                                       validator: ((value){
                          if(value == "") return "Menu name is required";
                          return null;
                        })    
            ),
          ),

          InkWell(
            onTap: (){
              DeleteMenu(menu?.menuId?.toString());
            },
            child: Icon(Icons.delete, size: ScreenUtil().setSp(25), color: AppColors.primaryColor,),
          )
      ],
  )
  );
}