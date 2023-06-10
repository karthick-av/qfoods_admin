

import 'dart:convert';

import 'package:admin/components/SearchGroceryCategory.dart';
import 'package:admin/constants/CustomSnackBar.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/GroceryProductModel.dart';
import 'package:admin/model/HomeGroceryCategoryModel.dart';
import 'package:admin/navigation/DrawerNavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;


class HomeGroceryCategoryScreen extends StatefulWidget {
  const HomeGroceryCategoryScreen({super.key});

  @override
  State<HomeGroceryCategoryScreen> createState() => _HomeGroceryCategoryScreenState();
}

class _HomeGroceryCategoryScreenState extends State<HomeGroceryCategoryScreen> {
  bool loading = false;

  List<HomeGroceryCategoryModel> list = [];
  List<dynamic> mainList = [];

@override
void initState(){
 WidgetsBinding.instance!
        .addPostFrameCallback((_) {
         if((list?.length ?? 0) > 0){
         }
            getListHandler();
         
        });
  super.initState();
}


Future<void> getListHandler() async{
 loading = true;
    setState(() {});
  try{
    List<HomeGroceryCategoryModel> _list = [];

      var response = await http.get(Uri.parse(ApiServices.grocery_home_categories));
  loading = false;
    setState(() {});
    
   if(response.statusCode == 200){
    final responseBody = json.decode(response.body);
      for(var json in responseBody){
     
      _list.add(HomeGroceryCategoryModel.fromJson(json));
       }
    list = _list;

    List<dynamic> data = [];
    _list?.forEach((e){
     data?.add({
      "category_id": e?.categoryId,
      "visible": e?.visible,
      "order_by": e?.orderBy,
      "id": e?.id
     });
    });
    mainList = data;
    setState(() { });

   }
  }
  catch(e){
      loading = false;
    setState(() {});
    CustomSnackBar().ErrorSnackBar();
  }
}


Future<void> UpdateHandler() async{
  print("hhh");
  List<dynamic> data = [];
    for(int i = 0; i < (list?.length ?? 0); i++){
       data?.add({
      "category_id": list[i]?.categoryId,
      "visible": list[i]?.visible,
      "order_by": i + 1,
      "id": list[i]?.id
     });
    }
final changedList = data?.where((e) {
  return (mainList!.where((m) => (e["id"] == m["id"]) &&(e["visible"] != m["visible"] || e["order_by"] != m["order_by"]))!.length > 0);
});
if(changedList?.length  == 0) return;
 loading = true;
    setState(() {});
  try{
     final jsonData = json.encode(changedList?.toList());
   var header ={
  'Content-type': 'application/json'
 };
    List<HomeGroceryCategoryModel> _list = [];

      var response = await http.put(Uri.parse(ApiServices.grocery_home_categories), headers: header, body: jsonData);
  loading = false;
    setState(() {});
    
   if(response.statusCode == 200){
    CustomSnackBar().ErrorMsgSnackBar("Updated");
    final responseBody = json.decode(response.body);
    print(responseBody);
      for(var json in responseBody){
     
      _list.add(HomeGroceryCategoryModel.fromJson(json));
       }
    list = _list;

    List<dynamic> data = [];
    _list?.forEach((e){
     data?.add({
      "category_id": e?.categoryId,
      "visible": e?.visible,
      "order_by": e?.orderBy,
      "id": e?.id
     });
    });
    mainList = data;
    setState(() { });

   }
  }
  catch(e){
      loading = false;
    setState(() {});
    CustomSnackBar().ErrorSnackBar();
  }
}


void reorderData(int oldindex, int newindex) {
     
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = list.removeAt(oldindex);
         list.insert(newindex, items);

setState(() {});
  }


Future<void> additemHandler(List<Category> catgeories) async{


 loading = true;
    setState(() {});
  try{
    List<dynamic> data  = [];
catgeories?.forEach((e) {
  data.add({
    "category_id": e?.categoryId
  });
});
final jsonBody = json.encode(data?.toList());
   print(jsonBody);
    List<HomeGroceryCategoryModel> _list = [];
  var header ={
  'Content-type': 'application/json'
 };
      var response = await http.post(Uri.parse(ApiServices.grocery_home_categories), body: jsonBody, headers: header);
  loading = false;
    setState(() {});
    
   if(response.statusCode == 200){
    final responseBody = json.decode(response.body);
      for(var json in responseBody){
     
      _list.add(HomeGroceryCategoryModel.fromJson(json));
       }
    list = _list;

    List<dynamic> data = [];
    _list?.forEach((e){
     data?.add({
      "category_id": e?.categoryId,
      "visible": e?.visible,
      "order_by": e?.orderBy,
      "id": e?.id
     });
    });
    mainList = data;
    setState(() { });

   }
  }
  catch(e){
      loading = false;
    setState(() {});
    CustomSnackBar().ErrorSnackBar();
  }
}


Future<void> deleteHandler(HomeGroceryCategoryModel cat) async{
 loading = true;
    setState(() {});
  try{
    List<HomeGroceryCategoryModel> _list = [];

      var response = await http.delete(Uri.parse("${ApiServices.grocery_home_categories}/${cat?.id}"));
  loading = false;
    setState(() {});
    
   if(response.statusCode == 200){
    
    CustomSnackBar().ErrorMsgSnackBar("deleted");
    final responseBody = json.decode(response.body);
      for(var json in responseBody){
     
      _list.add(HomeGroceryCategoryModel.fromJson(json));
       }
    list = _list;

    List<dynamic> data = [];
    _list?.forEach((e){
     data?.add({
      "category_id": e?.categoryId,
      "visible": e?.visible,
      "order_by": e?.orderBy,
      "id": e?.id
     });
    });
    mainList = data;
    setState(() { });

   }
  }
  catch(e){
      loading = false;
    setState(() {});
    CustomSnackBar().ErrorSnackBar();
  }
}



  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return  Scaffold(
      bottomNavigationBar:  Container( 
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
            UpdateHandler();
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
          ),
      backgroundColor: AppColors.whitecolor,
         drawer: DrawerMenu(),
      appBar:  AppBar(
        
          title: Text("Home Categories"),
          actions: [
            InkWell(
              onTap: (){
                SearchGroceryCategory(context, additemHandler);
              },
              child:  Icon(Icons.add_circle_outline_rounded, color: AppColors.whitecolor,size: ScreenUtil().setSp(20),),
            ),

            SizedBox(width: 10,),
          ],
        ),
      body: RefreshIndicator(
        onRefresh: ()async{
          await getListHandler();
        },
        child: SingleChildScrollView(
          child: Column(children: [
             if(loading)
                             LinearProgressIndicator(
                              
                              backgroundColor: AppColors.whitecolor,
                               valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),  
                  minHeight: 10,
                            ),
      
                          if((list?.length ?? 0) >0)
                             ReorderableListView(
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shrinkWrap: true,
            onReorder: reorderData,
            children: [
              for(int i = 0; i < (list?.length ?? 0) ; i++)
              Container(
                  key: ValueKey(list[i]?.categoryId),
            
                                  margin: const EdgeInsets.only(top: 10),
                                               padding: const EdgeInsets.all(14.0),
                                               
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
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                           borderRadius: BorderRadius.circular(8.0),
                                          child: Container(
                                            height: ScreenUtil().setHeight(50),width: ScreenUtil().setWidth(50),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                            child: Image.network(list?[i]?.image ?? '', height: ScreenUtil().setHeight(50),width: ScreenUtil().setWidth(50),)),
                                        ),
                                        SizedBox(width: 10,),
                                        Text(list?[i]?.categoryName ?? '', style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w400),)
                                      ],
                                    ),
      
                                    InkWell(
                                      onTap: (){
                                        deleteHandler(list[i]);
                                      },
                                      child: Icon(Icons.delete, color: AppColors.primaryColor, size: ScreenUtil().setSp(20),),
                                    )
                                  ],
                                )
                               )
            ]
                             ),

                             SizedBox(height: height * 0.80,)
          ]),
        ),
      ),
    );
  }
}