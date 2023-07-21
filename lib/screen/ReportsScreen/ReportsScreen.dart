
import 'dart:convert';

import 'package:admin/components/FilterBottomSheet.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/RestaurantReportsModel.dart';
import 'package:admin/model/dishesreportsModel.dart';
import 'package:admin/navigation/DrawerNavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

class ReportsController extends GetxController{
bool dishApiCalled = false;
bool restaurantApiCalled = false;

 dishCalled() => dishApiCalled = true;
 restaurantCalled() => restaurantApiCalled = true;

 List<DishesReportsModel> dishesReports = [];
 List<RestaurantsReportsModel> restaurantsReports = [];
  addAllDishReports(List<DishesReportsModel> reports) => dishesReports = reports;
  addADishReports(List<DishesReportsModel> reports) => dishesReports = [...dishesReports, ...reports];

  addAllRestaurantReports(List<RestaurantsReportsModel> reports) => restaurantsReports = reports;
  addARestaurantsReports(List<RestaurantsReportsModel> reports) => restaurantsReports = [...restaurantsReports, ...reports];

}


class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen>  with SingleTickerProviderStateMixin  {
  late TabController tabController;

  

 
  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body:  DefaultTabController(
      length: 2,
      child: Scaffold(
          drawer: DrawerMenu(),
            appBar: AppBar( 
         iconTheme: IconThemeData(color: AppColors.greyBlackcolor),
         elevation: 0.0,
          backgroundColor: AppColors.whitecolor,
          title: Text("Reports", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(17)),),
          bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Container(
            height: 50.0,
            child: new TabBar(
              indicatorColor: Colors.red,
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.black,
              labelStyle: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(17)),
              tabs: [
                Tab(
                  text: "Dishes",
                  
                ),
                Tab(
                  text: "Restaurant",
                )
              ],
            ),
          ),
        ),
        ),
        body: TabBarView(
          children: [
            DishesReport(),
            RestaurantsReport()
          ],
        ),
      ),
    ),
      ),
    );
  }
}


class DishesReport extends StatefulWidget {
  const DishesReport({super.key});

  @override
  State<DishesReport> createState() => _DishesReportState();
}

class _DishesReportState extends State<DishesReport> {
  
 ScrollController scrollController = ScrollController();

bool ApiCallDone = false;
int current_page = 1;
bool CompleteAPI = false;
int per_page = 10;
bool loading = false;
bool footer_loading = false;
String filterCondition = "";
final ReportsController reportsController = Get.put(ReportsController());


void initState(){
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
   if((reportsController?.dishesReports?.length ?? 0) == 0 && reportsController.dishApiCalled ==false){
      getReportsHandler("init", "");
  
   }
  });
     scrollController.addListener(() { 
      //listener 
    
      // if(scrollController.offset.toInt() > ScreenUtil().setHeight(32.0).toInt()){
        
        
      // }
      print(ApiCallDone);
        if(scrollController.position.maxScrollExtent == scrollController.offset){
       if(!ApiCallDone){
       getReportsHandler("bottom",filterCondition);
  
        
       }
    }
  
    });
    
 
  
}

void dispose(){
scrollController.dispose();
  super.dispose();
}

Future<void> getReportsHandler(String type, String filter)async {
  if(CompleteAPI) return;

  List<DishesReportsModel> _reports= [];

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
       String url = "${ApiServices.dishes_reports}?page=${current_page}&per_page=${per_page}&${filter}";
    print(url);
    var response = await http.get(Uri.parse(url));
    reportsController.dishCalled();

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
     
      _reports.add(DishesReportsModel.fromJson(json));
       }

       setState(() {
    current_page = current_page + 1;
    });
      if(type == "init"){
      reportsController.addAllDishReports(_reports);   
      }else{
       reportsController.addADishReports(_reports);   
     
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
  ResetState();
  reportsController.addAllDishReports([]);

String val = '';
if(selectedDate != ""){
 val = "&selected_date=${selectedDate}";
}
if(fromDate != "" && toDate != ""){
 val = "&from_date=${fromDate}&to_date=${toDate}";

}
filterCondition = val;
setState(() {});
getReportsHandler("init", val);
}



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: (){
            FilterBottomSheet(context, filterHandler);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
             Icon(Icons.filter_alt_outlined, size: ScreenUtil().setSp(24), color: AppColors.blackcolor,)
            , Text("filter", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(17)),)
               ,  SizedBox(width: 10,),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
             onRefresh: () async{
             ResetState();
                await getReportsHandler("init", "");
               
              },
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
                    itemCount: reportsController?.dishesReports?.length ?? 0,
                    itemBuilder: (BuildContext context, int index){
                      final reports = reportsController?.dishesReports;
                     return Container(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Column(
                        children: [
                             Container(
                              width: MediaQuery.of(context).size.width * 0.70,
                              child: Text("${reports?[index]?.name ?? ''}", overflow: TextOverflow.ellipsis,style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(13)),)),
                             Container(
                              width: MediaQuery.of(context).size.width * 0.70,
                              child: Text("${reports?[index]?.restaurantName ?? ''}", overflow: TextOverflow.ellipsis,style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(11)),)),
                           
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                         decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor),
                      child: Text("${reports?[index]?.count ?? 0}", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(13)),),
                      )
                      
                      ]),
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
                         SizedBox(height: MediaQuery.of(context).size.height * 0.80,)
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}


