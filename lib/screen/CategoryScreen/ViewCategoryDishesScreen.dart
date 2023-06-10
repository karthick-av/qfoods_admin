


import 'dart:convert';

import 'package:admin/Provider/CategoryProvider.dart';
import 'package:admin/components/SearchDish.dart';
import 'package:admin/constants/CustomSnackBar.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/CategoryDishesModel.dart';
import 'package:admin/model/CategoryModel.dart';
import 'package:admin/navigation/DrawerNavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class ViewCategoryDishesScreen extends StatefulWidget {
  final CategoryModel category;
  const ViewCategoryDishesScreen({super.key, required this.category});

  @override
  State<ViewCategoryDishesScreen> createState() => _ViewCategoryDishesScreenState();
}

class _ViewCategoryDishesScreenState extends State<ViewCategoryDishesScreen> {
  
 ScrollController scrollController = ScrollController();

bool ApiCallDone = false;
int current_page = 1;
bool CompleteAPI = false;
int per_page = 10;
bool loading = false;
bool footer_loading = false;
String filterCondition = "";

void initState(){
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    
   final dishesProvider = Provider.of<CategoryDishesProvider>(context, listen: false);
   if((dishesProvider?.list?.length ?? 0) == 0){
      getCategoriesHandler("init", "");
  
   }
  });
     scrollController.addListener(() { 
      //listener 
    
      // if(scrollController.offset.toInt() > ScreenUtil().setHeight(32.0).toInt()){
        
        
      // }
      print(ApiCallDone);
        if(scrollController.position.maxScrollExtent == scrollController.offset){
       if(!ApiCallDone){
       getCategoriesHandler("bottom",filterCondition);
  
        
       }
    }
  
    });
    
 
  
}

void dispose(){
scrollController.dispose();
  super.dispose();
}

