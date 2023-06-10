import 'dart:async';
import 'dart:convert';

import 'package:admin/Provider/groceryProductsProvider.dart';
import 'package:admin/components/AddProductsForm.dart';
import 'package:admin/components/GroceryProductCard.dart';
import 'package:admin/constants/CustomSnackBar.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/GroceryProductModel.dart';
import 'package:admin/navigation/DrawerNavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
class GroceryProductsScreen extends StatefulWidget {
  const GroceryProductsScreen({super.key});

  @override
  State<GroceryProductsScreen> createState() => _GroceryProductsScreenState();
}

class _GroceryProductsScreenState extends State<GroceryProductsScreen> {
  
 ScrollController scrollController = ScrollController();

bool ApiCallDone = false;
int current_page = 1;
bool CompleteAPI = false;
int per_page = 10;
bool loading = false;
bool footer_loading = false;


TextEditingController searchController = TextEditingController();

void initState(){
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    getHandler("init", "");
  });
     scrollController.addListener(() { 
      //listener 
    
      // if(scrollController.offset.toInt() > ScreenUtil().setHeight(32.0).toInt()){
        
        
      // }
        if(scrollController.position.maxScrollExtent == scrollController.offset){
       if(!ApiCallDone){
     
        getHandler("bottom", searchController?.value?.text ?? '');
        
       }
    }
  
    });
    
 
  super.initState();
}

void dispose(){
scrollController.dispose();
searchController.dispose();
  super.dispose();
}

Future<void> getHandler(String type, String SearchText)async {
  if(CompleteAPI) return;

  List<GroceryProductModel> _products= [];

 if(type == "init"){
setState(() {
    loading = true;
  
});
 }else{
setState(() {
    footer_loading = true;
  
});
 }

  setState(() {
    ApiCallDone = true;
  });
try{
       String url = SearchText != "" ? "${ApiServices.getGrocery}?search=${SearchText}&page=${current_page}&per_page=${per_page}" : "${ApiServices.getGrocery}?page=${current_page}&per_page=${per_page}";
  print(url);
    var response = await http.get(Uri.parse(url));
    if(type == "init"){
setState(() {
    loading = false;
  
});
 }else{
setState(() {
    footer_loading = false;
  
});
 }
    if(response.statusCode == 200){
       var response_body = json.decode(response.body);

       if(response_body!.length == 0){
        setState(() {
          CompleteAPI = true;
        });
       }
       
       for(var json in response_body){
     
      _products.add(GroceryProductModel.fromJson(json));
       }

       setState(() {
    current_page = current_page + 1;
    ApiCallDone = false;
 

      if(type == "init"){
  Provider.of<GroceryProductsProvider>(context, listen: false).addAllproducts(_products);
      
      }else{
         Provider.of<GroceryProductsProvider>(context, listen: false).addProducts(_products);
      
      }

       });
    }else{
      setState(() {
    ApiCallDone = false;
  });
    }
  }
  catch(err){
    if(type == "init"){
setState(() {
    loading = false;
  
});
 }else{
setState(() {
    footer_loading = false;
  
});
 }
 setState(() {
    ApiCallDone = false;
  });
  }
  
}

Future<void> deleteHandler(int id) async{
  setState(() {
    loading = true;
  
});
try{
   var response = await http.delete(Uri.parse("${ApiServices.deleteRestaurants}/${id}"));
  setState(() {
    loading = false;
  
});
   if(response.statusCode == 200){
CustomSnackBar().ErrorMsgSnackBar("deleted");
//  Provider.of<RestaurantsProvider>(context, listen: false).deleteRestaurant(id);
      
   }else{
CustomSnackBar().ErrorSnackBar();
      
   }
   

}catch(e){

CustomSnackBar().ErrorSnackBar();
  setState(() {
    loading = false;
  
});
}

}


void ResetState(){
 ApiCallDone = false;
current_page = 1;
 CompleteAPI = false;
setState(() {});
}


