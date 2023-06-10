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

class EditRestaurantScreen extends StatefulWidget {
  final RestaurantModel restaurant;
  const EditRestaurantScreen({super.key, required this.restaurant});

  @override
  State<EditRestaurantScreen> createState() => _EditRestaurantScreenState();
}

class _EditRestaurantScreenState extends State<EditRestaurantScreen> {
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


void updateRestaurantHandler() async{
    loading = true;
  setState(() {});
  try{
      final data = json.encode(restaurant);
    
    print(data);
      var header ={
  'Content-type': 'application/json'
 };
     var response = await http.put(Uri.parse("${ApiServices.updateRestaurants}"), body: data, headers: header);
    loading = false;
  setState(() {});

 final responseBody = json.decode(response.body);
 final _restaurant = RestaurantModel.fromJson(responseBody);
  Provider.of<RestaurantsProvider>(context, listen: false).updateRestaurant(_restaurant);
      
      CustomSnackBar().ErrorMsgSnackBar("Restaurant Details Updated");
      Navigator.of(context).pop();
   
  }catch(e){
    print(e);
      loading = false;
  setState(() {});
  }
}


void initState(){
restaurant = widget.restaurant;


 textInputController["restaurant_name"] = TextEditingController(text: restaurant?.restaurantName ?? '');
  textInputController["restaurant_name"]?.selection = TextSelection.fromPosition(TextPosition(offset: textInputController["restaurant_name"]?.text?.length ?? 0));


 textInputController["short_description"] = TextEditingController(text: restaurant?.shortDescription ?? '');
  textInputController["short_description"]?.selection = TextSelection.fromPosition(TextPosition(offset: textInputController["short_description"]?.text?.length ?? 0));


 textInputController["description"] = TextEditingController(text: restaurant?.description ?? '');
  textInputController["description"]?.selection = TextSelection.fromPosition(TextPosition(offset: textInputController["description"]?.text?.length ?? 0));

 textInputController["address"] = TextEditingController(text: restaurant?.address ?? '');
  textInputController["address"]?.selection = TextSelection.fromPosition(TextPosition(offset: textInputController["address"]?.text?.length ?? 0));

 textInputController["phone_number"] = TextEditingController(text: restaurant?.phoneNumber ?? '');
  textInputController["phone_number"]?.selection = TextSelection.fromPosition(TextPosition(offset: textInputController["phone_number"]?.text?.length ?? 0));

print(restaurant?.password);
 textInputController["password"] = TextEditingController(text: restaurant?.password ?? '');
  textInputController["password"]?.selection = TextSelection.fromPosition(TextPosition(offset: textInputController["password"]?.text?.length ?? 0));


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
             updateRestaurantHandler();
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
            child: Text("Update", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),),
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
                   onChanged: (value){
                  restaurant?.restaurantName = value;
                  },
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
                   onChanged: (value){
                  restaurant?.shortDescription = value;
                  },
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
                   onChanged: (value){
                  restaurant?.description = value;
                  },
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
                   onChanged: (value){
                  restaurant?.phoneNumber = value;
                  },
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
                   onChanged: (value){
                  restaurant?.password = value;
                  },
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