
import 'dart:convert';

import 'package:admin/Provider/groceryProductsProvider.dart';
import 'package:admin/components/GroceryVariantItemCard.dart';
import 'package:admin/components/SearchGroceryBrands.dart';
import 'package:admin/components/SearchGroceryCategory.dart';
import 'package:admin/components/SearchGroceryTypes.dart';
import 'package:admin/components/VariantBottomSheet.dart';
import 'package:admin/constants/CustomSnackBar.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/GroceryProductModel.dart';
import 'package:admin/screen/EditProductScreen/GroceryVariantItemForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class EditProductScreen extends StatefulWidget {
  final GroceryProductModel gproduct;
  const EditProductScreen({super.key, required this.gproduct});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  
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
int visible = 0;
int variants = 0;
List<Brands> brands = [];
late GroceryProductModel  product;
List<Types> types = [];
List<Category> categories = [];
late final Map<String, TextEditingController> textInputController = {
  "name": TextEditingController(text: widget?.gproduct?.name),
  "regular_price": TextEditingController(text: widget?.gproduct?.regularPrice?.toString()),
  "sales_price": TextEditingController(text: widget?.gproduct?.salePrice?.toString()),
  "description": TextEditingController(text: widget?.gproduct?.description),
  "keywords": TextEditingController(text: widget?.gproduct?.keywords),
  
  };

  Future<void> UpdateProductHandler() async{
  loading = true;
  setState(() {});
  try{
    final _product = product;
    List<VariantItems>?  vitems = _product?.variantItems;
     for(int i = 0; i < (vitems?.length ?? 0); i++){
      vitems?[i]?.position = i+1;
      for(int j = 0; j < (vitems?[i]?.items?.length ?? 0); j++){
         vitems?[i].items?[j]?.position = j + 1;
      } 
     }
     _product.variantItems = vitems;

   

   final data = json.encode(_product);
   print(json.encode(_product.variantItems));
      var header ={
  'Content-type': 'application/json'
 };
    var response = await http.put(Uri.parse("${ApiServices.Edit_product}"), body: data, headers: header);
    loading = false;
  setState(() {});
    
     if(response.statusCode == 200){
            var response_body = json.decode(response.body);
        
        GroceryProductModel _product = GroceryProductModel.fromJson(response_body);
          
 
   Provider.of<GroceryProductsProvider>(context, listen: false).updateProduct(_product);

 product = _product;
 setState(() {});
 
 
      
CustomSnackBar().ErrorMsgSnackBar("Product Updated");
  }else{
    
CustomSnackBar().ErrorSnackBar();
  }
  }
  catch(e){
    print(e);
  loading = false;
  setState(() {});
  CustomSnackBar().ErrorSnackBar();
  }
}


  Future<void> addBrandsHandler(List<Brands> data) async{
  brands = data;
setState(() => {});
}
Future<void> addTypesHandler(List<Types> data) async{
  types = data;
setState(() => {});
}
Future<void> addCategoryHandler(List<Category> data) async{
  categories = data;
setState(() => {});
}



void initState(){
   
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    status = widget?.gproduct?.status ?? 0;
 variants = widget?.gproduct?.variants ?? 0;
 brands = widget?.gproduct?.brands ?? [];
 categories = widget?.gproduct?.category ?? [];
 types = widget?.gproduct?.types ?? [];
product = widget.gproduct;
 setState(() {});
  });
  super.initState();
}


