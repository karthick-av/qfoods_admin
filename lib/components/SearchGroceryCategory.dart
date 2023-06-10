
import 'dart:convert';
import 'package:admin/Provider/groceryProductsProvider.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import 'package:admin/model/GroceryProductModel.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';



void SearchGroceryCategory(BuildContext context, Future<void> Function(List<Category> categories) additemHandler){
  double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
bool loading = false;
final SelectedProvider = Provider.of<SearchGroceryCategoryProvider>(context, listen: false);




    Future<void> searchHandler(String text, StateSetter myState)async {
  
  List<Category> _list= [];
  
myState(() {
    loading = true;
  
});

  
try{
       String url = "${ApiServices.search_grocery_categories}${text}";
     print(url);
    var response = await http.get(Uri.parse(url));

         
myState(() {
    loading = false;
  
});

    if(response.statusCode == 200){
       var response_body = json.decode(response.body);

       for(var json in response_body){
     
      _list.add(Category.fromJson(json));
       }
     SelectedProvider.addCategories(_list);

  }
}
  catch(err){
   myState(() {
    loading = false;
  
});
  
}
 }
  
  
   showDialog(
      context: context,
      builder: (BuildContext context) {
            return Dialog(
              insetPadding: EdgeInsets.zero,
              child: StatefulBuilder(
                builder: (context, myState) {
                  final SelectedProvider = Provider.of<SearchGroceryCategoryProvider>(context, listen: true);
final SelectedCategories = SelectedProvider.SelectedCategories;
 final categories = SelectedProvider.categories;

                  return Scaffold(
                    bottomNavigationBar: (SelectedCategories?.length ?? 0) > 0 ?
                    InkWell( 
            onTap: () async{
              loading = true;
              myState(() => {});

              await additemHandler(SelectedCategories);
                Navigator.of(context).pop();
    
              loading = false;
              myState(() => {});

          //  UpdateMenuHandler();
            
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
         )
                    : SizedBox(),
                    backgroundColor: AppColors.whitecolor,
                     appBar: AppBar(
                      title: const Text('Search Categories',
                      style: TextStyle(color: AppColors.whitecolor),
                      ),
                      centerTitle: false,
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ),

                    body: Column(
                      children: [
                      SizedBox(height: 10,),
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
                                      onSubmitted: (String txt){
                                        searchHandler(txt, myState);
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
 
                           if((SelectedCategories?.length ?? 0) > 0)
                                    InkWell(
                                      onTap: (){
                                       SelectedDishesDialog(context);
                                      },
                                      child: Container(
                                       margin: const EdgeInsets.only(left: 20),
                                        child: Row(
                                          children: [
                                            Text("Selected Categories ",
                                              style: TextStyle(color: AppColors.primaryColor,fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15)),
                                              ),
                                            Container(
                                        padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.primaryColor
                                              ),
                                              child: Text("${SelectedCategories?.length ?? 0}",
                                              style: TextStyle(color: AppColors.whitecolor,fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                         Expanded(
                           child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: categories?.length ?? 0,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            itemBuilder: (BuildContext context, int index){
                              final data = categories;
                             return Center(
                               child: InkWell(
                                onTap: (){
                                 SelectedProvider.Selected(data[index]);
                                  },
                                 child: Stack(
                                   children: [
                                    Container(
                                margin: const EdgeInsets.only(top: 10),
                                             padding: const EdgeInsets.all(14.0),
                                             
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
                                          
                                             
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                     borderRadius: BorderRadius.circular(8.0),
                                    child: Container(
                                      height: ScreenUtil().setHeight(50),width: ScreenUtil().setWidth(50),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                      child: Image.network(data?[index].image ?? '', height: ScreenUtil().setHeight(50),width: ScreenUtil().setWidth(50),)),
                                  ),
                                  SizedBox(width: 10,),
                                  Text(data?[index].categoryName ?? '', style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w400),)
                                ],
                              )
                             ),
                                  
                                                 if((SelectedCategories?.where((e) => e?.categoryId == data?[index]?.categoryId)?.length ?? 0) > 0)
                                                  Positioned(
                                                    left: 0,
                                                    top: 10,
                                                    child: Icon(Icons.check_box, color: AppColors.primaryColor, size: ScreenUtil().setSp(20),)),
                                    
                                   ],
                                 ),
                               ),
                             );
                           }),
                         ),
                       
                    ]),
                  );
                }
              )
            );
          
      }
     ).then((value){
    
final SelectedProvider = Provider.of<SearchGroceryCategoryProvider>(context, listen: false);
SelectedProvider.addCategories([]);
SelectedProvider.addSelectedCategories([]);
     });
}



void SelectedDishesDialog(BuildContext context){
  double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
   

   showDialog(
      context: context,
      builder: (BuildContext context) {
            return Dialog(
              insetPadding: EdgeInsets.zero,
              child: StatefulBuilder(
                builder: (context, myState1) {
   
  final SelectedProvider = Provider.of<SearchGroceryCategoryProvider>(context, listen: true);
final categories = SelectedProvider.SelectedCategories;
                  return Scaffold(
                    backgroundColor: AppColors.whitecolor,
                     appBar: AppBar(
                      title: const Text('Selected Dishes',
                      style: TextStyle(color: AppColors.whitecolor),
                      ),
                      centerTitle: false,
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ),

                    body: Column(
                      children: [
                         Expanded(
                           child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: categories?.length ?? 0,
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            itemBuilder: (BuildContext context, int index){
                              final data = categories;
                             return Center(
                               child: InkWell(
                                onTap: (){
                                // selectedHandler(dishes[index], myState);
                                  // if((dishes?.where((e) => e?.dishId == data?[index]?.dishId)?.length ?? 0) > 0){
                                  //   dishes.removeWhere((e) => e?.dishId == data?[index]?.dishId);
                                                        
                                  // }else{
                                  //   dishes.add(data[index]);
                                  // }
                                  // myState1(() => {});
                                  
                                 SelectedProvider.Selected(data[index]);
                                  },
                                 child: Stack(
                                   children: [
                                   Container(
                                margin: const EdgeInsets.only(top: 10),
                                             padding: const EdgeInsets.all(14.0),
                                             
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
                                          
                                             
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                     borderRadius: BorderRadius.circular(8.0),
                                    child: Container(
                                      height: ScreenUtil().setHeight(50),width: ScreenUtil().setWidth(50),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                      child: Image.network(data?[index].image ?? '', height: ScreenUtil().setHeight(50),width: ScreenUtil().setWidth(50),)),
                                  ),
                                  SizedBox(width: 10,),
                                  Text(data?[index].categoryName ?? '', style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w400),)
                                ],
                              )
                             )  ,            if((categories?.where((e) => e?.categoryId == data?[index]?.categoryId)?.length ?? 0) > 0)
                                                  Positioned(
                                                    left: 0,
                                                    top: 10,
                                                    child: Icon(Icons.check_box, color: AppColors.primaryColor, size: ScreenUtil().setSp(20),)),
                                    
                                   ],
                                 ),
                               ),
                             );
                           }),
                         ),
                       
                    ]),
                  );
                }
              )
            );
          
      }
     );
}