import 'dart:convert';

import 'package:admin/Provider/OrdersProvider.dart';
import 'package:admin/components/FilterBottomSheet.dart';
import 'package:admin/components/OrderCard.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/OrderModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;


class OrdersOntheWayScreen extends StatefulWidget {
  const OrdersOntheWayScreen({super.key});

  @override
  State<OrdersOntheWayScreen> createState() => _OrdersOntheWayScreenState();
}

class _OrdersOntheWayScreenState extends State<OrdersOntheWayScreen> {
 
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
     final detailProvider = Provider.of<OrdersProvider>(context, listen: false);
 
   if((detailProvider?.ontheway?.length ?? 0) == 0 && detailProvider?.lontheway == false){
      getDetailHandler("init", "");
  
   }
  });
     scrollController.addListener(() { 
      //listener 
    
      // if(scrollController.offset.toInt() > ScreenUtil().setHeight(32.0).toInt()){
        
        
      // }
        if(scrollController.position.maxScrollExtent == scrollController.offset){
       if(!ApiCallDone){
       getDetailHandler("bottom",filterCondition);
  
        
       }
    }
  
    });
    
 
  
}

void dispose(){
scrollController.dispose();
  super.dispose();
}

Future<void> getDetailHandler(String type, String filter)async {
  if(CompleteAPI) return;

 final orderProvider = Provider.of<OrdersProvider>(context, listen: false);
 
  List<OrderModel> _list= [];

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
       String url = "${ApiServices.get_orders}?status=3&page=${current_page}&per_page=${per_page}&${filter}";
   print(url);
    var response = await http.get(Uri.parse(url));
    orderProvider.updateOntheWay();
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
     
      _list.add(OrderModel.fromJson(json));
       }

       setState(() {
    current_page = current_page + 1;
    });
      if(type == "init"){
      orderProvider.addAllOntheway(_list);   
      }else{
       orderProvider.addOntheway(_list);   
     
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
 
 filterCondition = "";
setState(() {});
}

void filterHandler(String selectedDate, String fromDate, String toDate){
 final detailProvider = Provider.of<OrdersProvider>(context, listen: false);
 
  ResetState();
  detailProvider.addAllOntheway([]);

String val = '';
if(selectedDate != ""){
 val = "&selected_date=${selectedDate}";
}
if(fromDate != "" && toDate != ""){
 val = "&from_date=${fromDate}&to_date=${toDate}";

}
filterCondition = val;
setState(() {});
getDetailHandler("init", val);
}


  @override
  Widget build(BuildContext context) {
   double height = MediaQuery.of(context).size.height;
        double width = MediaQuery.of(context).size.width;
  final list = Provider.of<OrdersProvider>(context, listen: true).ontheway;
 
    return Scaffold(
      backgroundColor: AppColors.whitecolor,
      body: SafeArea(
        child:  RefreshIndicator(
           color: AppColors.primaryColor,
                onRefresh: ()async{
                  ResetState();
             
                  await getDetailHandler("init", "");
                
          },
          child:  Column(
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
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                          if(loading)
                                     LinearProgressIndicator(
                                      
                                      backgroundColor: AppColors.whitecolor,
                                       valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),  
                          minHeight: 10,
                                    ),
                     Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    width: double.infinity,
                                    height: 1,
                                    color: Color(0XFFe9e9eb),
                                   ),
                      
                    ListView.builder(
                     physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: list?.length ?? 0,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemBuilder:(context, index) {
                       
                      return OrderCard(order: list[index],);
                      
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
                               SizedBox(height: MediaQuery.of(context).size.height )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
     }
}


