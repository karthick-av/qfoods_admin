

import 'dart:convert';

import 'package:admin/Provider/CategoryProvider.dart';
import 'package:admin/Provider/groceryProductsProvider.dart';
import 'package:admin/components/SearchDish.dart';
import 'package:admin/components/SearchGroceryProductModel.dart';
import 'package:admin/constants/CustomSnackBar.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/CategoryDishesModel.dart';
import 'package:admin/model/CouponModel.dart';
import 'package:admin/model/GroceryCouponModel.dart';
import 'package:admin/model/SearchProductModel.dart';
import 'package:admin/screen/CouponsScreen/CouponScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

void AddCoupon(BuildContext context){
  double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final formGlobalKey = GlobalKey < FormState > ();
    bool loading = false;
   String start_date = "";
   String start_time = "";
   int? include_product = 0;
    String? type;
 String? typeName;
 List<CategoryDishesModel> dishes = [];
List<SearchProductModel> products = [];
 List<dynamic> list = [
    {"id": "1", "label": "restaurant"},
    {"id": "2", "label": "grocery"},
  ];



late final Map<String, TextEditingController> textInputController = {
  "coupon_code": TextEditingController(),
   "amount": TextEditingController(),
   "minimum_amount": TextEditingController(text: "0"),
   "maximum_amount": TextEditingController(text: "0"),
   "start_time": TextEditingController(),
   "end_time": TextEditingController(),
    "usage_limit": TextEditingController(),
   "usage_limit_per_user": TextEditingController()
  };


  Future<void> AddCouponHandler(BuildContext context, StateSetter myState) async{
  final list = Provider.of<CouponProvider>(context, listen: false);
loading = true;
myState((){});
  try{
    
dynamic data = {
         "coupon_code": textInputController["coupon_code"]?.value.text?.toString(),
         "amount": textInputController["amount"]?.value.text?.toString(),
         "minimum_amount": textInputController["minimum_amount"]?.value.text?.toString(),
       "maximum_amount": textInputController["maximum_amount"]?.value.text?.toString(),
         "start_time": textInputController["start_time"]?.value.text?.toString(),
         "end_time": textInputController["end_time"]?.value.text?.toString(),
          "usage_limit": textInputController["usage_limit"]?.value.text?.toString(),
         "usage_limit_per_user": textInputController["usage_limit_per_user"]?.value.text?.toString(),
         "include_product": include_product?.toString(),
         "type": type,
         "items": include_product ==  1 ?  (
          type == "1" ? dishes?.map((e) => e?.dishId?.toString()).toList() : products?.map((e) => e?.groceryId?.toString()).toList()
         ) : []
      
      };
     var jsonString = json.encode(data);
      var header ={
  'Content-type': 'application/json'
 };

     var response = await http.post(Uri.parse("${ApiServices.coupon}"),  body: jsonString, headers: header);
  loading =false;
myState((){});
   if(response?.statusCode == 200){
      CustomSnackBar().ErrorMsgSnackBar("Added");
      
      final responseBody = jsonDecode(response.body);
    if(responseBody["type"] == 1){
        CouponModel _data = CouponModel.fromJson(responseBody);
      print(_data?.id);
      if(_data?.id != null){
        list.addNewRestaurant(_data);
      }
    }else{
        GroceryCouponModel _data = GroceryCouponModel.fromJson(responseBody);
      print(_data?.id);
      if(_data?.id != null){
        list.addNewGrocery(_data);
      }
    }
     }else{
      CustomSnackBar().ErrorSnackBar();
     }

     Navigator.of(context).pop();
  }
  catch(e){
     loading =false;
myState((){});
    print(e);
  }
  }


Future<void> StartDateTimePicker(String type) async{
  
 final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(picked);
   // setState((){});

 TimeOfDay? pickedTime =  await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                      );
                  
                  if(pickedTime != null ){
                     final String hour = pickedTime.hour.toString().padLeft(2, '0');
  final String minute = pickedTime.minute.toString().padLeft(2, '0');
  final String second = "00";

if(type == "start_time"){
    textInputController["start_time"]!.text =  "${formatted} " + "$hour:$minute:$second";


}else{
    textInputController["end_time"]!.text =  "${formatted} " + "$hour:$minute:$second";


}
                  }
    }
}




 BoxDecoration boxdecoration =  BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(13),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(0, 4),
                                            blurRadius: 20,
                                            color: const Color(0xFFB0CCE1).withOpacity(0.29),
                                          ),
                                        ],
                                      );
  
  OutlineInputBorder focusedborder = OutlineInputBorder(
                                     borderRadius: BorderRadius.all(Radius.circular(4)),
                                     borderSide: BorderSide(width: 1,color: AppColors.primaryColor),
                                   );
  OutlineInputBorder enableborder = OutlineInputBorder(
                                     borderRadius: BorderRadius.all(Radius.circular(4)),
                                     borderSide: BorderSide(width: 1,color: Color(0XFFe9e9eb)),
                                   );