Future<void> addVariantHandler(dynamic val) async{
  dynamic data = {
    "grocery_item_id":  widget?.gproduct?.groceryId?.toString(),
    "name": val["name"],
    "visible": val['visible']
  };

   try{
    final data_ = json.encode(data);
      var header ={
  'Content-type': 'application/json'
 };
    var response = await http.post(Uri.parse("${ApiServices.add_grocery_variant}"), body: data_, headers: header);
    
context.loaderOverlay.hide();
     if(response.statusCode == 200){
         var response_body = json.decode(response.body);
         print(response_body);
        
        GroceryProductModel _product = GroceryProductModel.fromJson(response_body);
          
 
   Provider.of<GroceryProductsProvider>(context, listen: false).updateProduct(_product);

 product = _product;
 setState(() {});
      
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


Future<void> deleteVariantHandler(int id) async{
 print("${ApiServices.delete_grocery_variant}/${widget?.gproduct?.groceryId}/${id}");
   try{
    var response = await http.delete(Uri.parse("${ApiServices.delete_grocery_variant}/${widget?.gproduct?.groceryId}/${id}"));
    
context.loaderOverlay.hide();
print(response?.statusCode);
     if(response.statusCode == 200){
         var response_body = json.decode(response.body);
        
        GroceryProductModel _product = GroceryProductModel.fromJson(response_body);
          
 
   Provider.of<GroceryProductsProvider>(context, listen: false).updateProduct(_product);

 product = _product;
 setState(() {});
      
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


Future<void> updateVariantHandler(dynamic val) async{
  dynamic data = {
    "grocery_item_id":  widget?.gproduct?.groceryId?.toString(),
    "name": val["name"],
    "visible": val['visible'],
    "variant_id": val['variant_id']
  };

   try{
    final data_ = json.encode(data);
      var header ={
  'Content-type': 'application/json'
 };
    var response = await http.put(Uri.parse("${ApiServices.update_grocery_variant}"), body: data_, headers: header);
    
context.loaderOverlay.hide();
     if(response.statusCode == 200){
         var response_body = json.decode(response.body);
        
        GroceryProductModel _product = GroceryProductModel.fromJson(response_body);
          
 
   Provider.of<GroceryProductsProvider>(context, listen: false).updateProduct(_product);

 product = _product;
 setState(() {});
      
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

void ModifyProduct(GroceryProductModel data){
  product = data;
  setState(() {});
}



Future<void> deleteVariantItemHandler(int id) async{
 print("${ApiServices.delete_grocery_variant}/${widget?.gproduct?.groceryId}/${id}");
   try{
    var response = await http.delete(Uri.parse("${ApiServices.delete_grocery_variant_item}/${widget?.gproduct?.groceryId}/${id}"));
    
context.loaderOverlay.hide();
print(response?.statusCode);
     if(response.statusCode == 200){
         var response_body = json.decode(response.body);
        
        GroceryProductModel _product = GroceryProductModel.fromJson(response_body);
          
 
   Provider.of<GroceryProductsProvider>(context, listen: false).updateProduct(_product);

 product = _product;
 setState(() {});
      
CustomSnackBar().ErrorMsgSnackBar("Variant Deleted");
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


void reorderData(int oldindex, int newindex) {
    final variants = product?.variantItems;
     if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = variants?.removeAt(oldindex);
         variants?.insert(newindex, items!);

         for(int i  = 0; i < (variants?.length ?? 0); i++ ){
          variants?[i]?.position = i;
         }
product?.variantItems = variants;
setState(() {});
  }



void toggleItemStatus(int vid, int iid){
  final product_ = product;
  product_?.variantItems?[vid]?.items?[iid]?.status =  product_?.variantItems?[vid]?.items?[iid]?.status == 0 ? 1 : 0;
  product = product_;

  setState(() { });
}

  @override
  Widget build(BuildContext context) {
   double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
   return Scaffold(
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
                        UpdateProductHandler();
                       // AddHandler(context, setState);
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
            child: Text("Update", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),),
          ),
         ),
          ),
      
                appBar: AppBar(
                  title:  const Text('Update Product',
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

                            onChanged: (String txt){
                              product.name = txt;
                              setState(() { });
                            },
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
                              onChanged: (String txt){
                              product.price = int.parse(txt);
                              product.regularPrice = int.parse(txt);
                              setState(() { });
                            },
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
               onChanged: (String txt){
                              product.salePrice = int.parse(txt);
                              setState(() { });
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
                   
                           controller: textInputController["description"],
                 
                        maxLines: 5, // <-- SEE HERE
                            minLines: 1,
                          onChanged: (String txt){
                              product.description = txt;
                              setState(() { });
                            }, 
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
                     onChanged: (String txt){
                              product.keywords = txt;
                              setState(() { });
                            }, 
                           controller: textInputController["Keywords"],
                 
                        maxLines: 5, // <-- SEE HERE
                            minLines: 1,
                         
                                                 style: textstyle,
                                                 cursorColor: AppColors.greycolor,
                                                 decoration:  InputDecoration(
                                        labelText: 'Keywords',
                                          hintText: 'Enter Keywords',
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
                AddGroceryVariantBottomSheet(context, addVariantHandler);
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
              Padding(
                padding:   EdgeInsets.only(left:8.0),
                child: Wrap(
            spacing: 20,
            children: [
              Column(
                children: [
                  Text("status", style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w500),),
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
              

                 
            ]
                ),
              ),
              const SizedBox(height: 20,),

                  ReorderableListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
            for (var i = 0; i < (product?.variantItems?.length ?? 0); i++)
            Container(
               key: ValueKey(product?.variantItems?[i]),
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
                                 Text("${product?.variantItems?[i]?.name ?? ''}", style: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.bold),),
                              
                             Row(
                              
                              
                              children: [
InkWell(
  onTap: (){
    UpdateGroceryVariantBottomSheet(context, product.variantItems![i], updateVariantHandler);
  },
  child: Icon(Icons.update,
                                color: AppColors.primaryColor,
                                size: ScreenUtil().setSp(23),
                                ),
),
 SizedBox(
                                width: ScreenUtil().setWidth(8),
                               ),

                                InkWell(
                                onTap: (){
                                   showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
    title: const Text("Confirmation"),
    content: Text("Are you sure want to delete this ?"),
    actions: [
       TextButton(
    child: Text("yes"),
    onPressed:  () {
           Navigator.of(context).pop();
           deleteVariantHandler(product?.variantItems?[i]?.id ?? 0);
        //   deleteVariantHandler(dish!.dishVariants![i]!.variantId!, dish!.dishId!, dish!.restaurantId!);
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
                                  GroceryVariantItemForm(context,product!.variantItems![i],product!.groceryId ?? 0,ModifyProduct);
                                 // VariantItemForm(context, dish!.dishVariants![i], dish!.dishId!, dish!.restaurantId!,ModifyDish);
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
            ReorderableListView(
              children: [
                for(int index =0;index < (product?.variantItems?[i]?.items?.length ?? 0); index ++)
                Container(
                  key: ValueKey(product?.variantItems?[i]?.items?[index]),
                  child: GroceryVariantItemCard(
                   item: product?.variantItems?[i]?.items?[index],
                   vid: i,
                   iid:index,
                   toggleItemStatus: toggleItemStatus,
                   deleteVariantItemHandler: deleteVariantItemHandler,
                   ModifyProduct: ModifyProduct,
                   grocery_id: product?.groceryId,
                    variant: product.variantItems![i]

                    ),
                )
              ], 
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            onReorder: (int oldindex, int newindex){
              print("kkkkk");
              final _product = product;
           final variantsItems = _product?.variantItems?[i]?.items;
               if (newindex > oldindex) {
                  newindex -= 1;
                }
                final items = variantsItems?.removeAt(oldindex);
                   variantsItems?.insert(newindex, items!);
          
                   for(int v  = 0; v < (variantsItems?.length ?? 0); v++ ){
            print(v);
            variantsItems?[v]?.position = v;
                   }
                   product = _product;
                   setState(() { });
            })
          ],
                         )
              ),
            )
                  
                  ], onReorder: reorderData)
              
              
                        ],
                      ),
                    ),
                  ),
                ),
              );
  }
}