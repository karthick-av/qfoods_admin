import 'dart:convert';

import 'package:admin/constants/CustomSnackBar.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/controller/DashboardController.dart';
import 'package:admin/model/DashboardModel.dart';
import 'package:admin/model/GroceryDashboardModel.dart';
import 'package:admin/navigation/DrawerNavigation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
bool loading = false;
  
 final dashboardController dashboard = Get.put(dashboardController());
 
 final TokenController tokencontroller = Get.put(TokenController());

  @override
void initState(){
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
   getDataHandler("");
   getGroceryDataHandler("");
    if(tokencontroller.isUpdated == false){
    UpdateFcmTokenHandler();
    }
    });

  super.initState();
}


Future<void> UpdateFcmTokenHandler() async{
  try{
 final uri = Uri.parse(ApiServices.updateFcmtoken);
 print(uri);
 String? token = await FirebaseMessaging.instance.getToken();
final SharedPreferences prefs = await SharedPreferences.getInstance();
  final admin_id = await prefs.getInt("admin_id") ?? null;
  if(admin_id == null) return;
    final data = {
      "id": admin_id,
      "fcm_token": token
    };

    var jsonString = json.encode(data);
    print(jsonString);
     var header ={
  'Content-type': 'application/json'
 };
    final response = await http.put(uri, body: jsonString, headers: header);
    if(response.statusCode == 200){
      tokencontroller.updateHandler();
    }
  }
  catch(e){

  }
}

Future<void> getDataHandler(String condition) async{
  loading = true;
    setState(() {});
  try{
print("${ApiServices.get_dashboard}&${condition}");
      var response = await http.get(Uri.parse("${ApiServices.get_dashboard}?${condition}"));
  loading = false;
    setState(() {});
    
   if(response.statusCode == 200){
    final responseBody = json.decode(response.body);

    DashboardModel data = DashboardModel.fromJson(responseBody);
    dashboard.addRdata(data);
   }
  }catch(e){
    loading = false;
    setState(() {});
    CustomSnackBar().ErrorSnackBar();
  }
}

