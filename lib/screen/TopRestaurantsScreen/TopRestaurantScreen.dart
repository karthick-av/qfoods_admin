import 'dart:convert';
import 'package:admin/components/SearchRestaurants.dart';
import 'package:admin/constants/CustomSnackBar.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/TopRestaurantsModel.dart';
import 'package:admin/model/restaurantModel.dart';
import 'package:admin/navigation/DrawerNavigation.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;


class TopRestaurantsScreen extends StatefulWidget {
  const TopRestaurantsScreen({super.key});

  @override
  State<TopRestaurantsScreen> createState() => _TopRestaurantsScreenState();
}

class _TopRestaurantsScreenState extends State<TopRestaurantsScreen> {
  List<TopRestaurantsModel> restaurants = [];
  List<dynamic> mainList = [];
 
  bool loading = false;
  

void initState(){
  
     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getHandler();
    });
  super.initState();
}
  
  Future<void> getHandler() async{
   loading = true;
   setState(() {});
   
    List<TopRestaurantsModel> _list = [];
     List<dynamic> _mlist = [];
   print(ApiServices.toprestaurants);
    try{
     
    var response = await http.get(Uri.parse("${ApiServices.toprestaurants}"));
   loading = false;
   setState(() {});
  
     if(response.statusCode == 200){
        var response_body = json.decode(response.body);
        print(response_body);
  for(var json in response_body){
     TopRestaurantsModel tr = TopRestaurantsModel.fromJson(json);
      _list.add(tr);
      _mlist.add({
        "id": tr.id,
        "position": tr.position
      });
       }



       mainList = _mlist; 
       restaurants = _list;
       setState(() {});
     }
    }catch(e){
print(e);
CustomSnackBar().ErrorSnackBar();

 loading = false;
   setState(() {});
  
    }  
  }


  void reorderData(int oldindex, int newindex) {
       final list = restaurants;
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = list.removeAt(oldindex);
         list.insert(newindex, items);
      
      restaurants  = list;

      setState(() { });

  }



Future<void> updateHandler() async{
  List<dynamic> list = [];
  for(int i = 0; i < (restaurants?.length ?? 0); i++){
     list.add({
        "id": restaurants[i].id,
        "position": i + 1
      });
  }

  final changeList = list?.where((e) {
      return (mainList?.where((b) {
       return e["id"] == b["id"] && e['position'] != b['position'];
      })?.length ?? 0) > 0;
  });


if(changeList?.length == 0) return;
loading = true;
   setState(() {});
   
    List<TopRestaurantsModel> _list = [];
     List<dynamic> _mlist = [];
   
    try{
     final jsonData = json.encode(changeList?.toList());
     print(jsonData);
   var header ={
  'Content-type': 'application/json'
 };
    var response = await http.put(Uri.parse("${ApiServices.toprestaurants}"), body: jsonData, headers: header);
   loading = false;
   setState(() {});
  print(response.statusCode);
     if(response.statusCode == 200){
      CustomSnackBar().ErrorMsgSnackBar("updated");
        var response_body = json.decode(response.body);
  for(var json in response_body){
     TopRestaurantsModel tr = TopRestaurantsModel.fromJson(json);
      _list.add(tr);
      _mlist.add({
        "id": tr.id,
        "position": tr.position
      });
       }



       mainList = _mlist; 
       restaurants = _list;
       setState(() {});
     }
    }catch(e){
print(e);
CustomSnackBar().ErrorSnackBar();
 loading = false;
   setState(() {});
  
    }
}


Future<void> additemHandler(List<RestaurantModel> value) async{
   List<TopRestaurantsModel> _list = [];
     List<dynamic> _mlist = [];
   
     try{
       String url = "${ApiServices.toprestaurants}";
       print(url);
     List<dynamic> data = [];
     value?.forEach((e) {
      data.add({
        "restaurant_id": e?.restaurantId?.toString()
      });
     });
 var header ={
  'Content-type': 'application/json'
 };
   final body = jsonEncode(data); // Convert the list to a JSON string
   print(body);
   var response = await http.post(Uri.parse(url), body: body, headers: header
    );

    print(response?.statusCode);
    
    if(response.statusCode == 200){
      CustomSnackBar().ErrorMsgSnackBar("Items Added");
        var response_body = json.decode(response.body);
  for(var json in response_body){
     TopRestaurantsModel tr = TopRestaurantsModel.fromJson(json);
      _list.add(tr);
      _mlist.add({
        "id": tr.id,
        "position": tr.position
      });
       }



       mainList = _mlist; 
       restaurants = _list;
       setState(() {});
   
    }else{
      CustomSnackBar().ErrorSnackBar();
    }
}
catch(e){
  print(e);
  CustomSnackBar().ErrorSnackBar();
}
  
}





Future<void> deleteItemHandler(int id) async{
   List<TopRestaurantsModel> _list = [];
     List<dynamic> _mlist = [];
   
     try{
       String url = "${ApiServices.toprestaurants}/${id}";
       print(url);
   var response = await http.delete(Uri.parse(url));

    print(response?.statusCode);
    
    if(response.statusCode == 200){
      CustomSnackBar().ErrorMsgSnackBar("Items Deleted");
        var response_body = json.decode(response.body);
  for(var json in response_body){
     TopRestaurantsModel tr = TopRestaurantsModel.fromJson(json);
      _list.add(tr);
      _mlist.add({
        "id": tr.id,
        "position": tr.position
      });
       }



       mainList = _mlist; 
       restaurants = _list;
       setState(() {});
   
    }else{
      CustomSnackBar().ErrorSnackBar();
    }
}
catch(e){
  print(e);
  CustomSnackBar().ErrorSnackBar();
}
  
}


  @override
  Widget build(BuildContext context) {
  
    double height =  MediaQuery.of(context).size.height;
    double width =  MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: 
      (restaurants?.length ?? 0) > 0 ?
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
            updateHandler();
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
          ) : SizedBox(),
      backgroundColor: AppColors.whitecolor,
       drawer: DrawerMenu(),
         appBar: AppBar( 
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: (){
                  searchrestaurants(context, additemHandler);
                },
                child: Icon(Icons.add_circle_outline, size: ScreenUtil().setSp(25),),
              ),
            ),
           
          ],
         iconTheme: IconThemeData(color: AppColors.greyBlackcolor),
        elevation: 0.5,
        backgroundColor: AppColors.whitecolor,
        
         title: Text('Top Restaurants',style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(16))),
         
      ),
     body: RefreshIndicator(
      onRefresh: () async{
        await getHandler();
      },
       child: SingleChildScrollView( 
        child: Column(
          children: [
              if(loading)
                                 LinearProgressIndicator(
                                  
                                  backgroundColor: AppColors.whitecolor,
                                   valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),  
                      minHeight: 10,
                                ),
            ReorderableListView(
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              shrinkWrap: true,
          onReorder: reorderData,
          children: [
           
          for(int i = 0; i < restaurants.length; i++) 
         
            Container(
              key: ValueKey(restaurants[i]),
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
                        Column(
                          children: [
                            Text("${restaurants[i]?.restaurantName ?? ''}",
                            style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),
                            ),


                         
                          ],
                        ),

                                                 InkWell(
                                                  onTap: (){
                                                    deleteItemHandler(restaurants[i]?.restaurantId ?? 0);
                                                  },
                          child: Icon(Icons.delete, color: AppColors.primaryColor, size: ScreenUtil().setSp(20),),
                         ) 

                      ],
                    ),
                  )
          ],
          ),
        
          SizedBox(height: height )
          ],
        ),
       ),
     ),
    );
  }
}



