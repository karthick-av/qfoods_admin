import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/DeliveryChargesModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> AddDeliveryCharges(BuildContext context, Future<void> Function(dynamic data) addHandler) async{
  double height  = MediaQuery.of(context).size.height;
  double width  = MediaQuery.of(context).size.width;
 
  final formGlobalKey = GlobalKey < FormState > ();


  TextEditingController minc = TextEditingController();
  
  TextEditingController maxc = TextEditingController();
  
  TextEditingController pricec = TextEditingController();
  bool visible = false;
   return showModalBottomSheet(
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
                        child: SingleChildScrollView(
                           padding: MediaQuery.of(context).viewInsets,
                          child: Container(
                            height: height * 0.70,
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
                                      
                                      children: [
                                          Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Add Delivery Charges", style: TextStyle(color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(18), fontFamily: FONT_FAMILY, fontWeight: FontWeight.bold),)
                                       
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
                                                    SizedBox(height: 20,),
                                      TextFormField(
                                       keyboardType: TextInputType.number,
                                          controller: minc,
                                         style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                        cursorColor: AppColors.greycolor,
                                         decoration:  InputDecoration(
                              labelText: 'Min Kms',
                              hintText: "Enter Min Kms",
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
                          if(value == "") return "Min Kms is required";
                          return null;
                        })
                                      ),

                                        SizedBox(height: 20,),
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                         controller: maxc,
                                         style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                        cursorColor: AppColors.greycolor,
                                         decoration:  InputDecoration(
                              labelText: 'Max Kms',
                              hintText: "Enter Max Kms",
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
                          if(value == "") return "Max Kms is required";
                          return null;
                        })
                                      ),
                            
                              SizedBox(height: 20,),
                                      TextFormField(
                                         keyboardType: TextInputType.number,
                                        controller: pricec,
                                         style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                        cursorColor: AppColors.greycolor,
                                         decoration:  InputDecoration(
                              labelText: 'Price',
                              hintText: "Enter Price",
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
                          if(value == "") return "Price is required";
                          return null;
                        })
                                      ),
                            SizedBox(height: 10,),



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
"min": minc.value.text?.toString(),
 "max": maxc.value.text?.toString(),
  "price": pricec.value.text?.toString()
};
addHandler(data);
                  
                                      },
                                      child: Container( 
                                                       padding: const EdgeInsets.all(10),
                                 decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(10)),
                                    alignment: Alignment.center,
                                        width: width * 0.90,
                                        child: Text("Add Delivery charges", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w400),),
                                      ),
                                    ),
                                                    
                                  )
                                ]),
                            ),
                          ),
                        ),
                      );
              
                              });
     
    });
}









Future<void> UpdateDeliveryCharges(BuildContext context, DeliveryChargesModel charges,Future<void> Function(DeliveryChargesModel data) updateHandler) async{
  double height  = MediaQuery.of(context).size.height;
  double width  = MediaQuery.of(context).size.width;
 
  final formGlobalKey = GlobalKey < FormState > ();


  TextEditingController minc = TextEditingController(text: charges?.minKms?.toString() ?? "0");
  
  TextEditingController maxc = TextEditingController(text: charges?.maxKms?.toString() ?? "0");
  
  TextEditingController pricec = TextEditingController(text: charges?.price?.toString() ?? "0");
  bool visible = false;
   return showModalBottomSheet(
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
                        child: SingleChildScrollView(
                           padding: MediaQuery.of(context).viewInsets,
                          child: Container(
                            height: height * 0.70,
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
                                      
                                      children: [
                                          Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Update Delivery Charges", style: TextStyle(color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(18), fontFamily: FONT_FAMILY, fontWeight: FontWeight.bold),)
                                       
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
                                                    SizedBox(height: 20,),
                                      TextFormField(
                                       keyboardType: TextInputType.number,
                                          controller: minc,
                                         style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                        cursorColor: AppColors.greycolor,
                                         decoration:  InputDecoration(
                              labelText: 'Min Kms',
                              hintText: "Enter Min Kms",
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
                          if(value == "") return "Min Kms is required";
                          return null;
                        })
                                      ),

                                        SizedBox(height: 20,),
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                         controller: maxc,
                                         style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                        cursorColor: AppColors.greycolor,
                                         decoration:  InputDecoration(
                              labelText: 'Max Kms',
                              hintText: "Enter Max Kms",
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
                          if(value == "") return "Max Kms is required";
                          return null;
                        })
                                      ),
                            
                              SizedBox(height: 20,),
                                      TextFormField(
                                         keyboardType: TextInputType.number,
                                        controller: pricec,
                                         style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                        cursorColor: AppColors.greycolor,
                                         decoration:  InputDecoration(
                              labelText: 'Price',
                              hintText: "Enter Price",
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
                          if(value == "") return "Price is required";
                          return null;
                        })
                                      ),
                            SizedBox(height: 10,),



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

charges.minKms = int.parse(minc.value.text);
charges.maxKms = int.parse(maxc.value.text);
charges.price = int.parse(pricec.value.text);
updateHandler(charges);
                  
                                      },
                                      child: Container( 
                                                       padding: const EdgeInsets.all(10),
                                 decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(10)),
                                    alignment: Alignment.center,
                                        width: width * 0.90,
                                        child: Text("Update Delivery charges", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w400),),
                                      ),
                                    ),
                                                    
                                  )
                                ]),
                            ),
                          ),
                        ),
                      );
              
                              });
     
    });
}