Future<void> getCategoriesHandler(String type, String filter)async {
   final dishesProvider = Provider.of<CategoryDishesProvider>(context, listen: false);
  
  if(CompleteAPI) return;

  List<CategoryDishesModel> _list= [];

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
       String url = "${ApiServices.get_categories}/dishes/${widget.category?.categoryId}?page=${current_page}&per_page=${per_page}&${filter}";
     print(url);
    var response = await http.get(Uri.parse(url));

          setState(() {
    ApiCallDone = false;
  });

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
     
      _list.add(CategoryDishesModel.fromJson(json));
       }

       setState(() {
    current_page = current_page + 1;
    });
      if(type == "init"){
      dishesProvider.addAll(_list);   
      }else{
       dishesProvider.add(_list);   
     
      }

    }else{
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


void ResetState(){
 ApiCallDone = false;
current_page = 1;
 CompleteAPI = false;
 
setState(() {});
}

void filterHandler(String selectedDate, String fromDate, String toDate){
  final dishesProvider = Provider.of<CategoryDishesProvider>(context, listen: false);
  
  ResetState();
  dishesProvider.addAll([]);

String val = '';
if(selectedDate != ""){
 val = "&selected_date=${selectedDate}";
}
if(fromDate != "" && toDate != ""){
 val = "&from_date=${fromDate}&to_date=${toDate}";

}
filterCondition = val;
setState(() {});
getCategoriesHandler("init", val);
}



Future<void> AdditemHandler(List<CategoryDishesModel> dishes) async{
     try{
       String url = "${ApiServices.get_categories}/dishes/";
     List<dynamic> data = [];
     dishes?.forEach((e) {
      data.add({
        "dish_id": e?.dishId?.toString(),
        "category_id":  widget?.category?.categoryId?.toString()
      });
     });
 var header ={
  'Content-type': 'application/json'
 };
   final body = jsonEncode(data); // Convert the list to a JSON string
   var response = await http.post(Uri.parse(url), body: body, headers: header
    );
    
    if(response.statusCode == 200){
      CustomSnackBar().ErrorMsgSnackBar("Items Added");
    }else{
      CustomSnackBar().ErrorSnackBar();
    }
}
catch(e){
  print(e);
  CustomSnackBar().ErrorSnackBar();
}
}

Future<void> deleteitemHandler(CategoryDishesModel dish) async{
  final dishesProvider = Provider.of<CategoryDishesProvider>(context, listen: false);
     try{
       String url = "${ApiServices.get_categories}/dishes/${widget?.category?.categoryId}/${dish?.dishId}";
   print(url);
     var response = await http.delete(Uri.parse(url));
    if(response.statusCode == 200){
      CustomSnackBar().ErrorMsgSnackBar("Item Deleted");
      dishesProvider.remove(dish);
   //   listController.removeDish(dish);
    }else{
      CustomSnackBar().ErrorSnackBar();
    }
}
catch(e){
  print(e);
  CustomSnackBar().ErrorSnackBar();
}
}


  @override
  Widget build(BuildContext context) {
   double width = MediaQuery.of(context).size.width;
 final dishesProvider = Provider.of<CategoryDishesProvider>(context, listen: true);
  

    return Scaffold(
       drawer: DrawerMenu(),
      appBar: AppBar(
        title: Text("Category"),
       actions: [
        InkWell(
          onTap: (){
           SearchDish(context, AdditemHandler);
          },
          child: Icon(Icons.add_circle_outline_rounded, color: AppColors.whitecolor, size: ScreenUtil().setSp(20),),
        ),

        SizedBox(width: 10,)
       ],

      ),
      body: RefreshIndicator(
             onRefresh: () async{
              ResetState();
                await getCategoriesHandler("init", "");
               
              },
            child: Column(
              children: [
                 Container(
           padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
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
                             onSubmitted: (String val)async{
                            ResetState();
                await getCategoriesHandler("init", "search=${val}");
              
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

                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                         if(loading)
                                     LinearProgressIndicator(
                                      
                                      backgroundColor: AppColors.whitecolor,
                                       valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),  
                          minHeight: 10,
                                    ),
                         ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: dishesProvider?.list?.length ?? 0,
                          itemBuilder: (BuildContext context, int index){
                            final data = dishesProvider?.list;
                           return Slidable(
                              startActionPane: ActionPane(
                              extentRatio: 0.25,
                               motion: const ScrollMotion(),
children:  [
      // A SlidableAction can have an icon and/or a label.
      SlidableAction(
        onPressed: ((context) {
        deleteitemHandler(data![index]);
        }),
        backgroundColor: Color(0xFFFE4A49),
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: 'Delete',
      )
    ],
                             ) ,
                             endActionPane: ActionPane(
                              extentRatio: 0.25,
                               motion: const ScrollMotion(),
children:  [
      // A SlidableAction can have an icon and/or a label.
      SlidableAction(
         onPressed: ((context) {
        deleteitemHandler(data![index]);
        }),
        backgroundColor: Color(0xFFFE4A49),
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: 'Delete',
      )
    ],
                             ) ,
                     
                             child: Container(
                                             padding:  const EdgeInsets.symmetric( horizontal: 10),
                                             width: width * 0.90,
                                             margin: const EdgeInsets.only(top: 10),
                                               
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
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              
                           if(data?[index]?.image != null)
                                          ClipRRect(
                                         borderRadius: BorderRadius.circular(8.0),
                                        child: Container(
                                          height: ScreenUtil().setHeight(100),width: ScreenUtil().setWidth(80),
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                          child: Image.network(data?[index].image ?? '',)),
                                      ),
                                      
                                          SizedBox(width: 10,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                            Text("${data?[index]?.name ?? ''}",
                                            style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.bold),
                                            ),
                                             Text("${data?[index]?.restaurantName ?? ''}",
                                            style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w500),
                                            )
                                          ]),
                           
                                            ],
                                          ),
                                          Column(
                                            children: [
                                             if(data?[index]?.salePrice != "" && data?[index]?.salePrice != 0)
                                    Text("Rs ${data?[index]?.salePrice ?? ''}",
                                            style: TextStyle(
                                                 decoration: TextDecoration.lineThrough,
                                   
                                              color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w500),
                                    ),
                                               
                                     
                                                 Text("Rs ${data?[index]?.price ?? ''}",
                                            style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w500),
                                           
                                            )
                                            ],
                                          )
                                        ],
                                      ),
                                     
                                           ),
                           );
                         }),
                          
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
                               SizedBox(height: MediaQuery.of(context).size.height,)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}


class CategoryDishesProvider extends ChangeNotifier{
  List<CategoryDishesModel> list = [];

  addAll(List<CategoryDishesModel> data){
    list = data;
    notifyListeners();
  }
  add(List<CategoryDishesModel> data){
    list = [...list, ...data];
    notifyListeners();
  }
   remove(CategoryDishesModel data){
     list.removeWhere((e) => e?.dishId == data?.dishId);
    notifyListeners();
  }
}