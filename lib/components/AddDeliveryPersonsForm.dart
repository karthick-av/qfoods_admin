import 'dart:convert';

import 'package:admin/constants/CustomSnackBar.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/DeliveryPersonsModel.dart';
import 'package:admin/screen/DeliveryPersonsScreen/DeliveryPersonsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

void AddDeliveryPersonForm(BuildContext context){
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

bool loading = false;

late final Map<String, TextEditingController> textInputController = {
  "name": TextEditingController(),
  "phone_number": TextEditingController(),
  "password": TextEditingController()
  };



void AddHandler(BuildContext cxt,StateSetter setState) async{
 

loading = true;
setState((){});

 try{
      dynamic data = {
         "name": textInputController["name"]?.value.text?.toString(),
         "phone_number": textInputController["phone_number"]?.value.text?.toString(),
         "password": textInputController["password"]?.value.text?.toString()
      
      };
     var header ={
  'Content-type': 'application/json'
 };
    var response = await http.post(Uri.parse("${ApiServices.deliverypersons}"), body: data);
    print(response.statusCode);

loading = false;
setState((){});

     if(response.statusCode == 200){
      final responseBody = json.decode(response.body);
      DeliveryPersonsModel person = DeliveryPersonsModel.fromJson(responseBody);
       Provider.of<deliverypersonsProvider>(context, listen: false).addNew(person);
         CustomSnackBar().ErrorMsgSnackBar("Added");
     
       Navigator.of(cxt).pop();
     }else{
      CustomSnackBar().ErrorSnackBar();

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
                        print("object");
                        AddHandler(context, setState);
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
                  title: const Text('Add Person',
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
                                          hintText: 'Enter  Name',
                                         focusedBorder: focusedborder,
                                         enabledBorder: enableborder,
                                        labelStyle: labelstyle  ),
                
                                              ),
              ),

               Container(
                margin: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                decoration: boxdecoration,
                child:   TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: textInputController["phone_number"],
                 
              validator: ((value){
                              if(value == "") return "Phone no is required";
                              return null;
                            }),
                                                 style: textstyle,
                                                 cursorColor: AppColors.greycolor,
                                                 decoration:  InputDecoration(
                                        labelText: 'Phone Number',
                                          hintText: 'Enter Phone Number',
                                         focusedBorder: focusedborder,
                                         enabledBorder: enableborder,
                                        labelStyle: labelstyle  ),
                
                                              ),
              ),
                  

               Container(
                margin: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                decoration: boxdecoration,
                child:   TextFormField(
                  controller: textInputController["password"],
                 
              validator: ((value){
                              if(value == "") return "password is required";
                              return null;
                            }),
                                                 style: textstyle,
                                                 cursorColor: AppColors.greycolor,
                                                 decoration:  InputDecoration(
                                        labelText: 'password',
                                          hintText: 'Enter  password',
                                         focusedBorder: focusedborder,
                                         enabledBorder: enableborder,
                                        labelStyle: labelstyle  ),
                
                                              ),
              ),    
              SizedBox(height: 20,),
              
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



void UpdateDeliveryPersonForm(BuildContext context, DeliveryPersonsModel person){
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

bool loading = false;

late final Map<String, TextEditingController> textInputController = {
  "name": TextEditingController(text: person.name),
  "phone_number": TextEditingController(text: person.phoneNumber?.toString()),
  "password": TextEditingController(text: person?.password?.toString())
  };



void updateHandler(BuildContext cxt,StateSetter setState) async{
 

loading = true;
setState((){});

 try{
    
      final data = json.encode(person);
     var header ={
  'Content-type': 'application/json'
 };
    var response = await http.put(Uri.parse("${ApiServices.deliverypersons}"), body: data, headers: header);
    print(response.statusCode);

loading = false;
setState((){});

     if(response.statusCode == 200){
     final responseBody = json.decode(response.body);
     print(responseBody);
       DeliveryPersonsModel person = DeliveryPersonsModel.fromJson(responseBody);
        Provider.of<deliverypersonsProvider>(cxt, listen: false).update(person);
        CustomSnackBar().ErrorMsgSnackBar("Updated");
        Navigator.of(cxt).pop();
     }else{
      CustomSnackBar().ErrorSnackBar();

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
                        print("object");
                        updateHandler(context, setState);
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
                  title: const Text('Update',
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
                 onChanged: (String txt){
                 person.name = txt;
                 },
              validator: ((value){
                              if(value == "") return "Name is required";
                              return null;
                            }),
                                                 style: textstyle,
                                                 cursorColor: AppColors.greycolor,
                                                 decoration:  InputDecoration(
                                        labelText: 'Name',
                                          hintText: 'Enter  Name',
                                         focusedBorder: focusedborder,
                                         enabledBorder: enableborder,
                                        labelStyle: labelstyle  ),
                
                                              ),
              ),

               Container(
                margin: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                decoration: boxdecoration,
                child:   TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: textInputController["phone_number"],
                   onChanged: (String txt){
                 person.phoneNumber = int.parse(txt);
                 },
              validator: ((value){
                              if(value == "") return "Phone no is required";
                              return null;
                            }),
                                                 style: textstyle,
                                                 cursorColor: AppColors.greycolor,
                                                 decoration:  InputDecoration(
                                        labelText: 'Phone Number',
                                          hintText: 'Enter Phone Number',
                                         focusedBorder: focusedborder,
                                         enabledBorder: enableborder,
                                        labelStyle: labelstyle  ),
                
                                              ),
              ),
                  

               Container(
                margin: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                decoration: boxdecoration,
                child:   TextFormField(
                  controller: textInputController["password"],
                 onChanged: (String txt){
                  person.password = txt;
                 },
              validator: ((value){
                              if(value == "") return "password is required";
                              return null;
                            }),
                                                 style: textstyle,
                                                 cursorColor: AppColors.greycolor,
                                                 decoration:  InputDecoration(
                                        labelText: 'password',
                                          hintText: 'Enter  password',
                                         focusedBorder: focusedborder,
                                         enabledBorder: enableborder,
                                        labelStyle: labelstyle  ),
                
                                              ),
              ),    
              SizedBox(height: 20,),
              
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