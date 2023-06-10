

import 'dart:convert';

import 'package:admin/components/DeliveryChargesBottomSheet.dart';
import 'package:admin/constants/CustomSnackBar.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/DeliveryChargesModel.dart';
import 'package:admin/navigation/DrawerNavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

class DeliveryChargesScreen extends StatefulWidget {
  const DeliveryChargesScreen({super.key});

  @override
  State<DeliveryChargesScreen> createState() => _DeliveryChargesScreenState();
}

class _DeliveryChargesScreenState extends State<DeliveryChargesScreen> {
    final DeliveryChargesController listController = Get.put(DeliveryChargesController());
bool loading = false;

@override
void initState(){
 WidgetsBinding.instance!
        .addPostFrameCallback((_) {
         if((listController?.list?.length ?? 0) > 0){
         }
            getListHandler();
         
        });
  super.initState();
}


Future<void> getListHandler() async{
 loading = true;
    setState(() {});
  try{
    List<DeliveryChargesModel> _list = [];

      var response = await http.get(Uri.parse(ApiServices.delivery_charges));
  loading = false;
    setState(() {});
    
   if(response.statusCode == 200){
    final responseBody = json.decode(response.body);
      for(var json in responseBody){
     
      _list.add(DeliveryChargesModel.fromJson(json));
       }

listController.addAlllists(_list);

   }
  }
  catch(e){
      loading = false;
    setState(() {});
    CustomSnackBar().ErrorSnackBar();
  }
}


Future<void> addHandler(dynamic data) async{
 loading = true;
    setState(() {});
  try{
    List<DeliveryChargesModel> _list = [];

      var response = await http.post(Uri.parse(ApiServices.delivery_charges), body: data);
  loading = false;
    setState(() {});
    
   if(response.statusCode == 200){
    final responseBody = json.decode(response.body);
      for(var json in responseBody){
     
      _list.add(DeliveryChargesModel.fromJson(json));
       }

listController.addAlllists(_list);

   }
  }
  catch(e){
      loading = false;
    setState(() {});
    CustomSnackBar().ErrorSnackBar();
  }
}


Future<void> deleteHandler(int id) async{
 loading = true;
    setState(() {});
  try{
    List<DeliveryChargesModel> _list = [];

      var response = await http.delete(Uri.parse("${ApiServices.delivery_charges}/${id}"));
  loading = false;
    setState(() {});
    
   if(response.statusCode == 200){
    final responseBody = json.decode(response.body);
      for(var json in responseBody){
     
      _list.add(DeliveryChargesModel.fromJson(json));
       }

listController.addAlllists(_list);

   }
  }
  catch(e){
      loading = false;
    setState(() {});
    CustomSnackBar().ErrorSnackBar();
  }
}


Future<void> updateHandler(DeliveryChargesModel value) async{
 loading = true;
    setState(() {});
  try{
    List<DeliveryChargesModel> _list = [];
   final data = json.encode(value);

      var response = await http.put(Uri.parse("${ApiServices.delivery_charges}"), body: data);
  loading = false;
    setState(() {});
    
   if(response.statusCode == 200){
    final responseBody = json.decode(response.body);
      for(var json in responseBody){
     
      _list.add(DeliveryChargesModel.fromJson(json));
       }

listController.addAlllists(_list);

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
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child:  Scaffold(
        drawer: DrawerMenu(),
        appBar: AppBar(
        
          title: Text("Delivery Charges"),
          actions: [
            InkWell(
              onTap: (){
                AddDeliveryCharges(context, addHandler);
              },
              child:  Icon(Icons.add_circle_outline_rounded, color: AppColors.whitecolor,size: ScreenUtil().setSp(20),),
            ),

            SizedBox(width: 10,),
          ],
        ),

        body: RefreshIndicator(
          onRefresh: () async{
           listController.addAlllists([]);

              
            await getListHandler();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              
              children: [
                  if(loading)
                           LinearProgressIndicator(
                            
                            backgroundColor: AppColors.whitecolor,
                             valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),  
                minHeight: 10,
                          ),
                 Container(
                  width: width,
                  padding: const EdgeInsets.all(10),
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
                        children: [
                          Container(
                            width: width / 3.5,
                            child: Text("From ", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.bold),),
                          ),
                          Container(
                            width: width / 3.5,
                            child: Text("To ", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.bold),),
                          ),
                           Container(
                            width: width / 3.1,
                            child: Text("Charges ", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.bold),),
                          ),
                          
                        ],
                      ),
                 ),
                 ListView.builder(
                  shrinkWrap: true,
                  itemCount: listController.list?.length,
                  itemBuilder: (context, int index){
                    final val = listController.list[index];
                    return Slidable(
                       startActionPane: ActionPane(
                              extentRatio: 0.25,
                               motion: const ScrollMotion(),
children:  [
      // A SlidableAction can have an icon and/or a label.
      SlidableAction(
        onPressed: ((context) {
          UpdateDeliveryCharges(context, val, updateHandler);
        }),
        backgroundColor: AppColors.pricecolor,
        foregroundColor: Colors.white,
        icon: Icons.update,
        label: 'Update',
      )
    ],
                             ) ,
                             endActionPane: ActionPane(
                              extentRatio: 0.25,
                               motion: const ScrollMotion(),
children:  [
      // A SlidableAction can have an icon and/or a label.
      SlidableAction(
         onPressed: ((context) {
         deleteHandler(val?.id ?? 0);
        }),
        backgroundColor: Color(0xFFFE4A49),
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: 'Delete',
      )
    ],
                             ) ,
                       
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                                      width: width,
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                          children: [
                            Container(
                              width: width / 3.5,
                              child: Text("${val?.minKms ?? ''} kms", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w400),),
                            ),
                            Container(
                              width: width / 3.5,
                              child: Text("${val?.maxKms ?? ''} kms", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w400),),
                            ),
                             Container(
                              width: width / 3.1,
                              child: Text("Rs ${val?.price ?? ''} ", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w400),),
                            ),
                            
                          ],
                        ),
                                     ),
                    );
                 }),
                 SizedBox(height: MediaQuery.of(context).size.height,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeliveryChargesController extends GetxController{
 List<DeliveryChargesModel> list = [];
  addAlllists(List<DeliveryChargesModel> data) => list = data;

}