


import 'dart:convert';

import 'package:admin/Provider/CategoryProvider.dart';
import 'package:admin/Provider/groceryProductsProvider.dart';
import 'package:admin/components/CustomAlertDialog.dart';
import 'package:admin/components/SearchDish.dart';
import 'package:admin/components/SearchGroceryProductModel.dart';
import 'package:admin/constants/CustomSnackBar.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/GroceryCouponModel.dart';
import 'package:admin/model/SearchProductModel.dart';
import 'package:admin/screen/CouponsScreen/CouponScreen.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ViewGroceryCouponScreen extends StatefulWidget {
  final GroceryCouponModel coupon;
  const ViewGroceryCouponScreen({super.key,required this.coupon});

  @override
  State<ViewGroceryCouponScreen> createState() => _ViewGroceryCouponScreenState();
}

class _ViewGroceryCouponScreenState extends State<ViewGroceryCouponScreen> {
   GroceryCouponModel? detail;
   bool editMode = true;
  final formGlobalKey = GlobalKey < FormState > ();
    bool loading = false;
   int? include_product = 0;
    String? type;
 String? typeName;
 List<SearchProductModel> products = [];

 List<dynamic> list = [
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

 void initState(){
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
List<SearchProductModel> arr = [];
for(int i = 0; i < (widget?.coupon?.items?.length ?? 0); i++){
  arr.add(SearchProductModel(
   groceryId: widget?.coupon?.items?[i]?.groceryId,
   price: widget?.coupon?.items?[i]?.price,
   salePrice: widget?.coupon?.items?[i]?.salePrice,
   regularPrice: widget?.coupon?.items?[i]?.regularPrice,
   name: widget?.coupon?.items?[i]?.name,
   image: widget?.coupon?.items?[i]?.image,
  ));
}

print("arr ${arr?.length}");
 textInputController["coupon_code"]?.text = widget?.coupon?.couponCode ?? '';
textInputController["amount"]?.text = widget?.coupon?.amount?.toString() ?? '0';
textInputController["minimum_amount"]?.text = widget?.coupon?.minimumAmount?.toString() ?? '0';
textInputController["maximum_amount"]?.text = widget?.coupon?.maximumAmount?.toString() ?? '0';
 textInputController["start_time"]?.text = widget?.coupon?.startTime ?? '';
 textInputController["end_time"]?.text = widget?.coupon?.endTime ?? '';
 textInputController["usage_limit"]?.text = widget?.coupon?.usageLimit?.toString() ?? '';
 textInputController["usage_limit_per_user"]?.text = widget?.coupon?.usageLimitPerUser?.toString() ?? '';
include_product = widget?.coupon?.includeProduct;
type = widget?.coupon?.type?.toString();
typeName = "1";

products = arr;
detail = widget.coupon;
setState(() {});
  });

  super.initState();
 }
   
Future<void> deleteHandler() async{
    final list = Provider.of<CouponProvider>(context, listen: false);

  try{
       loading = true;
    setState(() {});
var response = await http.delete(Uri.parse("${ApiServices.coupon}${widget?.coupon?.id}?type=2"));
     loading = false;
    setState(() {});
    if(response.statusCode == 200){

 CustomSnackBar().ErrorMsgSnackBar("deleted");
list.deleteGrocery(widget?.coupon?.id ?? 0);
    }else{
       CustomSnackBar().ErrorSnackBar();

    }
    
     Navigator.of(context).pop();
  }catch(e){
        loading = false;
    setState(() {});
   CustomSnackBar().ErrorSnackBar();


  }
}


  Future<void> AddCouponHandler(BuildContext context, StateSetter myState) async{
   final list = Provider.of<CouponProvider>(context, listen: false);

  try{
    loading = true;
    setState(() {});


dynamic data = {
  "id": widget?.coupon?.id?.toString(),
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
         "items": include_product ==  1 ?  products?.map((e) => e?.groceryId?.toString()).toList() : []
      
      };
     var jsonString = json.encode(data);
      var header ={
  'Content-type': 'application/json'
 };

     var response = await http.put(Uri.parse("${ApiServices.coupon}?type=2"),  body: jsonString, headers: header);
    loading = false;
    setState(() {});

     if(response?.statusCode == 200){
      CustomSnackBar().ErrorMsgSnackBar("Updated");
      final responseBody = jsonDecode(response.body);
      print(responseBody);
      GroceryCouponModel _data = GroceryCouponModel.fromJson(responseBody);
      print(_data?.id);
      if(_data?.id != null){
        list.updateGrocery(_data);
      }
     }else{
      CustomSnackBar().ErrorSnackBar();
     }
          Navigator.of(context).pop();

  }
  catch(e){
    loading = false;
    setState(() {});
   CustomSnackBar().ErrorSnackBar();
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




  @override
  Widget build(BuildContext context) {

 BoxDecoration boxdecoration =  BoxDecoration(
                                        color: Colors.white.withOpacity(editMode ? 1 : 0.7),
                                        borderRadius: BorderRadius.circular(13),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(0, 4),
                                            blurRadius: 20,
                                            color: const Color(0xFFB0CCE1).withOpacity(0.29),
                                          ),
                                        ],
                                      );    
  double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return  Scaffold(
      backgroundColor: AppColors.whitecolor,
      bottomSheet:
      !editMode ?
       FadeInUp( 
        animate: !editMode,
        delay: Duration(seconds: 1),
        child: Container(
             height: height * 0.08,
             width: width,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration( 
              borderRadius: BorderRadius.circular(10)
            ),

          child:   InkWell( 
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
       ) : SizedBox(),
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: () {
              print("hhh");
             
              showDialog(context: context, builder: (BuildContext context) =>  CustomAlertDialog(title: "Delete", message: "Are you Delete to this?", ok: (){
              Navigator.of(context).pop();
                deleteHandler();
              }));

            },
            child: Container( 
              margin: const EdgeInsets.only(right: 20),
              child: Icon(Icons.delete, color: AppColors.whitecolor, size: ScreenUtil().setSp(20),),
            ),
          ),
          InkWell(
            onTap: () {
              editMode = !editMode;
              setState(() {});
            },
            child: Container( 
              margin: const EdgeInsets.only(right: 20),
              child: Icon(Icons.edit, color: AppColors.whitecolor, size: ScreenUtil().setSp(20),),
            ),
          )
        ],
        backgroundColor: AppColors.primaryColor,
        title: Text(
       detail?.couponCode ?? '',
       style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(18))
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
                                    readOnly: editMode,
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
                                    readOnly: editMode,
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
                                    readOnly: editMode,
                                    controller: textInputController["minimum_amount"],
                                      validator: ((value){
                              if(value == "0") return "Minimum Amount is required";
                              if(value == "") return "Minimum Amount is required";
                             //if(int.parse(textInputController["amount"]?.value.text ?? "0") < int.parse(value ?? "0")) return "Amount must be lesser than min amount";
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
                                    readOnly: editMode,
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
                                  if(editMode) return;
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
                                  if(editMode) return;
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
                                    readOnly: editMode,
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
                                    readOnly: editMode,
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

  ListView.builder(
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

            )   );
  }
}