
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/GroceryProductModel.dart';
import 'package:admin/model/dishesModel.dart' as dish;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


void AddVariantBottomSheet(BuildContext context, Function addHandler){
  double width = MediaQuery.of(context).size.width;
 double height  = MediaQuery.of(context).size.height;
 
  late final Map<String, TextEditingController> textInputController = {
  "name": TextEditingController()
  };

String? type = "radio";
int price_type = 0;
int visible = 1;
 
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


  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
     shape: RoundedRectangleBorder(
     borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20.0),
      topRight: Radius.circular(20.0)
     ),
  ),
    builder: (context) {
   
       return StatefulBuilder(
                              builder: (BuildContext ctx, StateSetter mystate) {
                             
                      return GestureDetector(
                        onTap: (){
                            FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
       currentFocus.focusedChild?.unfocus();
    }
                        },
                        child: StatefulBuilder(
                          builder: (BuildContext ctx, StateSetter myState) {
                            return SingleChildScrollView(
                               padding: MediaQuery.of(context).viewInsets,
                              child: Container(
                                height: height * 0.50,
                                width: double.infinity,
                                padding: const EdgeInsets.all(10.0),
                                child: Form(
                                  key: formGlobalKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                              Padding(
                                           padding: const EdgeInsets.all(8.0),
                                           child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Add Variant", style: TextStyle(color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(18), fontFamily: FONT_FAMILY, fontWeight: FontWeight.bold),)
                                           
                                              ,
                                              InkWell(
                                                onTap: (){
                                                  Navigator.of(context).pop();
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(1),
                                                child: Icon(Icons.close, color: AppColors.blackcolor, size: ScreenUtil().setSp(20),),
                                                  ),
                                              ),
                                              
                                                        
                                              
                                            ],
                                           ),
                                         ),
                                           ///
                                           ///
                                            Container(
                                                margin: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                                                decoration: boxdecoration,
                                                child:   TextFormField(
                                                  controller: textInputController["name"],
                                                   onChanged: (value){
                                                  },
                                              validator: ((value){
                                        if(value == "") return "Name is required";
                                        return null;
                                      }),
                                                           style: textstyle,
                                                           cursorColor: AppColors.greycolor,
                                                           decoration:  InputDecoration(
                                                  labelText: 'Name',
                                                    hintText: 'Enter Variant Name',
                                                   focusedBorder: focusedborder,
                                                   enabledBorder: enableborder,
                                                  labelStyle: labelstyle  ),
                                                
                                                        ),
                                              ),
                                     
                                           Container(
                                               padding: const EdgeInsets.all(10),
                                                  child: Text("Price Type", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w600),)),
                                              

                                               Container(
                                                margin: const EdgeInsets.only(top: 10),
                                                child: Row(
                                                  children: [
                                                   Container(
                              child: Row(
                                children: [
                                  Radio(  
                                     value: "radio",  
                                     groupValue: type,  
                                     onChanged: (String? value) {  
                                             type = value;
                                             price_type = 1;
                                             myState((){});
                                     },  
                                   ),
                                   Text("Radio", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15)),)
                                ],
                              ),
                                                   ),
                                             
                                                   Container(
                              child: Row(
                                children: [
                                  Radio(  
                                     value: "mutiple",  
                                     groupValue: type,  
                                     onChanged: (String? value) {  
                                              print("object");
                                             type = "mutiple";
                                             price_type = 0;
                                             myState((){});
                                     },  
                                   ),
                                   Text("Mutiple", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15)),)
                                ],
                              ),
                                                   )
                                                  
                                                  ],
                                                ),
                                               ),
                                             
                                               Container(
                                                child: Row(
                                                  children: [
                              Switch(value: visible == 1, onChanged: (value){
                                visible = visible == 1 ? 0 : 1;
                                myState((){});
                              },
                               activeColor: AppColors.primaryColor,  
                              activeTrackColor: Color(0xFFFDD4D7),  
                              inactiveThumbColor: AppColors.greyBlackcolor,  
                              inactiveTrackColor: AppColors.lightgreycolor,  
                                              
                              ),
                                Text("visible", style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w500),),
                                     
                                                  ],
                                                ),
                                               )
                                             
                                
                                          ]
                                        ),
                                      ),
                                                        
                                      Container(
                                        width: width,
                                        alignment: Alignment.center,
                                        child: InkWell(
                                          onTap: (){
                                              if (!formGlobalKey.currentState!.validate()) {
                              return;
                            }
Navigator.of(context).pop();
dynamic data = {
  "name": textInputController["name"]?.value?.text ?? '',
  "price_type": price_type?.toString(),
  "type": type,
  "visible": visible?.toString()
};
addHandler(data);
                                          },
                                          child: Container( 
                                                           padding: const EdgeInsets.all(10),
                                     decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(10)),
                                        alignment: Alignment.center,
                                            width: width * 0.90,
                                            child: Text("Add Variant", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w400),),
                                          ),
                                        ),
                                                        
                                      )
                                    ]),
                                ),
                              ),
                            );
                          }
                        ),
                      );
              
                              });
     
    });                                   

  
}


