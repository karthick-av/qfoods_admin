import 'dart:convert';

import 'package:admin/constants/CustomSnackBar.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/screen/Home/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';


import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  final formGlobalKey = GlobalKey < FormState > ();

  TextEditingController username = TextEditingController();

TextEditingController password= TextEditingController();

bool loading = false;
  
 Future<void> LoginHandler(BuildContext context) async{

print("hhh");
     FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
       currentFocus.focusedChild?.unfocus();
    }

  loading = true;
  setState(() { });
  try{
    dynamic data = {
      "username": username?.value?.text,
      "password": password?.value?.text
    };

   var response = await http.post(Uri.parse(ApiServices.login), body: data);
    loading = false;
  setState(() { });
   if(response.statusCode == 200){
final responseBody = json.decode(response.body);
print(responseBody);

final prefs = await SharedPreferences.getInstance();

await prefs.setBool('isLogged', true);
if(responseBody["id"] != null){
  await prefs.setInt("admin_id", responseBody["id"]);
Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomeScreen()
      ));

}else{
  CustomSnackBar().ErrorSnackBar();
}

   
   }else if(response.statusCode == 401){
    CustomSnackBar().ErrorMsgSnackBar("Invalid username or password");
   }
   

  }catch(e){
       loading = false;
  setState(() { });
  CustomSnackBar().ErrorSnackBar();
  }
 }


  @override
   Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      
      home: Scaffold(
        backgroundColor: AppColors.whitecolor,
            body: GestureDetector(
              onTap: (){
                 FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
       currentFocus.focusedChild?.unfocus();
    }
              },
              child: SingleChildScrollView(
                child:Container(
                  height: MediaQuery.of(context).size.height,
                 padding: EdgeInsets.all(20),
                 alignment: Alignment.center,
                 child: Form(
                   key: formGlobalKey,
                    
                   child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     
                    //  Lottie.asset(
                    //           'assets/images/delivery-boy.json',
                    //           repeat: true,
                    //           height: ScreenUtil().setHeight(170),
                    //           fit: BoxFit.cover,
                    //           alignment: Alignment.center
                    //           ),
                              SizedBox(height: 20,),
                              Text("Login", style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(20), fontWeight: FontWeight.bold),)
                     ,  SizedBox(height: 20,),
                            Container(
                           decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(13),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 4),
                                          blurRadius: 20,
                                          color: const Color(0xFFB0CCE1).withOpacity(0.29),
                                        ),
                                      ],
                                    ),
                           child: TextFormField(
            
                            validator: ((value){
                          if(value == "") return "Username is required";
                          return null;
                        }),
                        controller: username,
                                    
                                         style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                         cursorColor: AppColors.greycolor,
                                     //  keyboardType: TextInputType.number,
                                         decoration:  InputDecoration(
                                labelText: 'Username',
                                  hintText: 'Enter Username',
                                border: OutlineInputBorder(
                                )
                                ,
                                 focusedBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.all(Radius.circular(4)),
                                   borderSide: BorderSide(width: 1,color: Color(0XFFe9e9eb)),
                                 ),
                                 enabledBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.all(Radius.circular(4)),
                                   borderSide: BorderSide(width: 1,color: Color(0XFFe9e9eb)),
                                 ),
                                labelStyle: TextStyle(fontSize: ScreenUtil().setSp(12.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.greycolor)
                                        // TODO: add errorHint
                                        ),
                                      ),
                         ),
                     
                     SizedBox(height: 20,),
                           Container(
                           decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(13),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 4),
                                          blurRadius: 20,
                                          color: const Color(0xFFB0CCE1).withOpacity(0.29),
                                        ),
                                      ],
                                    ),
                           child: TextFormField(
                                        validator: ((value){
                          if(value == "") return "Password is required";
                          return null;
                        }),
                        controller: password,
                        
                                         style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                         cursorColor: AppColors.greycolor,
                                       
                                         decoration:  InputDecoration(
                                labelText: 'Password',
                                  hintText: 'Enter Password',
                                border: OutlineInputBorder(
                                )
                                ,
                                 focusedBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.all(Radius.circular(4)),
                                   borderSide: BorderSide(width: 1,color: Color(0XFFe9e9eb)),
                                 ),
                                 enabledBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.all(Radius.circular(4)),
                                   borderSide: BorderSide(width: 1,color: Color(0XFFe9e9eb)),
                                 ),
                                labelStyle: TextStyle(fontSize: ScreenUtil().setSp(12.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.greycolor)
                                        // TODO: add errorHint
                                        ),
                                      ),
                         ),
                     
                     
                     SizedBox(height: 20,),
                     
                     InkWell(
                      onTap: (){
                        if (!formGlobalKey.currentState!.validate()) {
                        return;
                      }
                      LoginHandler(context);
                      },
                       child: Container(
                       alignment: Alignment.center,
                       decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(loading ? 0.2 : 0.9), borderRadius: BorderRadius.circular(10)),
                       width: width * 0.90,
                       padding: EdgeInsets.all(12),
                       
                       child:
                       loading ? SizedBox(
                        height: ScreenUtil().setHeight(20),
                        width: ScreenUtil().setWidth(20),
                         child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                          strokeWidth: 1,
                          
                         ),
                       )
                        : Text("Login", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.normal),),
                       ),
                     ),
                     SizedBox(height: ScreenUtil().setHeight(50),),
                   ],),
                 ),
               )
              ),
            )
         ),
    );
 
  }
}