Future<void> getGroceryDataHandler(String condition) async{
  loading = true;
    setState(() {});
  try{
print("${ApiServices.grocery_dashboard}&${condition}");
      var response = await http.get(Uri.parse("${ApiServices.grocery_dashboard}?${condition}"));
  loading = false;
    setState(() {});
    
   if(response.statusCode == 200){
    final responseBody = json.decode(response.body);

    GroceryDashboardModel data = GroceryDashboardModel.fromJson(responseBody);
    dashboard.addgData(data);
   }
  }catch(e){
    loading = false;
    setState(() {});
    CustomSnackBar().ErrorSnackBar();
  }
}

  @override
  Widget build(BuildContext context) {
    final data = dashboard.dashboard;
    final gdata = dashboard.gdashboard;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.whitecolor,
         drawer: DrawerMenu(),
            appBar: AppBar( 
         iconTheme: IconThemeData(color: AppColors.greyBlackcolor),
        elevation: 0.5,
        backgroundColor: AppColors.whitecolor,
        
         title: Text('DashBoard',style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(16))),
         
        
      ),
         body: RefreshIndicator(
          onRefresh: () async{
           await getDataHandler("");
           await getGroceryDataHandler("");
             if(tokencontroller.isUpdated == false){
  await UpdateFcmTokenHandler();
    }
  
          },
           child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  if(loading)
                               LinearProgressIndicator(
                                
                                backgroundColor: AppColors.whitecolor,
                                 valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),  
                    minHeight: 10,
                              ),
             Container( 
              width: double.infinity,
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
         border:  Border(
        bottom: BorderSide( color: AppColors.lightgreycolor.withOpacity(0.5)),
      )
          ),
              child:  Text("Restaurant", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(17), fontWeight: FontWeight.bold),),
             ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text("Sales", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(17), fontWeight: FontWeight.bold),)),
                Center(
                  child: Container(
                    child: Wrap(
                      spacing: 10,
                      children: [
                                                        Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                    
                                    decoration: BoxDecoration( 
                                      borderRadius: BorderRadius.circular(8),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Color(0xFFFFB295)
                                            .withOpacity(0.6),
                                        offset: const Offset(1.1, 4.0),
                                        blurRadius: 8.0),
                                  ],
                                  gradient: LinearGradient(
                                    colors: [
                                     Color(0xFFFA7D82),
                                   Color(0xFFFFB295) ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
         
                                    ),
                                    child: Column(
                                      children: [
                                        Text("Sub Total", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),)
                                          ,SizedBox(height: 5,),
                                          
                                          Text("${data?.subTotal ?? '0'}", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),)
                                    ],
                                    ),
                                  ),
                          Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                    
                                    decoration: BoxDecoration( 
                                      borderRadius: BorderRadius.circular(8),
                                    boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Color(0xFFCE9FFC)
                                            .withOpacity(0.6),
                                        offset: const Offset(1.1, 4.0),
                                        blurRadius: 8.0),
                                  ],
                                  gradient: LinearGradient(
                                    colors: [
                                     Color(0xFFCE9FFC),
                                   Color(0xFF7367F0) ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
         
         
                                    ),
                                    child: Column(
                                      children: [
                                        Text("D.charges", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),)
                                          ,SizedBox(height: 5,),
                                          
                                          Text("${data?.deliveryCharges ?? '0'}", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),)
                                    ],
                                    ),
                                  ),
         
           Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                    
                                    decoration: BoxDecoration( 
                                      borderRadius: BorderRadius.circular(8),
                                    boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Color(0xFF81FBB8)
                                            .withOpacity(0.6),
                                        offset: const Offset(1.1, 4.0),
                                        blurRadius: 8.0),
                                  ],
                                  gradient: LinearGradient(
                                    colors: [
                                     Color(0xFF81FBB8),
                                   Color(0xFF28C76F) ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
         
         
                                    ),
                                    child: Column(
                                      children: [
                                        Text("grand Total", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),)
                                          ,SizedBox(height: 5,),
                                          
                                          Text("${data?.grandTotal ?? '0'}", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),)
                                    ],
                                    ),
                                  ),
         
                                  
         
                      ],
                    ),
                  ),
                ),
         SizedBox(height: 10,),
         if(data?.topDish?.name != null)
                 Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text("Top Dish", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(17), fontWeight: FontWeight.bold),)),
             
         if(data?.topDish?.name != null)
              Center(
                child: Container(
                  padding:  const EdgeInsets.all(10),
                  width: width * 0.90,
                   decoration: BoxDecoration( 
                                      borderRadius: BorderRadius.circular(8),
                                    boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Color(0xFF97ABFF)
                                            .withOpacity(0.6),
                                        offset: const Offset(1.1, 4.0),
                                        blurRadius: 8.0),
                                  ],
                                  gradient: LinearGradient(
                                    colors: [
                                     Color(0xFF97ABFF),
                                   Color(0xFF123597) ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
         
         
                                    ),

                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                          Text("${data?.topDish?.name ?? ''}",
                                          style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.bold),
                                          ),
                                           Text("${data?.topDish?.restaurantName ?? ''}",
                                          style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w500),
                                          )
                                        ]),

                                        Column(
                                          children: [
                                               Container(
                        padding: const EdgeInsets.all(8),
                         decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.whitecolor),
                      child: Text("${data?.topDish?.count ?? 0}", style: TextStyle(color: Color(0xFF123597), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.bold),),
                      ),
                      Text("Rs ${data?.topDish?.price ?? ''}",
                                          style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w500),
                                          )
                                          ],
                                        )
                                      ],
                                    ),
                                   
                ),
              ),


 SizedBox(height: 10,),
         if(data?.topRestaurant?.restaurantName != null)
                 Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text("Top restaurant", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(17), fontWeight: FontWeight.bold),)),
             
         if(data?.topRestaurant?.restaurantName != null)
              Center(
                child: Container(
                  padding:  const EdgeInsets.all(10),
                  width: width * 0.90,
                   decoration: BoxDecoration( 
                                      borderRadius: BorderRadius.circular(8),
                                    boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Color(0xFF00EAFF)
                                            .withOpacity(0.6),
                                        offset: const Offset(1.1, 4.0),
                                        blurRadius: 8.0),
                                  ],
                                  gradient: LinearGradient(
                                    colors: [
                                     Color(0xFF00EAFF),
                                   Color(0xFF3C8CE7) ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
         
         
                                    ),

                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                          Text("${data?.topRestaurant?.restaurantName ?? ''}",
                                          style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.bold),
                                          ),
                                         
                                        ]),

                                        Column(
                                          children: [
                                               Container(
                        padding: const EdgeInsets.all(8),
                         decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.whitecolor),
                      child: Text("${data?.topRestaurant?.count ?? 0}", style: TextStyle(color: Color(0xFF3C8CE7), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.bold),),
                      ),
                     
                                          ],
                                        )
                                      ],
                                    ),
                                   
                ),
              ),