void UpdateVariantBottomSheet(BuildContext context, dish.DishVariants variant ,Function addHandler){
  double width = MediaQuery.of(context).size.width;
 double height  = MediaQuery.of(context).size.height;
 
  late final Map<String, TextEditingController> textInputController = {
  "name": TextEditingController(text: variant?.name)
  };

String? type = variant?.type;
int price_type = variant?.priceType ?? 0;
int visible = variant?.visible ?? 0;
 
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


  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
     shape: RoundedRectangleBorder(
     borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20.0),
      topRight: Radius.circular(20.0)
     ),
  ),
    builder: (context) {
   
       return StatefulBuilder(
                              builder: (BuildContext ctx, StateSetter mystate) {
                             
                      return GestureDetector(
                        onTap: (){
                            FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
       currentFocus.focusedChild?.unfocus();
    }
                        },
                        child: StatefulBuilder(
                          builder: (BuildContext ctx, StateSetter myState) {
                            return SingleChildScrollView(
                               padding: MediaQuery.of(context).viewInsets,
                              child: Container(
                                height: height * 0.50,
                                width: double.infinity,
                                padding: const EdgeInsets.all(10.0),
                                child: Form(
                                  key: formGlobalKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                              Padding(
                                           padding: const EdgeInsets.all(8.0),
                                           child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Add Variant", style: TextStyle(color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(18), fontFamily: FONT_FAMILY, fontWeight: FontWeight.bold),)
                                           
                                              ,
                                              InkWell(
                                                onTap: (){
                                                  Navigator.of(context).pop();
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(1),
                                                child: Icon(Icons.close, color: AppColors.blackcolor, size: ScreenUtil().setSp(20),),
                                                  ),
                                              ),
                                              
                                                        
                                              
                                            ],
                                           ),
                                         ),
                                           ///
                                           ///
                                            Container(
                                                margin: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                                                decoration: boxdecoration,
                                                child:   TextFormField(
                                                  controller: textInputController["name"],
                                                   onChanged: (value){
                                                  },
                                              validator: ((value){
                                        if(value == "") return "Name is required";
                                        return null;
                                      }),
                                                           style: textstyle,
                                                           cursorColor: AppColors.greycolor,
                                                           decoration:  InputDecoration(
                                                  labelText: 'Name',
                                                    hintText: 'Enter Variant Name',
                                                   focusedBorder: focusedborder,
                                                   enabledBorder: enableborder,
                                                  labelStyle: labelstyle  ),
                                                
                                                        ),
                                              ),
                                     
                                           Container(
                                               padding: const EdgeInsets.all(10),
                                                  child: Text("Price Type", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w600),)),
                                              

                                               Container(
                                                margin: const EdgeInsets.only(top: 10),
                                                child: Row(
                                                  children: [
                                                   Container(
                              child: Row(
                                children: [
                                  Radio(  
                                     value: "radio",  
                                     groupValue: type,  
                                     onChanged: (String? value) {  
                                             type = value;
                                             price_type = 1;
                                             myState((){});
                                     },  
                                   ),
                                   Text("Radio", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15)),)
                                ],
                              ),
                                                   ),
                                             
                                                   Container(
                              child: Row(
                                children: [
                                  Radio(  
                                     value: "mutiple",  
                                     groupValue: type,  
                                     onChanged: (String? value) {  
                                              print("object");
                                             type = "mutiple";
                                             price_type = 0;
                                             myState((){});
                                     },  
                                   ),
                                   Text("Mutiple", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15)),)
                                ],
                              ),
                                                   )
                                                  
                                                  ],
                                                ),
                                               ),
                                             
                                               Container(
                                                child: Row(
                                                  children: [
                              Switch(value: visible == 1, onChanged: (value){
                                visible = visible == 1 ? 0 : 1;
                                myState((){});
                              },
                               activeColor: AppColors.primaryColor,  
                              activeTrackColor: Color(0xFFFDD4D7),  
                              inactiveThumbColor: AppColors.greyBlackcolor,  
                              inactiveTrackColor: AppColors.lightgreycolor,  
                                              
                              ),
                                Text("visible", style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w500),),
                                     
                                                  ],
                                                ),
                                               )
                                             
                                
                                          ]
                                        ),
                                      ),
                                                        
                                      Container(
                                        width: width,
                                        alignment: Alignment.center,
                                        child: InkWell(
                                          onTap: (){
                                              if (!formGlobalKey.currentState!.validate()) {
                              return;
                            }
Navigator.of(context).pop();
dynamic data = {
  "name": textInputController["name"]?.value?.text ?? '',
  "price_type": price_type?.toString(),
  "type": type,
  "visible": visible?.toString(),
  "variant_id": variant?.variantId?.toString()
};
addHandler(data);
                                          },
                                          child: Container( 
                                                           padding: const EdgeInsets.all(10),
                                     decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(10)),
                                        alignment: Alignment.center,
                                            width: width * 0.90,
                                            child: Text("Update Variant", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w400),),
                                          ),
                                        ),
                                                        
                                      )
                                    ]),
                                ),
                              ),
                            );
                          }
                        ),
                      );
              
                              });
     
    });                                   

  
}