Future<void> UpdateStatusHandler(GroceryProductsProvider products) async{
//   print("object");
//     List<dynamic> updateData = [];
//     products?.products?.forEach((e) {
//       updateData.add({
//       "grocery_id", e?.groceryId,
//       "status", e?.status
//     });
//     });
//    final changedList = updateData?.where((e){
//     print(e);
//     return (products?.list?.where((m) => e["grocery_id"] == m["grocery_id"] && e["status"] != m["status"])?.length ?? 0) > 0;

//    });
//    print(changedList?.length);
  
// //   try{
  
// //   // setState(() {
// //   //   loading = true;
// //   // });
// //   }
// //   catch(e){
// // print(e);
// //   }
}

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<GroceryProductsProvider>(context, listen: true);
    double height =  MediaQuery.of(context).size.height;
    double width =  MediaQuery.of(context).size.width;
    return  Scaffold(
       backgroundColor: AppColors.whitecolor,
         bottomNavigationBar: 
      (products?.products?.length ?? 0) > 0 ?
      Container( 
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
         ? CircularProgressIndicator(color: AppColors.primaryColor, strokeWidth: 1,)
         :
         InkWell( 
          onTap: (){
       UpdateStatusHandler(products);
          },
          child: Container( 
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
          ): SizedBox(),
         drawer: DrawerMenu(),
            appBar: AppBar( 
         iconTheme: IconThemeData(color: AppColors.greyBlackcolor),
        elevation: 0.5,
        backgroundColor: AppColors.whitecolor,
        
         title: Text('Grocery',style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(16))),
         actions: [
          
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: InkWell(
          onTap: (){
              // Navigator.push(
              //             context,
              //             MaterialPageRoute(builder: (context) => 
              //           AddRestaurantScreen()),
              //           );

              AddGroceryProductsForm(context);
          },
              child: Icon(Icons.add_circle_outline_rounded, color: AppColors.primaryColor, size: ScreenUtil().setSp(25),),
            ),
          ),
         ],
        
      ),
      body: Column(
        children: [
           Container(
           padding: const EdgeInsets.symmetric(horizontal: 15),
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
                           child: TextField(
                            onChanged: (String val) {
                            if((val?.length ?? 0) > 2){
                             
                             loading = true;
                              setState(() {     });
                              ResetState();
                            Timer(Duration(seconds: 1), () {

                                Provider.of<GroceryProductsProvider>(context, listen: false).addAllproducts([]);
     
                              setState(() {     });
                             
getHandler("init", val);
});
                            }
                            },
            
                                    
                                         style: TextStyle(fontSize: ScreenUtil().setSp(14.0), fontFamily: FONT_FAMILY, fontWeight: FontWeight.normal, color: AppColors.blackcolor),
                                         cursorColor: AppColors.greycolor,
                                     //  keyboardType: TextInputType.number,
                                         decoration:  InputDecoration(
                                labelText: 'Search',
                                  hintText: 'Search',
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

                         if(loading)
                           LinearProgressIndicator(
                            
                            backgroundColor: AppColors.whitecolor,
                             valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),  
                minHeight: 10,
                          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: ()async{
                ResetState();
                getHandler("init", "");
              },
              child: SingleChildScrollView(
                       
                controller: scrollController,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                     GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 14.0),
              itemCount: products?.products?.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 13.0,
                crossAxisCount: 2,
            childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 1.15),
              
            ), itemBuilder: ((context, index) {
              return GroceryCard(product: products.products![index]);
            })
            
            ), 
                      if(footer_loading)
                       Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: ScreenUtil().setSp(15), width: ScreenUtil().setSp(15),
                            child: CircularProgressIndicator(strokeWidth: 1.0,color: AppColors.primaryColor,),
                            ),
                            SizedBox(width: 10,),
                            Text("Load More", style: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(16)),)
                          ],
                        ),
                       ),

                       SizedBox(height: MediaQuery.of(context).size.height * 0.70,)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}