OutlineInputBorder errorborder = OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.red,
                          ));
  TextStyle labelstyle = TextStyle(fontSize: ScreenUtil().setSp(12.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.greycolor);                            

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              insetPadding: EdgeInsets.zero,
              child: Scaffold(
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
          ?
          Container( 
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
               FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
       currentFocus.focusedChild?.unfocus();
    }
               if (!formGlobalKey.currentState!.validate()) {
                          return;
                        }
                        print("object");
                        AddCouponHandler(context, setState);
                       
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
            child: Text("Add", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),),
          ),
         ),
          ),
          backgroundColor: AppColors.whitecolor,
      
                appBar: AppBar(
                  title: const Text('Add Coupon',
                  style: TextStyle(color: AppColors.whitecolor),
                  ),
                  centerTitle: false,
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ),

                body: GestureDetector(
                  onTap: (){
                        FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
       currentFocus.focusedChild?.unfocus();
    }
                  },
                  child: Form( 
                    key: formGlobalKey,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                              Container(
                              width: width * 0.90,
                                   decoration: boxdecoration,
                                   child: TextFormField(
                                    controller: textInputController["coupon_code"],
                                      validator: ((value){
                              if(value == "") return "Coupon Code is required";
                              return null;
                            }),
                                                 style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                                 cursorColor: AppColors.greycolor,
                                                decoration:  InputDecoration(
                                        labelText: 'Coupon Code',
                                          hintText: 'Coupon Code',
                                    
                                        floatingLabelStyle: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, ),
                                         focusedBorder: focusedborder,
                                         focusedErrorBorder: focusedborder,
                                         enabledBorder: enableborder,
                                          errorBorder: errorborder,
                                        labelStyle: labelstyle
                                                // TODO: add errorHint
                                                ),
                                              ),
                                 ),
                          
                            SizedBox(height: height * 0.02,),
                          
                            Container(
                              width: width * 0.90,
                                   decoration: boxdecoration,
                                   child: TextFormField(
                                    controller: textInputController["amount"],
                                      validator: ((value){
                              if(value == "") return "Amount is required";
                              return null;
                            }),
                            keyboardType: TextInputType.number,
                                                 style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                                 cursorColor: AppColors.greycolor,
                                                decoration:  InputDecoration(
                                        labelText: 'Amount',
                                          hintText: 'Amount',
                                    
                                        floatingLabelStyle: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, ),
                                         focusedBorder: focusedborder,
                                         focusedErrorBorder: focusedborder,
                                         enabledBorder: enableborder,
                                          errorBorder: errorborder,
                                        labelStyle: labelstyle
                                                // TODO: add errorHint
                                                ),
                                              ),
                                 ),
                          
                            SizedBox(height: height * 0.02,),
                          
                      
                           Container(
                            
                              width: width * 0.90,
                                   decoration: boxdecoration,
                                   child: TextFormField(
                                    controller: textInputController["minimum_amount"],
                                      validator: ((value){
                              if(value == "0") return "Minimum Amount is required";
                              if(value == "") return "Minimum Amount is required";
                          //   if(int.parse(textInputController["amount"]?.value.text ?? "0") < int.parse(value ?? "0")) return "Amount must be lesser than min amount";
                               return null;
                            }),
                            
                            keyboardType: TextInputType.number,
                                                 style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                                 cursorColor: AppColors.greycolor,
                                                decoration:  InputDecoration(
                                        labelText: 'Min Amount',
                                          hintText: 'Min Amount',
                                    
                                        floatingLabelStyle: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, ),
                                         focusedBorder: focusedborder,
                                         focusedErrorBorder: focusedborder,
                                         enabledBorder: enableborder,
                                          errorBorder: errorborder,
                                        labelStyle: labelstyle
                                                // TODO: add errorHint
                                                ),
                                              ),
                                 ),
                          
                            SizedBox(height: height * 0.02,),
                      

                       Container(
                            
                              width: width * 0.90,
                                   decoration: boxdecoration,
                                   child: TextFormField(
                                    controller: textInputController["maximum_amount"],
                                      validator: ((value){
                                        
                              if(value == "0") return "Max Amount is required";
                              if(value == "") return "Max Amount is required";
                              if(int.parse(textInputController["amount"]?.value.text ?? "0") > int.parse(value ?? "0")) return "Amount must be greater than min amount";
                              if(int.parse(textInputController["minimum_amount"]?.value.text ?? "0") > int.parse(value ?? "0")) return "Max Amount must be greater than min amount";
                              return null;
                            }),
                            
                            keyboardType: TextInputType.number,
                                                 style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                                 cursorColor: AppColors.greycolor,
                                                decoration:  InputDecoration(
                                        labelText: 'Min Amount',
                                          hintText: 'Min Amount',
                                    
                                        floatingLabelStyle: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, ),
                                         focusedBorder: focusedborder,
                                         focusedErrorBorder: focusedborder,
                                         enabledBorder: enableborder,
                                          errorBorder: errorborder,
                                        labelStyle: labelstyle
                                                // TODO: add errorHint
                                                ),
                                              ),
                                 ),
                          
                            SizedBox(height: height * 0.02,),
                      
                      
                      
                             Container(
                              width: width * 0.90,
                                   decoration: boxdecoration,
                                   child: TextFormField(
                                readOnly: true,
                                onTap: (){
                                      StartDateTimePicker("start_time");
                            
                                },
                                    controller: textInputController["start_time"],
                                      validator: ((value){
                              if(value == "") return "start time is required";
                              return null;
                                                       }),
                                                 style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                                 cursorColor: AppColors.greycolor,
                                                decoration:  InputDecoration(
                                        labelText: ' start time',
                                          hintText: 'start time',
                                    
                                        floatingLabelStyle: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, ),
                                         focusedBorder: focusedborder,
                                         focusedErrorBorder: focusedborder,
                                         enabledBorder: enableborder,
                                          errorBorder: errorborder,
                                        labelStyle: labelstyle
                                                // TODO: add errorHint
                                                ),
                                              ),
                                 ),
                          
                           SizedBox(height: height * 0.02,),
                      
                      
                      
                             Container(
                              width: width * 0.90,
                                   decoration: boxdecoration,
                                   child: TextFormField(
                              // enabled: false,
                              onTap: (){
                                  StartDateTimePicker("end_time");
                             
                              },
                               readOnly: true,
                                    controller: textInputController["end_time"],
                                      validator: ((value){
                              if(value == "") return "End time is required";
                              return null;
                                                       }),
                                                 style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                                 cursorColor: AppColors.greycolor,
                                                decoration:  InputDecoration(
                                        labelText: ' End time',
                                          hintText: 'End time',
                                    
                                        floatingLabelStyle: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, ),
                                         focusedBorder: focusedborder,
                                         focusedErrorBorder: focusedborder,
                                         enabledBorder: enableborder,
                                          errorBorder: errorborder,
                                        labelStyle: labelstyle
                                                // TODO: add errorHint
                                                ),
                                              ),
                                 ),

                                  SizedBox(height: height * 0.02,),
                          
                            Container(
                              width: width * 0.90,
                                   decoration: boxdecoration,
                                   child: TextFormField(
                                    controller: textInputController["usage_limit"],
                                      validator: ((value){
                              if(value == "") return "usage limit is required";
                              return null;
                            }),
                            keyboardType: TextInputType.number,
                                                 style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                                 cursorColor: AppColors.greycolor,
                                                decoration:  InputDecoration(
                                        labelText: 'usage limit',
                                          hintText: 'usage limit',
                                    
                                        floatingLabelStyle: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, ),
                                         focusedBorder: focusedborder,
                                         focusedErrorBorder: focusedborder,
                                         enabledBorder: enableborder,
                                          errorBorder: errorborder,
                                        labelStyle: labelstyle
                                                // TODO: add errorHint
                                                ),
                                              ),
                                 ),
                          
                          
                             SizedBox(height: height * 0.02,),
                          
                            Container(
                              width: width * 0.90,
                                   decoration: boxdecoration,
                                   child: TextFormField(
                                    controller: textInputController["usage_limit_per_user"],
                                      validator: ((value){
                              if(value == "") return "usage limit per user is required";
                              return null;
                            }),
                            keyboardType: TextInputType.number,
                                                 style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                                 cursorColor: AppColors.greycolor,
                                                decoration:  InputDecoration(
                                        labelText: 'usage limit per user',
                                          hintText: 'usage limit per user',
                                    
                                        floatingLabelStyle: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, ),
                                         focusedBorder: focusedborder,
                                         focusedErrorBorder: focusedborder,
                                         enabledBorder: enableborder,
                                          errorBorder: errorborder,
                                        labelStyle: labelstyle
                                                // TODO: add errorHint
                                                ),
                                              ),
                                 ),
                          
                          
                            SizedBox(height: height * 0.02,),
                          
                            Container(
                              width: width * 0.90,
                                   decoration: boxdecoration,
                                   child: DropdownButtonFormField<String>(
                autovalidateMode: AutovalidateMode.always,
                value: typeName,
                items: list.map(
                  (value) {
                    return DropdownMenuItem<String>(
                      value: value["id"],
                      child: Text(
                        value["label"],
                      ),
                    );
                  },
                ).toList(),
                hint: const Text("Choose"),
                onChanged: (String? value) {
                 type = value;
                  setState(() {});
                },
                validator: (String? value) {
                  return value == null ? "Choose item from list" : null;
                },
              ),
                            ),

  SizedBox(height: height * 0.02,),
                          
                     Container(
                              width: width * 0.90,
                                   decoration: boxdecoration,
                                   padding: const EdgeInsets.all(10),
                     child: Row(
                      children: [
                        Text("Include Products", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY,
                        fontWeight: FontWeight.w500,
                         fontSize: ScreenUtil().setSp(16)),),


                         Switch(value: include_product == 1, onChanged: (bool val){
                          include_product = val ? 1 : 0;
                          setState((){});
                         })
                      ],
                     ),
                     ),



  SizedBox(height: height * 0.02,),

                     if(include_product == 1)     
                     InkWell(
                      onTap: (){
                     
                     if(type == "1"){
                        final SelectedProvider = Provider.of<SelectedCategoryProvider>(context, listen: false);
          
                   SelectedProvider.addSelectedDishes(dishes);
           SearchDish(context, (List<CategoryDishesModel> sdishes) async{
            List<CategoryDishesModel> arr = [];
            print("sdishes ${sdishes?.length}");

             for(int i = 0; i < sdishes!.length; i++){
               if((dishes?.where((e) => e?.dishId == sdishes[i]?.dishId)?.length ?? 0) > 0){
               }else{
             arr.add(sdishes[i]);
               }
             }
              print("dishes== ${dishes?.length}");
  print("arr== ${arr?.length}");
 
             dishes = [...dishes, ...arr];
             setState((){});
           });
                     }else{
                        final SelectedProvider = Provider.of<SearchGroceryProductsProvider>(context, listen: false);
          
                   SelectedProvider.addSelectedProducts(products);
           SearchGroceryProduct(context, (List<SearchProductModel> sproducts) async{
            List<SearchProductModel> arr = [];
          
             for(int i = 0; i < sproducts!.length; i++){
               if((products?.where((e) => e?.groceryId == sproducts[i]?.groceryId)?.length ?? 0) > 0){
               }else{
             arr.add(sproducts[i]);
               }
             }
             products = [...products, ...arr];
             setState((){});
           });
                     }
                      },
                       child: Container(
                                width: width * 0.90,
                                alignment: Alignment.center,
                                     decoration: BoxDecoration(
                                          color: AppColors.primaryColor,
                                          borderRadius: BorderRadius.circular(13),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(0, 4),
                                              blurRadius: 20,
                                              color: const Color(0xFFB0CCE1).withOpacity(0.29),
                                            ),
                                          ],
                                        ),
                                     padding: const EdgeInsets.all(10),
                                     child: Text("Add Products", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(16), fontWeight: FontWeight.w500),),
                       ),
                     ),
  SizedBox(height: height * 0.02,),
