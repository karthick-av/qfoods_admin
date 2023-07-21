import 'dart:async';
import 'dart:convert';

import 'package:admin/Provider/RestaurantsProvider.dart';
import 'package:admin/components/RestaurantCard.dart';
import 'package:admin/constants/CustomSnackBar.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/restaurantModel.dart';
import 'package:admin/navigation/DrawerNavigation.dart';
import 'package:admin/screen/RestaurantScreen/AddRestaurantScreen.dart';
import 'package:admin/screen/RestaurantScreen/MenusScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({super.key});

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  
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
    getRestaurantsHandler("init", "");
  });
     scrollController.addListener(() { 
      print(scrollController.offset);
      //listener 
    
      // if(scrollController.offset.toInt() > ScreenUtil().setHeight(32.0).toInt()){
        
        
      // }
        if(scrollController.position.maxScrollExtent == scrollController.offset){
       if(!ApiCallDone){
     
        getRestaurantsHandler("bottom", searchController?.value?.text ?? '');
        
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

Future<void> getRestaurantsHandler(String type, String SearchText)async {
  if(CompleteAPI) return;

  List<RestaurantModel> _restaurants= [];

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
       String url = SearchText != "" ? "${ApiServices.getRestaurants}?search=${SearchText}&page=${current_page}&per_page=${per_page}" : "${ApiServices.getRestaurants}?page=${current_page}&per_page=${per_page}";
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
     
      _restaurants.add(RestaurantModel.fromJson(json));
       }

       setState(() {
    current_page = current_page + 1;
    ApiCallDone = false;
 

      if(type == "init"){
  Provider.of<RestaurantsProvider>(context, listen: false).addAllRestaurants(_restaurants);
      
      }else{
         Provider.of<RestaurantsProvider>(context, listen: false).addRestaurants(_restaurants);
      
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
  Provider.of<RestaurantsProvider>(context, listen: false).deleteRestaurant(id);
      
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

  @override
  Widget build(BuildContext context) {
    final restaurants = Provider.of<RestaurantsProvider>(context, listen: true).restaurants;
    return  Scaffold(
       backgroundColor: AppColors.whitecolor,
         drawer: DrawerMenu(),
            appBar: AppBar( 
         iconTheme: IconThemeData(color: AppColors.greyBlackcolor),
        elevation: 0.5,
        backgroundColor: AppColors.whitecolor,
        
         title: Text('Restaurants',style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(16))),
         actions: [
          
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: InkWell(
          onTap: (){
              Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => 
                        AddRestaurantScreen()),
                        );
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
                           
                            onSubmitted: (String val){
                              if((val?.length ?? 0) > 2){
                             
                             loading = true;
                              setState(() {     });
                              ResetState();
                            Timer(Duration(seconds: 1), () {

                                Provider.of<RestaurantsProvider>(context, listen: false).addAllRestaurants([]);
     
                              setState(() {     });
                             
getRestaurantsHandler("init", val);
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
                getRestaurantsHandler("init", "");
              },
              child: SingleChildScrollView(
                       
                controller: scrollController,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                       ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: restaurants.length,
                        itemBuilder: (BuildContext context, int index){
                        return Slidable(
                                            startActionPane: ActionPane(
                              extentRatio: 0.25,
                               motion: const ScrollMotion(),
children:  [
      // A SlidableAction can have an icon and/or a label.
      SlidableAction(
        onPressed: ((context) {
       // deleteitemHandler(data![index]);
       deleteHandler(restaurants![index]?.restaurantId ?? 0);
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
       deleteHandler(restaurants![index]?.restaurantId ?? 0);
        }),
        backgroundColor: Color(0xFFFE4A49),
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: 'Delete',
      )
    ],
                             ) ,
            
                          child: RestaurantCard(RestaurantsModel: restaurants![index],));
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