
import 'dart:convert';
import 'dart:io';

import 'package:admin/Provider/DishesProvider.dart';
import 'package:admin/components/VariantBottomSheet.dart';
import 'package:admin/components/VariantItemCard.dart';
import 'package:admin/constants/CustomSnackBar.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/dishesModel.dart';
import 'package:admin/screen/EditDishScreen/VariantItemForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
class EditDishScreen extends StatefulWidget {
  final Dishes? dish_;
  const EditDishScreen({super.key, required this.dish_});

  @override
  State<EditDishScreen> createState() => _EditDishScreenState();
}
Dishes? dish;
class _EditDishScreenState extends State<EditDishScreen> {
late final Map<String, TextEditingController> textInputController = {
  "name": TextEditingController(),
  "regular_price": TextEditingController(),
  "sales_price": TextEditingController(),
  "description": TextEditingController(),
  };
   final formGlobalKey = GlobalKey < FormState > ();

 
File? _image;
void initState(){
  dish = widget.dish_;
 
  textInputController["name"] = TextEditingController(text: dish?.name ?? '');
  textInputController["name"]?.selection = TextSelection.fromPosition(TextPosition(offset: textInputController["name"]?.text?.length ?? 0));
 
 
  textInputController["regular_price"] = TextEditingController(text: dish?.price?.toString() ?? '');
  textInputController["regular_price"]?.selection = TextSelection.fromPosition(TextPosition(offset: textInputController["regular_price"]?.text?.length ?? 0));
  
  textInputController["sales_price"] = TextEditingController(text: dish?.salePrice?.toString() ?? '');
  textInputController["sales_price"]?.selection = TextSelection.fromPosition(TextPosition(offset: textInputController["sales_price"]?.text?.length ?? 0));
  

  textInputController["description"] = TextEditingController(text: dish?.description?.toString() ?? '');
  textInputController["description"]?.selection = TextSelection.fromPosition(TextPosition(offset: textInputController["description"]?.text?.length ?? 0));
  
  super.initState();
}

bool loading = false;

Future<void> UpdateDishHandler() async{
  loading = true;
  setState(() {});
  try{
    final _dish = dish;
   final data = json.encode(_dish);
    print(data);
      var header ={
  'Content-type': 'application/json'
 };
    var response = await http.put(Uri.parse("${ApiServices.update_dishes}"), body: data, headers: header);
    loading = false;
  setState(() {});
    
     if(response.statusCode == 200){
      var response_body = json.decode(response.body);
        CustomSnackBar().ErrorMsgSnackBar("Item Updated");
       
       if(response_body["dish_id"] != null){
        Dishes dish = Dishes.fromJson(response_body); 
          Provider.of<DishesProvider>(context, listen: false).addDishesList(dish);
      ModifyDish(dish);
       }
  }
  }
  catch(e){
    print(e);
  loading = false;
  setState(() {});
  CustomSnackBar().ErrorSnackBar();
  }
}


void toggleVariantVisible(int vi, int iti){
  dish?.dishVariants?[vi].variantItems?[iti]?.status = dish?.dishVariants?[vi].variantItems?[iti]?.status == 1 ? 0 : 1;
  setState(() { }); 

}