SizedBox(height: 10,),

   Container( 
              width: double.infinity,
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
         border:  Border(
        bottom: BorderSide( color: AppColors.lightgreycolor.withOpacity(0.5)),
      )
          ),
              child:  Text("Grocery", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(17), fontWeight: FontWeight.bold),),
             ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text("Sales", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(17), fontWeight: FontWeight.bold),)),
                Center(
                  child: Container(
                    child: Wrap(
                      spacing: 10,
                      children: [
                                                        Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                    
                                    decoration: BoxDecoration( 
                                      borderRadius: BorderRadius.circular(8),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Color(0xFFFFB295)
                                            .withOpacity(0.6),
                                        offset: const Offset(1.1, 4.0),
                                        blurRadius: 8.0),
                                  ],
                                  gradient: LinearGradient(
                                    colors: [
                                     Color(0xFFFA7D82),
                                   Color(0xFFFFB295) ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
         
                                    ),
                                    child: Column(
                                      children: [
                                        Text("Sub Total", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),)
                                          ,SizedBox(height: 5,),
                                          
                                          Text("${gdata?.subTotal ?? '0'}", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),)
                                    ],
                                    ),
                                  ),
                          Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                    
                                    decoration: BoxDecoration( 
                                      borderRadius: BorderRadius.circular(8),
                                    boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Color(0xFFCE9FFC)
                                            .withOpacity(0.6),
                                        offset: const Offset(1.1, 4.0),
                                        blurRadius: 8.0),
                                  ],
                                  gradient: LinearGradient(
                                    colors: [
                                     Color(0xFFCE9FFC),
                                   Color(0xFF7367F0) ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
         
         
                                    ),
                                    child: Column(
                                      children: [
                                        Text("D.charges", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),)
                                          ,SizedBox(height: 5,),
                                          
                                          Text("${gdata?.deliveryCharges ?? '0'}", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),)
                                    ],
                                    ),
                                  ),
         
           Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                                    
                                    decoration: BoxDecoration( 
                                      borderRadius: BorderRadius.circular(8),
                                    boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Color(0xFF81FBB8)
                                            .withOpacity(0.6),
                                        offset: const Offset(1.1, 4.0),
                                        blurRadius: 8.0),
                                  ],
                                  gradient: LinearGradient(
                                    colors: [
                                     Color(0xFF81FBB8),
                                   Color(0xFF28C76F) ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
         
         
                                    ),
                                    child: Column(
                                      children: [
                                        Text("grand Total", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),)
                                          ,SizedBox(height: 5,),
                                          
                                          Text("${gdata?.grandTotal ?? '0'}", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),)
                                    ],
                                    ),
                                  ),
         
                                  
         
                      ],
                    ),
                  ),
                ),
         SizedBox(height: 10,),
         if(data?.topDish?.name != null)
                 Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text("Top Products", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(17), fontWeight: FontWeight.bold),)),
             
         if(gdata?.topProducts?.name != null)
              Center(
                child: Container(
                  padding:  const EdgeInsets.all(10),
                  width: width * 0.90,
                   decoration: BoxDecoration( 
                                      borderRadius: BorderRadius.circular(8),
                                    boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Color(0xFF97ABFF)
                                            .withOpacity(0.6),
                                        offset: const Offset(1.1, 4.0),
                                        blurRadius: 8.0),
                                  ],
                                  gradient: LinearGradient(
                                    colors: [
                                     Color(0xFF97ABFF),
                                   Color(0xFF123597) ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
         
         
                                    ),

                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                          Text("${gdata?.topProducts?.name ?? ''}",
                                          style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.bold),
                                          ),
                                          //  Text("${data?.topDish?.restaurantName ?? ''}",
                                          // style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w500),
                                          // )
                                        ]),

                                        Column(
                                          children: [
                                               Container(
                        padding: const EdgeInsets.all(8),
                         decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.whitecolor),
                      child: Text("${gdata?.topProducts?.count ?? 0}", style: TextStyle(color: Color(0xFF123597), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.bold),),
                      ),
                      Text("Rs ${gdata?.topProducts?.price ?? ''}",
                                          style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w500),
                                          )
                                          ],
                                        )
                                      ],
                                    ),
                                   
                ),
              ),


 SizedBox(height: 10,),
         if(gdata?.topCategory?.categoryName != null)
                 Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text("Top Category", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(17), fontWeight: FontWeight.bold),)),
             
         if(gdata?.topCategory?.categoryName != null)
              Center(
                child: Container(
                  padding:  const EdgeInsets.all(10),
                  width: width * 0.90,
                   decoration: BoxDecoration( 
                                      borderRadius: BorderRadius.circular(8),
                                    boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Color(0xFF00EAFF)
                                            .withOpacity(0.6),
                                        offset: const Offset(1.1, 4.0),
                                        blurRadius: 8.0),
                                  ],
                                  gradient: LinearGradient(
                                    colors: [
                                     Color(0xFF00EAFF),
                                   Color(0xFF3C8CE7) ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
         
         
                                    ),

                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                          Text("${gdata?.topCategory?.categoryName ?? ''}",
                                          style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.bold),
                                          ),
                                         
                                        ]),

                                        Column(
                                          children: [
                                               Container(
                        padding: const EdgeInsets.all(8),
                         decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.whitecolor),
                      child: Text("${gdata?.topCategory?.count ?? 0}", style: TextStyle(color: Color(0xFF3C8CE7), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.bold),),
                      ),
                     
                                          ],
                                        )
                                      ],
                                    ),
                                   
                ),
              ),

