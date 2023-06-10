

import 'dart:convert';

import 'package:admin/Provider/groceryProductsProvider.dart';
import 'package:admin/constants/CustomSnackBar.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/GroceryProductModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;


void GroceryVariantItemForm(BuildContext context, VariantItems variant,int id,void Function(GroceryProductModel data) ModifyProduct){
  double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
  
   final formGlobalKey = GlobalKey < FormState > ();

  TextStyle textstyle = TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor);
OutlineInputBorder focusedborder = OutlineInputBorder(
                                   borderRadius: BorderRadius.all(Radius.circular(4)),
                                   borderSide: BorderSide(width: 1,color: Color(0XFFe9e9eb)),
                                 );
OutlineInputBorder enableborder = OutlineInputBorder(
                                   borderRadius: BorderRadius.all(Radius.circular(4)),
                                   borderSide: BorderSide(width: 1,color: Color(0XFFe9e9eb)),
                                 );

  TextStyle labelstyle = TextStyle(fontSize: ScreenUtil().setSp(12.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.greycolor);                               


BoxDecoration boxdecoration = BoxDecoration(
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
late final Map<String, TextEditingController> textInputController = {
  "name": TextEditingController(),
  "regular_price": TextEditingController(),
  "sales_price": TextEditingController(),
  "description": TextEditingController(),
  };

  int status = 0;
  int visible= 0;

  bool loading = false;

  void addVariantItemHandler(BuildContext cxt,StateSetter setState) async{

loading = true;
setState((){});

 try{
      dynamic data = {
        "grocery_id": id?.toString(),
        "variant_id": variant.id?.toString(),
         "name": textInputController["name"]?.value.text?.toString(),
         "description":textInputController["description"]?.value.text?.toString(),
        "regular_price":textInputController["regular_price"]?.value.text?.toString(),
        "price":textInputController["regular_price"]?.value.text?.toString(),
      "sale_price":textInputController["sales_price"]?.value.text == "" ? "0" : textInputController["sales_price"]?.value.text?.toString(),
      "status": status?.toString() ,
      };
         var header ={
  'Content-type': 'application/json'
 };
    var response = await http.post(Uri.parse("${ApiServices.add_grocery_variant_item}"), body: data);
    print(response.statusCode);

loading = false;
setState((){});

     if(response.statusCode == 200){
        var response_body = json.decode(response.body);
        CustomSnackBar().ErrorMsgSnackBar("Variant Item Added");
  Navigator.of(cxt).pop();
        GroceryProductModel product = GroceryProductModel.fromJson(response_body); 
          Provider.of<GroceryProductsProvider>(context, listen: false).updateProduct(product);
         ModifyProduct(product);
      
     }
    }catch(e){
print(e);
CustomSnackBar().ErrorSnackBar();
 Navigator.of(cxt).pop();
  
  
loading = false;
setState((){});
    }
  }

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
             addVariantItemHandler(context,setState);
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
      
                appBar: AppBar(
                  title: const Text('Add Variant Item',
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
                      child: Column(
                        children: [
                                  Container(
                          margin: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                          decoration: boxdecoration,
                          child:   TextFormField(
                           controller: textInputController["name"],
                       validator: ((value){
                                        if(value == "") return "Name is required";
                                        return null;
                                      }),
                                                           style: textstyle,
                                                           cursorColor: AppColors.greycolor,
                                                           decoration:  InputDecoration(
                                                  labelText: 'Name',
                                                    hintText: 'Enter Dish Name',
                                                   focusedBorder: focusedborder,
                                                   enabledBorder: enableborder,
                                                  labelStyle: labelstyle  ),
                          
                                                        ),
                        ),
                
                
                         Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                      decoration: boxdecoration,
                      child:   TextFormField(
                        keyboardType: TextInputType.number,
                      
                           controller: textInputController["regular_price"],
                         validator: ((value){
                                    if(value == "") return "Price is required";
                                    return null;
                                  }),
                                                       style: textstyle,
                                                       cursorColor: AppColors.greycolor,
                                                       decoration:  InputDecoration(
                                              labelText: 'Price',
                                                hintText: 'Enter Price',
                                               focusedBorder: focusedborder,
                                               enabledBorder: enableborder,
                                              labelStyle: labelstyle  ),
                      
                                                    ),
                    ),
                        
                        
                     Container(
                      
                      margin: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                      decoration: boxdecoration,
                      child:   TextFormField( 
                      
                        keyboardType: TextInputType.number,
                                 controller: textInputController["sales_price"],
                               style: textstyle,
                                                       cursorColor: AppColors.greycolor,
                                                       decoration:  InputDecoration(
                                              labelText: 'Sales Price',
                                                hintText: 'Enter Sales Price',
                                               focusedBorder: focusedborder,
                                               enabledBorder: enableborder,
                                              labelStyle: labelstyle  ),
                      
                                                    ),
                    ),
                        
                        
                        
                         Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                      decoration: boxdecoration,
                      child:   TextFormField(
                           
                                 controller: textInputController["description"],
                       
                              maxLines: 5, // <-- SEE HERE
                                  minLines: 1,
                               
                    validator: ((value){
                                    if(value == "") return "Description is required";
                                    return null;
                                  }),
                                                       style: textstyle,
                                                       cursorColor: AppColors.greycolor,
                                                       decoration:  InputDecoration(
                                              labelText: 'Description',
                                                hintText: 'Enter Description',
                                               focusedBorder: focusedborder,
                                               enabledBorder: enableborder,
                                              labelStyle: labelstyle  ),
                      
                                                    ),
                    ),
                           SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Wrap(
                  spacing: 20,
                  children: [
                    Column(
                      children: [
                        Text("Status", style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w500),),
                        Switch(value: status ==  1 ? true : false, onChanged: (value){
                        status = status == 1 ? 0 : 1;
                         setState(() { }); 
                        },
                        
                           activeColor: AppColors.primaryColor,  
                              activeTrackColor: Color(0xFFFDD4D7),  
                              inactiveThumbColor: AppColors.greyBlackcolor,  
                              inactiveTrackColor: AppColors.lightgreycolor,  
                          
                        )
                      ],
                    ),

                     Column(
                      children: [
                        Text("Visible", style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w500),),
                        Switch(value: visible ==  1 ? true : false, onChanged: (value){
                        visible = visible == 1 ? 0 : 1;
                         setState(() { }); 
                        },
                        
                           activeColor: AppColors.primaryColor,  
                              activeTrackColor: Color(0xFFFDD4D7),  
                              inactiveThumbColor: AppColors.greyBlackcolor,  
                              inactiveTrackColor: AppColors.lightgreycolor,  
                          
                        )
                      ],
                    ),
                    
                  ]
                      ),
                    ),
                 
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        );
      },
    ).then((value) {
      print("opne");
  // Do something when the dialog is opened
});
}