type == "1"
?
  ListView.builder(
  padding: const EdgeInsets.all(10),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: dishes?.length ?? 0,
                    itemBuilder: (BuildContext context, int index){
                    return Container(
                      decoration: boxdecoration,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                            Text("${dishes?[index]?.name ?? ''}",
                                            style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.bold),
                                            ),
                                             Text("${dishes?[index]?.restaurantName ?? ''}",
                                            style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w500),
                                            )
                                          ]),

                         InkWell(
                          onTap: (){
                            dishes.removeWhere((e) => e?.dishId == dishes[index]?.dishId);
                            setState((){});
                          },
                           child: Icon(
                            
                            Icons.cancel_rounded, color: AppColors.primaryColor, size: ScreenUtil().setSp(25),),
                         )                 
                        ],
                      ),
                    );
                    }   
  )
  :   ListView.builder(
  padding: const EdgeInsets.all(10),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: products?.length ?? 0,
                    itemBuilder: (BuildContext context, int index){
                    return Container(
                      decoration: boxdecoration,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                            Text("${products?[index]?.name ?? ''}",
                                            style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.bold),
                                            ),
                                           
                                          ]),

                         InkWell(
                          onTap: (){
                            products.removeWhere((e) => e?.groceryId == products[index]?.groceryId);
                            setState((){});
                          },
                           child: Icon(
                            
                            Icons.cancel_rounded, color: AppColors.primaryColor, size: ScreenUtil().setSp(25),),
                         )                 
                        ],
                      ),
                    );
                    }   
  ),


                               SizedBox(height: height * 0.10,),
                          ]
                        ),
                      )
                    )
              )

            )),
            );

          }
        );
      });



}