


import 'dart:convert';

import 'package:admin/Provider/groceryProductsProvider.dart';
import 'package:admin/components/SearchGroceryBrands.dart';
import 'package:admin/components/SearchGroceryCategory.dart';
import 'package:admin/components/SearchGroceryTypes.dart';
import 'package:admin/constants/CustomSnackBar.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/GroceryProductModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';


import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
void AddGroceryProductsForm(BuildContext context){
   double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
  
   final formGlobalKey = GlobalKey < FormState > ();

  TextStyle textstyle = TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor);
OutlineInputBorder focusedborder = const OutlineInputBorder(
                                   borderRadius: BorderRadius.all(Radius.circular(4)),
                                   borderSide: BorderSide(width: 1,color: Color(0XFFe9e9eb)),
                                 );
OutlineInputBorder enableborder = const OutlineInputBorder(
                                   borderRadius: BorderRadius.all(Radius.circular(4)),
                                   borderSide: BorderSide(width: 1,color: Color(0XFFe9e9eb)),
                                 );

  TextStyle labelstyle = TextStyle(fontSize: ScreenUtil().setSp(12.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.greycolor);                               


BoxDecoration boxdecoration = BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(13),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: const Offset(0, 4),
                                          blurRadius: 20,
                                          color:  const Color(0xFFB0CCE1).withOpacity(0.29),
                                        ),
                                      ],
                                    );

bool loading = false;
int status = 0;
int visible= 0;
int price_type = 0;
int variants = 0;
List<Brands> brands = [];

List<Types> types = [];
List<Category> categories = [];
late final Map<String, TextEditingController> textInputController = {
  "name": TextEditingController(),
  "regular_price": TextEditingController(),
  "sales_price": TextEditingController(),
  "description": TextEditingController(),
  };

late StateSetter my_State;

void AddHandler(BuildContext cxt,StateSetter setState) async{
 

loading = true;
setState((){});
List<dynamic> _brands = [];
List<dynamic> _categories = [];
List<dynamic> _types = [];
brands?.forEach((e) {
 _brands.add({"brand_id": e?.brandId?.toString()});
});

categories?.forEach((e) {
 _categories.add({"category_id": e?.categoryId?.toString()});
});

types?.forEach((e) {
 _types.add({"type_id": e?.typeId?.toString()});
});


 try{
      dynamic data = {
         "name": textInputController["name"]?.value.text?.toString(),
         "description":textInputController["description"]?.value.text?.toString(),
        "regular_price":textInputController["regular_price"]?.value.text?.toString(),
        "price":textInputController["regular_price"]?.value.text?.toString(),
      "sale_price":textInputController["sales_price"]?.value.text == "" ? "0" : textInputController["sales_price"]?.value.text?.toString(),
      "status": status?.toString() ,
      "variants": variants?.toString(),
      "brands": _brands,
      "categories": _categories,
      "types": _types,
      "visible": visible?.toString()
      };

         var header ={
  'Content-type': 'application/json'
 };
final body = json.encode(data);
    var response = await http.post(Uri.parse("${ApiServices.addGrocery}"), body: body, headers: header);
    print(response.statusCode);

loading = false;
setState((){});

     if(response.statusCode == 200){
  
        var response_body = json.decode(response.body);
        CustomSnackBar().ErrorMsgSnackBar("Product Added");
        GroceryProductModel _product = GroceryProductModel.fromJson(response_body);
  Navigator.of(cxt).pop();
       Provider.of<GroceryProductsProvider>(context, listen: false).addNewproducts(_product);
      
     }
    }catch(e){
print(e);
CustomSnackBar().ErrorSnackBar();
 Navigator.of(cxt).pop();
  
  
loading = false;
setState((){});
    }
  }


