import 'dart:convert';

import 'package:admin/Provider/RestaurantsProvider.dart';
import 'package:admin/constants/CustomSnackBar.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/restaurantModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddRestaurantScreen extends StatefulWidget {
  const AddRestaurantScreen({super.key});

  @override
  State<AddRestaurantScreen> createState() => _AddRestaurantScreenState();
}

class _AddRestaurantScreenState extends State<AddRestaurantScreen> {
late final Map<String, TextEditingController> textInputController = {
  "restaurant_name": TextEditingController(),
  "short_description": TextEditingController(),
  "description": TextEditingController(),
  "address": TextEditingController(),
  "phone_number": TextEditingController(),
  "password": TextEditingController(),
  };
   final formGlobalKey = GlobalKey < FormState > ();

RestaurantModel? restaurant;
bool loading = false;


void AddRestaurantHandler() async{
    loading = true;
  setState(() {});
  try{
      final data = {
      "restaurant_name": textInputController["restaurant_name"]?.value?.text,
  "short_description": textInputController["short_description"]?.value?.text,
  "description": textInputController["description"]?.value?.text,
  "address": textInputController["address"]?.value?.text,
  "phone_number": textInputController["phone_number"]?.value?.text,
  "password": textInputController["password"]?.value?.text
      };
    print("hh");
    print(data);
      var header ={
  'Content-type': 'application/json'
 };
     var response = await http.post(Uri.parse("${ApiServices.addRestaurants}"), body: json.encode(data), headers: header);
    loading = false;
  setState(() {});

 final responseBody = json.decode(response.body);
 final _restaurant = RestaurantModel.fromJson(responseBody);
Provider.of<RestaurantsProvider>(context, listen: false).CheckToAddRestaurant(_restaurant);
      
      CustomSnackBar().ErrorMsgSnackBar("Restaurant Details Added");
      Navigator.of(context).pop();
   
  }catch(e){
    print(e);
      loading = false;
  setState(() {});
  }
}


void initState(){
  super.initState();
}


void dispose(){
textInputController["restaurant_name"]?.dispose();
textInputController["short_description"]?.dispose();
textInputController["description"]?.dispose();
textInputController["address"]?.dispose();
textInputController["phone_number"]?.dispose();
textInputController["password"]?.dispose();
  super.dispose();
}


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






  @override
  Widget build(BuildContext context) {
      double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
  
    return  Scaffold(
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
               if (!formGlobalKey.currentState!.validate()) {
                          return;
                        }
             AddRestaurantHandler();
            print("duhv");
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
          iconTheme: IconThemeData(color: AppColors.greyBlackcolor),
         backgroundColor: AppColors.whitecolor,
          elevation: 0.4,
          title: Text("Edit", style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(17), fontWeight: FontWeight.w500),),
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
                  controller: textInputController["restaurant_name"],
                  
              validator: ((value){
                              if(value == "") return "restaurant name is required";
                              return null;
                            }),
                                                 style: textstyle,
                                                 cursorColor: AppColors.greycolor,
                                                 decoration:  InputDecoration(
                                        labelText: 'Name',
                                          hintText: 'Enter restaurant Name',
                                         focusedBorder: focusedborder,
                                         enabledBorder: enableborder,
                                        labelStyle: labelstyle  ),
                
                                              ),
              ),



               Container(
                margin: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                decoration: boxdecoration,
                child:   TextFormField(
                  controller: textInputController["short_description"],
                 
                             style: textstyle,
                                                 cursorColor: AppColors.greycolor,
                                                 decoration:  InputDecoration(
                                        labelText: 'Short description',
                                          hintText: 'Enter Short description',
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



               Container(
                margin: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                decoration: boxdecoration,
                child:   TextFormField(
                  controller: textInputController["phone_number"],
                
              validator: ((value){
                              if(value == "") return "Phone Number is required";
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
                              if(value == "") return "Password is required";
                              return null;
                            }),
                                                 style: textstyle,
                                                 cursorColor: AppColors.greycolor,
                                                 decoration:  InputDecoration(
                                        labelText: 'Password',
                                          hintText: 'Enter Password',
                                         focusedBorder: focusedborder,
                                         enabledBorder: enableborder,
                                        labelStyle: labelstyle  ),
                
                                              ),
              ),





              
            ]),
          ),
        ),
      ),
    );
  }
}