  void reorderData(int oldindex, int newindex) {
    final variants = dish?.dishVariants;
     if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = variants?.removeAt(oldindex);
         variants?.insert(newindex, items!);

         for(int i  = 0; i < (variants?.length ?? 0); i++ ){
          variants?[i]?.position = i;
         }
dish?.dishVariants = variants;
final j = json.encode(dish?.dishVariants);
setState(() {});
print(j);
  }


Future<void> addVariantHandler(dynamic? data) async{
  data["dish_item_id"] = widget?.dish_?.dishId?.toString();
  
  data["restaurant_id"] = widget?.dish_?.restaurantId?.toString();

  print(data);
   try{
    final data_ = json.encode(data);
      var header ={
  'Content-type': 'application/json'
 };
    var response = await http.post(Uri.parse("${ApiServices.add_variant}"), body: data_, headers: header);
    
context.loaderOverlay.hide();
     if(response.statusCode == 200){
         var response_body = json.decode(response.body);

if(response_body?["message"] != null){
 CustomSnackBar().ErrorMsgSnackBar(response_body?["message"] ?? '');
  return;
}

          if(response_body["dish_id"] != null){
        Dishes dish = Dishes.fromJson(response_body); 
          Provider.of<DishesProvider>(context, listen: false).addDishesList(dish);
      ModifyDish(dish);
       }
 
      
CustomSnackBar().ErrorMsgSnackBar("Variant Added");
  }else{
    
CustomSnackBar().ErrorSnackBar();
  }
  }
  catch(e){
context.loaderOverlay.hide();
CustomSnackBar().ErrorSnackBar();
 print(e);
 print("hhh");
  }
}


Future<void> updateVariantHandler(dynamic? data) async{
  data["dish_item_id"] = widget?.dish_?.dishId?.toString();
  
  data["restaurant_id"] = widget?.dish_?.restaurantId?.toString();

  print(data);
   try{
    final data_ = json.encode(data);
      var header ={
  'Content-type': 'application/json'
 };
    var response = await http.put(Uri.parse("${ApiServices.update_variant}"), body: data_, headers: header);
    
context.loaderOverlay.hide();
     if(response.statusCode == 200){
         var response_body = json.decode(response.body);

if(response_body?["message"] != null){
 CustomSnackBar().ErrorMsgSnackBar(response_body?["message"] ?? '');
  return;
}

          if(response_body["dish_id"] != null){
        Dishes dish = Dishes.fromJson(response_body); 
          Provider.of<DishesProvider>(context, listen: false).addDishesList(dish);
      ModifyDish(dish);
       }
 
      
CustomSnackBar().ErrorMsgSnackBar("Variant Updated");
  }else{
    
CustomSnackBar().ErrorSnackBar();
  }
  }
  catch(e){
    print(e);
context.loaderOverlay.hide();
CustomSnackBar().ErrorSnackBar();
 print(e);
 print("hhh");
  }
}



Future<void> deleteVariantHandler(int vid, int did, int rid) async{
 dynamic data = {
 "variant_id": vid?.toString(),
 "dish_id": did?.toString(),
 "restaurant_id": rid?.toString()
 };

  print(data);
 context.loaderOverlay.show();
   try{
    final data_ = json.encode(data);
      var header ={
  'Content-type': 'application/json'
 };
    var response = await http.put(Uri.parse("${ApiServices.delete_variant}"), body: data_, headers: header);
    
context.loaderOverlay.hide();
     if(response.statusCode == 200){
         var response_body = json.decode(response.body);

if(response_body?["message"] != null){
 CustomSnackBar().ErrorMsgSnackBar(response_body?["message"] ?? '');
  return;
}

          if(response_body["dish_id"] != null){
            print(response_body);
        Dishes dish = Dishes.fromJson(response_body); 
          Provider.of<DishesProvider>(context, listen: false).addDishesList(dish);
      ModifyDish(dish);
       }
 
      
CustomSnackBar().ErrorMsgSnackBar("Variant Added");
  }else{
    
CustomSnackBar().ErrorSnackBar();
  }
  }
  catch(e){
context.loaderOverlay.hide();
CustomSnackBar().ErrorSnackBar();
 print(e);
  }
}


Future<void> deleteVariantItemHandler(int vid) async{
 dynamic data = {
 "variant_item_id": vid?.toString(),
 "dish_id": dish?.dishId?.toString(),
 "restaurant_id": dish?.restaurantId?.toString()
 };

  print(data);
 context.loaderOverlay.show();
   try{
    final data_ = json.encode(data);
      var header ={
  'Content-type': 'application/json'
 };
    var response = await http.put(Uri.parse("${ApiServices.delete_variant_item}"), body: data_, headers: header);
    
context.loaderOverlay.hide();
print(response.statusCode);
     if(response.statusCode == 200){
         var response_body = json.decode(response.body);

if(response_body?["message"] != null){
 CustomSnackBar().ErrorMsgSnackBar(response_body?["message"] ?? '');
  return;
}

          if(response_body["dish_id"] != null){
        print(response_body);
        print("ggg");
      
        Dishes dish = Dishes.fromJson(response_body); 
          Provider.of<DishesProvider>(context, listen: false).addDishesList(dish);
      ModifyDish(dish);
       }
 
      
CustomSnackBar().ErrorMsgSnackBar("Variant Added");
  }else{
    
CustomSnackBar().ErrorSnackBar();
  }
  }
  catch(e){
context.loaderOverlay.hide();
CustomSnackBar().ErrorSnackBar();
 print(e);
  }
}

Future pickImage() async {
//     try {
//       final image = await ImagePicker().pickImage(source: ImageSource.gallery);
// if(image == null) return;


//       final imageTemp = File(image.path);

//       setState(() => this._image = imageTemp);
  
//     } 
//      catch(e) {
//       print('Failed to pick image: $e');
//     }
  }