SizedBox(height: 10,),
         if(gdata?.topBrand?.brandName != null)
                 Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text("Top Brand", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(17), fontWeight: FontWeight.bold),)),
             
         if(gdata?.topBrand?.brandName != null)
              Center(
                child: Container(
                  padding:  const EdgeInsets.all(10),
                  width: width * 0.90,
                   decoration: BoxDecoration( 
                                      borderRadius: BorderRadius.circular(8),
                                    boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Color(0xFFF8D800)
                                            .withOpacity(0.6),
                                        offset: const Offset(1.1, 4.0),
                                        blurRadius: 8.0),
                                  ],
                                  gradient: LinearGradient(
                                    colors: [
                                     Color(0xFFF8D800),
                                   Color(0xFFFDEB71) ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
         
         
                                    ),

                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                          Text("${gdata?.topBrand?.brandName ?? ''}",
                                          style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.bold),
                                          ),
                                         
                                        ]),

                                        Column(
                                          children: [
                                               Container(
                        padding: const EdgeInsets.all(8),
                         decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.whitecolor),
                      child: Text("${gdata?.topBrand?.count ?? 0}", style: TextStyle(color: Color(0xFF3C8CE7), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.bold),),
                      ),
                     
                                          ],
                                        )
                                      ],
                                    ),
                                   
                ),
              ),

              SizedBox(height: height * 0.80,)
              ],
            ),
           ),
         ),
    );
  }
}