class RestaurantsReport extends StatefulWidget {
  const RestaurantsReport({super.key});

  @override
  State<RestaurantsReport> createState() => _RestaurantsReportState();
}

class _RestaurantsReportState extends State<RestaurantsReport> {
 ScrollController scrollController = ScrollController();

bool ApiCallDone = false;
int current_page = 1;
bool CompleteAPI = false;
int per_page = 10;
bool loading = false;
bool footer_loading = false;
String filterCondition = "";
final ReportsController reportsController = Get.put(ReportsController());


void initState(){
     
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    if((reportsController?.restaurantsReports?.length ?? 0) == 0 && reportsController.restaurantApiCalled == false){
      getReportsHandler("init", "");
  
   }
  });
     scrollController.addListener(() { 
      //listener 
    
      // if(scrollController.offset.toInt() > ScreenUtil().setHeight(32.0).toInt()){
        
        
      // }
      print(scrollController.position.maxScrollExtent == scrollController.offset);
        if(scrollController.position.maxScrollExtent == scrollController.offset){
       if(!ApiCallDone){

       getReportsHandler("bottom", filterCondition);
  
        
       }
    }
  
    });
    
 
  super.initState();
}

void dispose(){
scrollController.dispose();
  super.dispose();
}

Future<void> getReportsHandler(String type, String filter)async {
  if(CompleteAPI) return;

  List<RestaurantsReportsModel> _reports= [];

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
       String url = "${ApiServices.restaurant_reports}?page=${current_page}&per_page=${per_page}&${filter}";
  print(url);
    var response = await http.get(Uri.parse(url));
    reportsController.restaurantCalled();
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
     
      _reports.add(RestaurantsReportsModel.fromJson(json));
       }

       setState(() {
    current_page = current_page + 1;
 });

      if(type == "init"){
    reportsController?.addAllRestaurantReports(_reports);   
      }else{
      
    reportsController?.addARestaurantsReports(_reports); 
      }

       
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


void ResetState(){
 ApiCallDone = false;
current_page = 1;
 CompleteAPI = false;
setState(() {});
}

void filterHandler(String selectedDate, String fromDate, String toDate){
  ResetState();
  reportsController.addAllRestaurantReports([]);

String val = '';
if(selectedDate != ""){
 val = "&selected_date=${selectedDate}";
}
if(fromDate != "" && toDate != ""){
 val = "&from_date=${fromDate}&to_date=${toDate}";

}

filterCondition = val;
setState(() {});
getReportsHandler("init", val);
}


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: (){
            FilterBottomSheet(context, filterHandler);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
             Icon(Icons.filter_alt_outlined, size: ScreenUtil().setSp(24), color: AppColors.blackcolor,)
            , Text("filter", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(17)),)
               ,  SizedBox(width: 10,),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async{
              ResetState();
             
              await getReportsHandler("init", "");
             
            },
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
                    physics: const AlwaysScrollableScrollPhysics(),
                itemCount: reportsController?.restaurantsReports?.length ?? 0,
                    itemBuilder: (BuildContext context, int index){
                      final reports = reportsController?.restaurantsReports;
                     return Container(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Column(
                        children: [
                             Container(
                              width: MediaQuery.of(context).size.width * 0.70,
                              child: Text("${reports?[index]?.restaurantName ?? ''}", overflow: TextOverflow.ellipsis,style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(13)),)),
                            //  Container(
                            //   width: MediaQuery.of(context).size.width * 0.70,
                            //   child: Text("${reports[index]?.restaurantName ?? ''}", overflow: TextOverflow.ellipsis,style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(11)),)),
                           
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                         decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primaryColor),
                      child: Text("${reports?[index]?.count ?? 0}", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(13)),),
                      )
                  
                      
                      ]),
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
                         SizedBox(height: MediaQuery.of(context).size.height * 0.80,)
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}