void VariantItemEditForm(BuildContext context,VariantItems variant,int id,Items item,void Function(GroceryProductModel data) ModifyProduct){

   double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
  
   final formGlobalKey = GlobalKey < FormState > ();

  TextStyle textstyle = TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor);
OutlineInputBorder focusedborder = OutlineInputBorder(
                                   borderRadius: BorderRadius.all(Radius.circular(4)),
                                   borderSide: BorderSide(width: 1,color: Color(0XFFe9e9eb)),
                                 );
OutlineInputBorder enableborder = OutlineInputBorder(
                                   borderRadius: BorderRadius.all(Radius.circular(4)),
                                   borderSide: BorderSide(width: 1,color: Color(0XFFe9e9eb)),
                                 );

  TextStyle labelstyle = TextStyle(fontSize: ScreenUtil().setSp(12.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.greycolor);                               


BoxDecoration boxdecoration = BoxDecoration(
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
late final Map<String, TextEditingController> textInputController = {
  "name": TextEditingController(text: item?.name),
  "regular_price": TextEditingController(text: item?.price?.toString()),
  "sales_price": TextEditingController(text: item?.salePrice?.toString()),
  "description": TextEditingController(text: item?.description),
  };

  int status = item?.status ?? 0;
  int visible= item?.visible ?? 0;

  bool loading = false;

  void updateVariantItemHandler(BuildContext cxt,StateSetter setState) async{

loading = true;
setState((){});

 try{
      dynamic data = {
        "variant_item_id": item?.id?.toString(),
        "grocery_id": id?.toString(),
        "variant_id": variant.id?.toString(),
         "name": textInputController["name"]?.value.text?.toString(),
         "description":textInputController["description"]?.value.text?.toString(),
        "regular_price":textInputController["regular_price"]?.value.text?.toString(),
        "price":textInputController["regular_price"]?.value.text?.toString(),
      "sale_price":textInputController["sales_price"]?.value.text == "" ? "0" : textInputController["sales_price"]?.value.text?.toString(),
      "status": status?.toString() ,
      };
         var header ={
  'Content-type': 'application/json'
 };
    var response = await http.put(Uri.parse("${ApiServices.update_grocery_variant_item}"), body: data);
    print(response.statusCode);

loading = false;
setState((){});

     if(response.statusCode == 200){
        var response_body = json.decode(response.body);
        CustomSnackBar().ErrorMsgSnackBar("Variant Item Updated");
  Navigator.of(cxt).pop();
        GroceryProductModel product = GroceryProductModel.fromJson(response_body); 
          Provider.of<GroceryProductsProvider>(context, listen: false).updateProduct(product);
         ModifyProduct(product);
      
     }
    }catch(e){
print(e);
CustomSnackBar().ErrorSnackBar();
 Navigator.of(cxt).pop();
  
  
loading = false;
setState((){});
    }
  }

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
             updateVariantItemHandler(context,setState);
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
                  title: const Text('Update Variant Item',
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
                      child: Column(
                        children: [
                                  Container(
                          margin: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                          decoration: boxdecoration,
                          child:   TextFormField(
                           controller: textInputController["name"],
                       validator: ((value){
                                        if(value == "") return "Name is required";
                                        return null;
                                      }),
                                                           style: textstyle,
                                                           cursorColor: AppColors.greycolor,
                                                           decoration:  InputDecoration(
                                                  labelText: 'Name',
                                                    hintText: 'Enter Dish Name',
                                                   focusedBorder: focusedborder,
                                                   enabledBorder: enableborder,
                                                  labelStyle: labelstyle  ),
                          
                                                        ),
                        ),
                
                
                         Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                      decoration: boxdecoration,
                      child:   TextFormField(
                        keyboardType: TextInputType.number,
                      
                           controller: textInputController["regular_price"],
                         validator: ((value){
                                    if(value == "") return "Price is required";
                                    return null;
                                  }),
                                                       style: textstyle,
                                                       cursorColor: AppColors.greycolor,
                                                       decoration:  InputDecoration(
                                              labelText: 'Price',
                                                hintText: 'Enter Price',
                                               focusedBorder: focusedborder,
                                               enabledBorder: enableborder,
                                              labelStyle: labelstyle  ),
                      
                                                    ),
                    ),
                        
                        
                     Container(
                      
                      margin: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                      decoration: boxdecoration,
                      child:   TextFormField( 
                      
                        keyboardType: TextInputType.number,
                                 controller: textInputController["sales_price"],
                               style: textstyle,
                                                       cursorColor: AppColors.greycolor,
                                                       decoration:  InputDecoration(
                                              labelText: 'Sales Price',
                                                hintText: 'Enter Sales Price',
                                               focusedBorder: focusedborder,
                                               enabledBorder: enableborder,
                                              labelStyle: labelstyle  ),
                      
                                                    ),
                    ),
                        
                        
                        
                         Container(
                      margin: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                      decoration: boxdecoration,
                      child:   TextFormField(
                           
                                 controller: textInputController["description"],
                       
                              maxLines: 5, // <-- SEE HERE
                                  minLines: 1,
                               
                    validator: ((value){
                                    if(value == "") return "Description is required";
                                    return null;
                                  }),
                                                       style: textstyle,
                                                       cursorColor: AppColors.greycolor,
                                                       decoration:  InputDecoration(
                                              labelText: 'Description',
                                                hintText: 'Enter Description',
                                               focusedBorder: focusedborder,
                                               enabledBorder: enableborder,
                                              labelStyle: labelstyle  ),
                      
                                                    ),
                    ),
                           SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Wrap(
                  spacing: 20,
                  children: [
                    Column(
                      children: [
                        Text("Status", style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w500),),
                        Switch(value: status ==  1 ? true : false, onChanged: (value){
                        status = status == 1 ? 0 : 1;
                         setState(() { }); 
                        },
                        
                           activeColor: AppColors.primaryColor,  
                              activeTrackColor: Color(0xFFFDD4D7),  
                              inactiveThumbColor: AppColors.greyBlackcolor,  
                              inactiveTrackColor: AppColors.lightgreycolor,  
                          
                        )
                      ],
                    ),

                     Column(
                      children: [
                        Text("Visible", style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w500),),
                        Switch(value: visible ==  1 ? true : false, onChanged: (value){
                        visible = visible == 1 ? 0 : 1;
                         setState(() { }); 
                        },
                        
                           activeColor: AppColors.primaryColor,  
                              activeTrackColor: Color(0xFFFDD4D7),  
                              inactiveThumbColor: AppColors.greyBlackcolor,  
                              inactiveTrackColor: AppColors.lightgreycolor,  
                          
                        )
                      ],
                    ),
                    
                  ]
                      ),
                    ),
                 
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        );
      },
    ).then((value) {
      print("opne");
  // Do something when the dialog is opened
});
}