void AddGroceryVariantBottomSheet(BuildContext context, Function addHandler){
  double width = MediaQuery.of(context).size.width;
 double height  = MediaQuery.of(context).size.height;
 
  late final Map<String, TextEditingController> textInputController = {
  "name": TextEditingController()
  };

int visible = 1;
 
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


  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
     shape: RoundedRectangleBorder(
     borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20.0),
      topRight: Radius.circular(20.0)
     ),
  ),
    builder: (context) {
   
       return StatefulBuilder(
                              builder: (BuildContext ctx, StateSetter mystate) {
                             
                      return GestureDetector(
                        onTap: (){
                            FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
       currentFocus.focusedChild?.unfocus();
    }
                        },
                        child: StatefulBuilder(
                          builder: (BuildContext ctx, StateSetter myState) {
                            return SingleChildScrollView(
                               padding: MediaQuery.of(context).viewInsets,
                              child: Container(
                                height: height * 0.50,
                                width: double.infinity,
                                padding: const EdgeInsets.all(10.0),
                                child: Form(
                                  key: formGlobalKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                              Padding(
                                           padding: const EdgeInsets.all(8.0),
                                           child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Add Variant", style: TextStyle(color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(18), fontFamily: FONT_FAMILY, fontWeight: FontWeight.bold),)
                                           
                                              ,
                                              InkWell(
                                                onTap: (){
                                                  Navigator.of(context).pop();
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(1),
                                                child: Icon(Icons.close, color: AppColors.blackcolor, size: ScreenUtil().setSp(20),),
                                                  ),
                                              ),
                                              
                                                        
                                              
                                            ],
                                           ),
                                         ),
                                           ///
                                           ///
                                            Container(
                                                margin: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                                                decoration: boxdecoration,
                                                child:   TextFormField(
                                                  controller: textInputController["name"],
                                                   onChanged: (value){
                                                  },
                                              validator: ((value){
                                        if(value == "") return "Name is required";
                                        return null;
                                      }),
                                                           style: textstyle,
                                                           cursorColor: AppColors.greycolor,
                                                           decoration:  InputDecoration(
                                                  labelText: 'Name',
                                                    hintText: 'Enter Variant Name',
                                                   focusedBorder: focusedborder,
                                                   enabledBorder: enableborder,
                                                  labelStyle: labelstyle  ),
                                                
                                                        ),
                                              ),
                                     
                                           Container(
                                               padding: const EdgeInsets.all(10),
                                                  child: Text("Price Type", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w600),)),
                                              

                                             
                                               Container(
                                                child: Row(
                                                  children: [
                              Switch(value: visible == 1, onChanged: (value){
                                visible = visible == 1 ? 0 : 1;
                                myState((){});
                              },
                               activeColor: AppColors.primaryColor,  
                              activeTrackColor: Color(0xFFFDD4D7),  
                              inactiveThumbColor: AppColors.greyBlackcolor,  
                              inactiveTrackColor: AppColors.lightgreycolor,  
                                              
                              ),
                                Text("visible", style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w500),),
                                     
                                                  ],
                                                ),
                                               )
                                             
                                
                                          ]
                                        ),
                                      ),
                                                        
                                      Container(
                                        width: width,
                                        alignment: Alignment.center,
                                        child: InkWell(
                                          onTap: (){
                                              if (!formGlobalKey.currentState!.validate()) {
                              return;
                            }
Navigator.of(context).pop();
dynamic data = {
  "name": textInputController["name"]?.value?.text ?? '',
  "visible": visible?.toString()
};
addHandler(data);
                                          },
                                          child: Container( 
                                                           padding: const EdgeInsets.all(10),
                                     decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(10)),
                                        alignment: Alignment.center,
                                            width: width * 0.90,
                                            child: Text("Add Variant", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w400),),
                                          ),
                                        ),
                                                        
                                      )
                                    ]),
                                ),
                              ),
                            );
                          }
                        ),
                      );
              
                              });
     
    });                                   

  
}



