
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


Future<void> AddMenuBottomSheet(BuildContext context, Function AddMenuHandler) async{
  double height  = MediaQuery.of(context).size.height;
  double width  = MediaQuery.of(context).size.width;
 
  final formGlobalKey = GlobalKey < FormState > ();


  TextEditingController menuName = TextEditingController();
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
                                      
                                      children: [
                                          Padding(
                                       padding: const EdgeInsets.all(8.0),
                                       child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Add Menu", style: TextStyle(color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(18), fontFamily: FONT_FAMILY, fontWeight: FontWeight.bold),)
                                       
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
                            
                            SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Text("Visible", style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), ),),
                                              SizedBox(width: 10,),
                                              Switch(  
                                          onChanged: (value){
                                         visible = !visible;
                                          mystate(() { });
                                          },  
                                          value: visible,  
                                          activeColor: AppColors.primaryColor,  
                                          activeTrackColor: Color(0xFFFDD4D7),  
                                          inactiveThumbColor: AppColors.greyBlackcolor,  
                                          inactiveTrackColor: AppColors.lightgreycolor,  
                                        )
                                        ],
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
                        AddMenuHandler(menuName.value.text, visible);
                                      },
                                      child: Container( 
                                                       padding: const EdgeInsets.all(10),
                                 decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(10)),
                                    alignment: Alignment.center,
                                        width: width * 0.90,
                                        child: Text("Add Menu", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w400),),
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