Future<void> addBrandsHandler(List<Brands> data) async{
  brands = data;
my_State(() => {});
}
Future<void> addTypesHandler(List<Types> data) async{
  types = data;
my_State(() => {});
}
Future<void> addCategoryHandler(List<Category> data) async{
  categories = data;
my_State(() => {});
}


                                     showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
           
           my_State = setState;
             

            return Dialog(
              insetPadding: EdgeInsets.zero,
              child: Scaffold(
                  bottomNavigationBar: Container( 
           height: height * 0.08,
         width: width,
         alignment: Alignment.center,
         padding:  const EdgeInsets.all(2),
              decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(0, 4),
                                        blurRadius: 20,
                                        color:  const Color(0xFFB0CCE1).withOpacity(0.29),
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
            padding:  const EdgeInsets.all(10),
            decoration: BoxDecoration( 
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10)
            ),
            child: SizedBox(
              height: ScreenUtil().setSp(20),
              width: ScreenUtil().setSp(20),
              child: const CircularProgressIndicator(color: AppColors.whitecolor, )),
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
            padding:  const EdgeInsets.all(10),
            decoration: BoxDecoration( 
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Text("Add", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),),
          ),
         ),
          ),
      
                appBar: AppBar(
                  title:  const Text('Add Product',
                  style: TextStyle(color: AppColors.whitecolor),
                  ),
                  centerTitle: false,
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon:  const Icon(Icons.close),
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
                      padding:  const EdgeInsets.all(10),
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
                                          hintText: 'Enter Product Name',
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
                  const SizedBox(height: 10,),
                   InkWell(
                    onTap: (){
                        FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
       currentFocus.focusedChild?.unfocus();
    }
                       final SelectedProvider = Provider.of<SearchGroceryBrandsProvider>(context, listen: false);
                        SelectedProvider.addSelectedbrands(brands);
                        SearchGroceryBrands(context, addBrandsHandler);
                    },
                     child: Container(
                                   width: width * 0.95,
                                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                                   margin: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                                   decoration: boxdecoration,
                                   child: 
                                   (brands?.length ?? 0) == 0
                                   ?  Text("Select Brand", style: labelstyle)
                                   
                                   :
                                   
                                   Wrap(
                                     children: [
                      for(int i = 0; i < (brands?.length ?? 0); i++)
                      Text("${brands[i].brandName}, " ?? '', style: TextStyle(fontSize: ScreenUtil().setSp(12.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),)
                                     ],
                                   ),
                     ),
                   ),
                     const SizedBox(height: 10,),
                   InkWell(
                    onTap: (){
                       final SelectedProvider = Provider.of<SearchGroceryCategoryProvider>(context, listen: false);
                        SelectedProvider.addSelectedCategories(categories);
                        SearchGroceryCategory(context, addCategoryHandler);
                    },
                     child: Container(
                                   width: width * 0.95,
                                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                                   margin: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                                   decoration: boxdecoration,
                                   child: 
                                   (categories?.length ?? 0) == 0
                                   ?  Text("Select Categories", style: labelstyle)
                                   
                                   :
                                   
                                   Wrap(
                                     children: [
                      for(int i = 0; i < (categories?.length ?? 0); i++)
                      Text("${categories[i].categoryName}, " ?? '', style: TextStyle(fontSize: ScreenUtil().setSp(12.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),)
                                     ],
                                   ),
                     ),
                   ),
                     const SizedBox(height: 10,),
                   InkWell(
                    onTap: (){
                       final SelectedProvider = Provider.of<SearchGroceryTypesProvider>(context, listen: false);
                        SelectedProvider.addTypes(types);
                        SearchGroceryTypes(context, addTypesHandler);
                    },
                     child: Container(
                                   width: width * 0.95,
                                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                                   margin: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                                   decoration: boxdecoration,
                                   child: 
                                   (types?.length ?? 0) == 0
                                   ?  Text("Select Types", style: labelstyle)
                                   
                                   :
                                   
                                   Wrap(
                                     children: [
                      for(int i = 0; i < (types?.length ?? 0); i++)
                      Text("${types[i].typeName}, " ?? '', style: TextStyle(fontSize: ScreenUtil().setSp(12.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),)
                                     ],
                                   ),
                     ),
                   ),
                   SizedBox(height: 10,),
              Padding(
                padding:   EdgeInsets.only(left:8.0),
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
                        activeTrackColor: const Color(0xFFFDD4D7),  
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
                        activeTrackColor: const Color(0xFFFDD4D7),  
                        inactiveThumbColor: AppColors.greyBlackcolor,  
                        inactiveTrackColor: AppColors.lightgreycolor,  
                    
                  )
                ],
              ),
              Column(
                children: [
                  Text("Variants", style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w500),),
                  Switch(value: variants ==  1 ? true : false, onChanged: (value){
                   variants = variants == 1 ? 0 : 1;
                   setState(() { }); 
                  },
                  
                     activeColor: AppColors.primaryColor,  
                        activeTrackColor: const Color(0xFFFDD4D7),  
                        inactiveThumbColor: AppColors.greyBlackcolor,  
                        inactiveTrackColor: AppColors.lightgreycolor,  
                    
                  )
                ],
              ),
              

                   Column(
                children: [
                  Text("add Price With variant", style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w500),),
                  Switch(value: price_type ==  1 ? true : false, onChanged: (value){
                   price_type = price_type == 1 ? 0 : 1;
                   setState(() { }); 
                  },
                  
                     activeColor: AppColors.primaryColor,  
                        activeTrackColor: const Color(0xFFFDD4D7),  
                        inactiveThumbColor: AppColors.greyBlackcolor,  
                        inactiveTrackColor: AppColors.lightgreycolor,  
                    
                  )
                ],
              ),
            ]
                ),
              ),
              const SizedBox(height: 20,),
              
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