void UpdateGroceryVariantBottomSheet(BuildContext context,VariantItems variant, Function updateHandler){
  double width = MediaQuery.of(context).size.width;
 double height  = MediaQuery.of(context).size.height;
 
  late final Map<String, TextEditingController> textInputController = {
  "name": TextEditingController(text: variant?.name)
  };

int visible = variant.visible ?? 0;
 
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


  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
     shape: RoundedRectangleBorder(
     borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20.0),
      topRight: Radius.circular(20.0)
     ),
  ),
    builder: (context) {
   
       return StatefulBuilder(
                              builder: (BuildContext ctx, StateSetter mystate) {
                             
                      return GestureDetector(
                        onTap: (){
                            FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
       currentFocus.focusedChild?.unfocus();
    }
                        },
                        child: StatefulBuilder(
                          builder: (BuildContext ctx, StateSetter myState) {
                            return SingleChildScrollView(
                               padding: MediaQuery.of(context).viewInsets,
                              child: Container(
                                height: height * 0.50,
                                width: double.infinity,
                                padding: const EdgeInsets.all(10.0),
                                child: Form(
                                  key: formGlobalKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                              Padding(
                                           padding: const EdgeInsets.all(8.0),
                                           child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Add Variant", style: TextStyle(color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(18), fontFamily: FONT_FAMILY, fontWeight: FontWeight.bold),)
                                           
                                              ,
                                              InkWell(
                                                onTap: (){
                                                  Navigator.of(context).pop();
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.all(1),
                                                child: Icon(Icons.close, color: AppColors.blackcolor, size: ScreenUtil().setSp(20),),
                                                  ),
                                              ),
                                              
                                                        
                                              
                                            ],
                                           ),
                                         ),
                                           ///
                                           ///
                                            Container(
                                                margin: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                                                decoration: boxdecoration,
                                                child:   TextFormField(
                                                  controller: textInputController["name"],
                                                   onChanged: (value){
                                                  },
                                              validator: ((value){
                                        if(value == "") return "Name is required";
                                        return null;
                                      }),
                                                           style: textstyle,
                                                           cursorColor: AppColors.greycolor,
                                                           decoration:  InputDecoration(
                                                  labelText: 'Name',
                                                    hintText: 'Enter Variant Name',
                                                   focusedBorder: focusedborder,
                                                   enabledBorder: enableborder,
                                                  labelStyle: labelstyle  ),
                                                
                                                        ),
                                              ),
                                     
                                           Container(
                                               padding: const EdgeInsets.all(10),
                                                  child: Text("Price Type", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w600),)),
                                              

                                             
                                               Container(
                                                child: Row(
                                                  children: [
                              Switch(value: visible == 1, onChanged: (value){
                                visible = visible == 1 ? 0 : 1;
                                myState((){});
                              },
                               activeColor: AppColors.primaryColor,  
                              activeTrackColor: Color(0xFFFDD4D7),  
                              inactiveThumbColor: AppColors.greyBlackcolor,  
                              inactiveTrackColor: AppColors.lightgreycolor,  
                                              
                              ),
                                Text("visible", style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w500),),
                                     
                                                  ],
                                                ),
                                               )
                                             
                                
                                          ]
                                        ),
                                      ),
                                                        
                                      Container(
                                        width: width,
                                        alignment: Alignment.center,
                                        child: InkWell(
                                          onTap: (){
                                              if (!formGlobalKey.currentState!.validate()) {
                              return;
                            }
Navigator.of(context).pop();
dynamic data = {
  "name": textInputController["name"]?.value?.text ?? '',
  "visible": visible?.toString(),
  "variant_id": variant?.id
};
updateHandler(data);
                                          },
                                          child: Container( 
                                                           padding: const EdgeInsets.all(10),
                                     decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(10)),
                                        alignment: Alignment.center,
                                            width: width * 0.90,
                                            child: Text("Update Variant", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w400),),
                                          ),
                                        ),
                                                        
                                      )
                                    ]),
                                ),
                              ),
                            );
                          }
                        ),
                      );
              
                              });
     
    });                                   

  
}