  void ModifyDish(Dishes nDish){
    dish = nDish;
    setState(() {});
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
    return SafeArea(
      
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
               if (!formGlobalKey.currentState!.validate()) {
                          return;
                        }
              UpdateDishHandler();
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
          iconTheme: IconThemeData(color: AppColors.greyBlackcolor),
         backgroundColor: AppColors.whitecolor,
          elevation: 0.4,
          title: Text("Edit", style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(17), fontWeight: FontWeight.w500),),
        ),
        backgroundColor: AppColors.whitecolor,
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
              padding: const EdgeInsets.all(13),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Container(
                margin: EdgeInsets.only(top: ScreenUtil().setSp(10)),
                decoration: boxdecoration,
                child:   TextFormField(
                  controller: textInputController["name"],
                   onChanged: (value){
                  dish?.name = value;
                  },
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
                  onChanged: (value){
                  dish?.price = int.parse(value);
                  dish?.regularPrice = int.parse(value);
                  },
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
                   onChanged: (value){
                  dish?.salePrice = int.parse(value);
                  },
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
                      onChanged: (value){
                  dish?.description = value;
                  },
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
                  Text("visible", style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w500),),
                  Switch(value: dish?.status ==  1 ? true : false, onChanged: (value){
                   dish?.status = dish?.status == 1 ? 0 : 1;
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
                  Text("Veg", style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w500),),
                  Switch(value: dish?.vegType ==  1 ? true : false, onChanged: (value){
                   dish?.vegType = dish?.vegType == 1 ? 0 : 1;
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
                  Text("Variants", style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w500),),
                  Switch(value: dish?.variants ==  1 ? true : false, onChanged: (value){
                   dish?.variants = dish?.variants == 1 ? 0 : 1;
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
                  Text("add Price With variant", style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w500),),
                  Switch(value: dish?.priceType ==  1 ? true : false, onChanged: (value){
                   dish?.priceType = dish?.priceType == 1 ? 0 : 1;
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
              SizedBox(height: 20,),
              
              Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: 
                (dish?.image != null || dish?.image != "") 
                ? 
                _image != null?
                Container(
              height: ScreenUtil().setHeight(100),
              width: ScreenUtil().setWidth(100),
              child: Image.file(_image!),
                ): (
                InkWell(
            onTap: (){
              pickImage();
            },
            child: InkWell(
              onTap: (){
                  
              },
              child: Container(
                height: ScreenUtil().setHeight(100),
                width: ScreenUtil().setWidth(100),
                decoration: BoxDecoration(color: AppColors.whitecolor, borderRadius: BorderRadius.circular(5), border: Border.all(width: 1, color: AppColors.lightgreycolor)),
               child: Stack(
                 children: [
                  // Positioned(
                  //   top: 0,
                  //   right: 0,
                  //   bottom: 0,
                  //   child: InkWell( 
                  //   child: Icon(Icons.edit),
                  // )),
                   Image.network(dish?.image ?? '', fit: BoxFit.contain,),
                   Icon(Icons.edit, color: AppColors.primaryColor,)
                 ],
               ),
              ),
            ),
                )   
                )
                :
                
                InkWell(
            onTap: (){
              pickImage();
            },
            child: Container(
              height: ScreenUtil().setHeight(100),
              width: ScreenUtil().setWidth(100),
              child: Icon(Icons.add_a_photo, color: AppColors.lightgreycolor, size: ScreenUtil().setSp(20),),
              decoration: BoxDecoration(color: AppColors.whitecolor, borderRadius: BorderRadius.circular(5), border: Border.all(width: 1, color: AppColors.lightgreycolor)),
            ),
                ),
              ),
                  SizedBox(height: 10,),
          
          
                  Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryColor),
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
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: (){
                AddVariantBottomSheet(context, addVariantHandler);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: AppColors.primaryColor, size: ScreenUtil().setSp(30),),
                  Text("Add Variant", style: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),)
                ],
              ),
            ),
                  ),
          SizedBox(height: 10,),
          
                  if((dish?.dishVariants?.length ?? 0) > 0)
                  Container(
            decoration: boxdecoration,
            padding: const EdgeInsets.all(10),
            child:   Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            
              Row(
            
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
            
            children: [
            
                
            
              Text("Variants", style: TextStyle(color: AppColors.greyBlackcolor, fontSize: ScreenUtil().setSp(15), fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500),)
            
            ,      Switch(value: dish?.variants ==  1 ? true : false, onChanged: (value){
                   dish?.variants = dish?.variants == 1 ? 0 : 1;
                   setState(() { }); 
                  },
                  
                     activeColor: AppColors.primaryColor,  
                        activeTrackColor: Color(0xFFFDD4D7),  
                        inactiveThumbColor: AppColors.greyBlackcolor,  
                        inactiveTrackColor: AppColors.lightgreycolor,  
                    
                  )
               
            
            ],
            
                
            
                ),
                  
                  ReorderableListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
            for (var i = 0; i < (dish?.dishVariants?.length ?? 0); i++)
            Container(
               key: ValueKey(dish?.dishVariants?[i]),
             child: Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                         child: ExpansionTile(
                           tilePadding: EdgeInsets.all(0),
                           collapsedTextColor: AppColors.blackcolor,
                           collapsedIconColor: AppColors.blackcolor,
                           textColor: AppColors.blackcolor,
                           iconColor: AppColors.blackcolor,
                       
                           initiallyExpanded: true,
                             title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text("${dish?.dishVariants?[i]?.name ?? ''}", style: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.bold),),
                              
                             Row(children: [

                              InkWell(
                                onTap: (){
                                  UpdateVariantBottomSheet(context, dish!.dishVariants![i], updateVariantHandler);
                                },
                                child:  Icon(Icons.update,
                                color: AppColors.primaryColor,
                                size: ScreenUtil().setSp(23),
                                ),
                              ),
                              SizedBox(width: 10,),
                                InkWell(
                                onTap: (){
                                   showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
    title: Text("Confirmation"),
    content: Text("Are you sure want to delete this ?"),
    actions: [
       TextButton(
    child: Text("yes"),
    onPressed:  () {
           Navigator.of(context).pop();
           deleteVariantHandler(dish!.dishVariants![i]!.variantId!, dish!.dishId!, dish!.restaurantId!);
    },
  ),
       TextButton(
    child: Text("no"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  ),
    ],
  );
    },
                                   );
                                },
                                child: Icon(Icons.delete,
                                color: AppColors.primaryColor,
                                size: ScreenUtil().setSp(23),
                                ),
                               ),
                               SizedBox(
                                width: ScreenUtil().setWidth(8),
                               ),
                               InkWell(
                                onTap: (){
                                  VariantItemForm(context, dish!.dishVariants![i], dish!.dishId!, dish!.restaurantId!,ModifyDish);
                                },
                                child: Icon(Icons.add_circle_outline_rounded,
                                color: AppColors.primaryColor,
                                size: ScreenUtil().setSp(23),
                                ),
                               )
                             ],)
                               ],
                             ),
          
          children: [
            // ListView.builder(
            //           physics: NeverScrollableScrollPhysics(),
            //           shrinkWrap: true,
            //           itemCount: dish?.dishVariants?[i]?.variantItems?.length ?? 0,
            //           itemBuilder: (context, index){
            //            return VariantDishCard(dish: dish?.dishVariants?[i]?.variantItems?[index],
            //            variant_index: i,
            //            item_index: index,
            //            toggleVisible: toggleVariantVisible,
            //            );
            //          })
          
            ReorderableListView(
              children: [
                for(int index =0;index < (dish?.dishVariants?[i]?.variantItems?.length ?? 0); index ++)
                Container(
                  key: ValueKey(dish?.dishVariants?[i]?.variantItems?[index]),
                  child: VariantDishCard(
            restaurantId: dish!.restaurantId!,
            dish: dish?.dishVariants?[i]?.variantItems?[index],
            dish_id: dish!.dishId,
                 variant_index: i,
                 item_index: index,
                 toggleVisible: toggleVariantVisible,
               modifyDish: ModifyDish,
               deleteVariant: deleteVariantItemHandler
                 ),
                )
              ], 
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            onReorder: (int oldindex, int newindex){
              print("kkkkk");
              final _dish = dish;
           final variantsItems = _dish?.dishVariants?[i]?.variantItems;
               if (newindex > oldindex) {
                  newindex -= 1;
                }
                final items = variantsItems?.removeAt(oldindex);
                   variantsItems?.insert(newindex, items!);
          
                   for(int v  = 0; v < (variantsItems?.length ?? 0); v++ ){
            print(v);
            variantsItems?[v]?.position = v;
                   }
                   final jj = json.encode(_dish);
                   print(jj);
                   dish = _dish;
                   setState(() { });
            })
          ],
                         )
              ),
            )
                  
                  ], onReorder: reorderData)
                
              ],
            
            ),
                  )
             
              ],)
            ),
          ),
        ),
      ),
    );
  }
}