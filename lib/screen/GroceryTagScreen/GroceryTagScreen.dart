


import 'dart:convert';

import 'package:admin/components/GroceryTagForm.dart';
import 'package:admin/constants/CustomSnackBar.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/GroceryProductModel.dart';
import 'package:admin/model/GroceryTagModel.dart';
import 'package:admin/navigation/DrawerNavigation.dart';
import 'package:admin/screen/GroceryTagScreen/ViewGroceryTagProductsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class GroceryTagScreen extends StatefulWidget {
  const GroceryTagScreen({super.key});

  @override
  State<GroceryTagScreen> createState() => _GroceryTagScreenState();
}

class _GroceryTagScreenState extends State<GroceryTagScreen> {
  
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
    final list = Provider.of<GroceryTagProvider>(context, listen: false);

   if((list?.list?.length ?? 0) == 0){
      getTagsHandler("init", "");
  
   }
  });
     scrollController.addListener(() { 
      //listener 
    
      // if(scrollController.offset.toInt() > ScreenUtil().setHeight(32.0).toInt()){
        
        
      // }
      print(ApiCallDone);
        if(scrollController.position.maxScrollExtent == scrollController.offset){
       if(!ApiCallDone){
       getTagsHandler("bottom",filterCondition);
  
        
       }
    }
  
    });
    
 
  
}

void dispose(){
scrollController.dispose();
  super.dispose();
}

Future<void> getTagsHandler(String type, String filter)async {
  if(CompleteAPI) return;
final tagProvider = Provider.of<GroceryTagProvider>(context, listen: false);


  List<GroceryTagModel> _list= [];

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
       String url = "${ApiServices.get_grocery_tag}?page=${current_page}&per_page=${per_page}&${filter}";
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
            _list.add(GroceryTagModel.fromJson(json));
         
       }

       setState(() {
    current_page = current_page + 1;
    });
      if(type == "init"){
      tagProvider.addAll(_list);   
      }else{
       tagProvider.add(_list);   
     
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


Future<void> deleteHandler(int id) async{
 loading = true;
    setState(() {});
    final tagProvider = Provider.of<GroceryTagProvider>(context, listen: false);

  try{
   
      var response = await http.delete(Uri.parse("${ApiServices.get_grocery_categories}/${id}"));
  loading = false;
    setState(() {});
    
   if(response.statusCode == 200){
    tagProvider.remove(id);
  }
  }
  catch(e){
      loading = false;
    setState(() {});
    CustomSnackBar().ErrorSnackBar();
  }
}


void ResetState(){
 ApiCallDone = false;
current_page = 1;
 CompleteAPI = false;
 
setState(() {});
}

void filterHandler(String selectedDate, String fromDate, String toDate){
   final tagProvider = Provider.of<GroceryTagProvider>(context, listen: false);

  ResetState();
  tagProvider.addAll([]);

String val = '';
if(selectedDate != ""){
 val = "&selected_date=${selectedDate}";
}
if(fromDate != "" && toDate != ""){
 val = "&from_date=${fromDate}&to_date=${toDate}";

}
filterCondition = val;
setState(() {});
getTagsHandler("init", val);
}



  @override
  Widget build(BuildContext context) {
     final tagProvider = Provider.of<GroceryTagProvider>(context, listen: true);

    return Scaffold(
       drawer: DrawerMenu(),
      appBar: AppBar(
        title: Text("Tags"),
        actions: [
          InkWell(
            onTap: (){
              AddGrocerytagForm(context);
            },
            child: Icon(Icons.add_circle_outline_rounded, color: AppColors.whitecolor, size: ScreenUtil().setSp(20),),
          ),
          SizedBox(width: 10,)
        ],

      ),
      body: RefreshIndicator(
             onRefresh: () async{
              ResetState();
                await getTagsHandler("init", "");
               
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
                await getTagsHandler("init", "search=${val}");
              
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
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: tagProvider?.list?.length ?? 0,
                          itemBuilder: (BuildContext context, int index){
                            final data = tagProvider?.list;
                           return InkWell(
                            onTap: (){
              Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => 
                        ViewGroceryTagProductsScreen(tag: data![index],)),
                        );
                            },
                             child: Container(
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
                                          
                                             
                              child: Slidable(
                                startActionPane: ActionPane(
                              extentRatio: 0.25,
                               motion: const ScrollMotion(),
children:  [
      // A SlidableAction can have an icon and/or a label.
      SlidableAction(
        onPressed: ((context) {
        UpdateGroceryTagForm(context, data![index]);
         // UpdateDeliveryCharges(context, val, updateHandler);
        }),
        backgroundColor: AppColors.pricecolor,
        foregroundColor: Colors.white,
        icon: Icons.update,
        label: 'Update',
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
        deleteHandler(data?[index]?.tagId ?? 0);
        }),
        backgroundColor: Color(0xFFFE4A49),
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: 'Delete',
      )
    ],
                             ) ,
                     
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
                                    Text(data?[index].tagName ?? '', style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w400),)
                                  ],
                                ),
                              )
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


class GroceryTagProvider extends ChangeNotifier{
 List<GroceryTagModel> list = [];
  addAll(List<GroceryTagModel> data) {
    list = data;
    notifyListeners();
  }

  add(List<GroceryTagModel> data) {
     list = [...list, ...data];

    notifyListeners();
  }

  addNew(GroceryTagModel data) {
    int? index = list?.indexWhere((e) => (e?.tagId ?? 0) == data?.tagId);
    if(index == -1){
      list.insert(0, data);
    }
    
    notifyListeners();
  }

 Update(GroceryTagModel data) {
    int index = list?.indexWhere((e) => (e?.tagId ?? 0) == data?.tagId) ?? -1;
    if(index != -1){
      list[index] = data;
    }
    
    notifyListeners();
  }
  remove(int id) {
   list.removeWhere((e) => e?.tagId == id);
  }
  
    notifyListeners();
}