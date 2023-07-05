import 'dart:convert';

import 'package:admin/components/FilterBottomSheet.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/controller/OrdersController.dart';
import 'package:admin/model/GroceryOrderModel.dart';
import 'package:admin/navigation/DrawerNavigation.dart';
import 'package:admin/screen/GroceryOrdersScreen/GroceryOrdersScreen.dart';
import 'package:admin/screen/GroceryOrdersScreen/ViewGroceryOrderScreen.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class GroceryOrdersCancelledScreen extends StatefulWidget {
  const GroceryOrdersCancelledScreen({super.key});

  @override
  State<GroceryOrdersCancelledScreen> createState() => _GroceryOrdersCancelledScreenState();
}

class _GroceryOrdersCancelledScreenState extends State<GroceryOrdersCancelledScreen> {

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
    final orders = Provider.of<GroceryOrdersProvider>(context, listen: false);
   if((orders?.cancelled?.length ?? 0) == 0 && orders?.lcancelled == false){
      getOrdersHandler("init", "");
  
   }
  });
     scrollController.addListener(() { 
      //listener 
    
      // if(scrollController.offset.toInt() > ScreenUtil().setHeight(32.0).toInt()){
        
        
      // }
        if(scrollController.position.maxScrollExtent == scrollController.offset){
       if(!ApiCallDone){
       getOrdersHandler("bottom",filterCondition);
  
        
       }
    }
  
    });
    
 
  
}

void dispose(){
scrollController.dispose();
  super.dispose();
}

Future<void> getOrdersHandler(String type, String filter)async {
  if(CompleteAPI) return;
  
    final orders = Provider.of<GroceryOrdersProvider>(context, listen: false);

  List<GroceryOrderModel> __orders= [];

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
       String url = "${ApiServices.grocery_get_orders}?isCancelled=true&page=${current_page}&per_page=${per_page}&${filter}";
   print(url);
    var response = await http.get(Uri.parse(url));
orders?.updatecancelled();
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
     
      __orders.add(GroceryOrderModel.fromJson(json));
       }

       setState(() {
    current_page = current_page + 1;
    });

      if(type == "init"){
      orders.addAllCancelled(__orders);   
      }else{
       orders.addCanelled(__orders);   
     
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
    final orders = Provider.of<GroceryOrdersProvider>(context, listen: false);
  ResetState();
  orders.addAllCancelled([]);

String val = '';
if(selectedDate != ""){
 val = "&selected_date=${selectedDate}";
}
if(fromDate != "" && toDate != ""){
 val = "&from_date=${fromDate}&to_date=${toDate}";

}
filterCondition = val;
setState(() {});
getOrdersHandler("init", val);
}


  @override
  Widget build(BuildContext context) {
     double height = MediaQuery.of(context).size.height;
        double width = MediaQuery.of(context).size.width;
    final orders = Provider.of<GroceryOrdersProvider>(context, listen: true).cancelled;
  
    return Scaffold(
      backgroundColor: AppColors.whitecolor,
      
      body: SafeArea(
        child:  RefreshIndicator(
           color: AppColors.primaryColor,
                onRefresh: ()async{
                  ResetState();
             
                  await getOrdersHandler("init", "");
                
          },
          child:  SingleChildScrollView(
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
                itemCount: orders?.length ?? 0,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemBuilder:(context, index) {
                  var parsedDate = DateTime.parse(orders?[index]?.orderCreated ?? '');
        
          final DateFormat formatter = DateFormat('MMM dd,yyyy hh:mm a');
          final String formatted = formatter.format(parsedDate);
          
                return InkWell(
                  onTap: (){
                   Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => 
               ViewGroceryOrderScreen(orderDetail: orders![index],)),
              );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                     padding: const EdgeInsets.all(14.0),
                     
                          width: width * 0.90,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Order Id: ${orders?[index]?.orderId ?? ''}",style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.w500)),
                            SizedBox(height: 5,),
                            Text("${formatted ?? ''}",style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(11.0), fontWeight: FontWeight.w400)),
                         
                          ],
                        )
                     
                        ,Text("RS ${orders?[index]?.grandTotal ?? ''}",style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.bold))
                     
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
                         SizedBox(height: MediaQuery.of(context).size.height )
              ],
            ),
          ),
        ),
      ),
    );
  }
}




