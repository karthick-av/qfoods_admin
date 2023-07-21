

import 'dart:convert';

import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/GroceryCouponModel.dart';
import 'package:admin/screen/CouponsScreen/CouponScreen.dart';
import 'package:admin/screen/CouponsScreen/ViewGroceryCouponScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
class GroceryCouponsScreen extends StatefulWidget {
  const GroceryCouponsScreen({super.key});

  @override
  State<GroceryCouponsScreen> createState() => _GroceryCouponsScreenState();
}

class _GroceryCouponsScreenState extends State<GroceryCouponsScreen> {
 
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
      final list = Provider.of<CouponProvider>(context, listen: false);

   if((list?.grocery?.length ?? 0) == 0 && list.apiGroCalled == false){
      getCouponHandler("init", "");
  
   }
  });
     scrollController.addListener(() { 
      //listener 
    
      // if(scrollController.offset.toInt() > ScreenUtil().setHeight(32.0).toInt()){
        
        
      // }
      print(ApiCallDone);
        if(scrollController.position.maxScrollExtent == scrollController.offset){
       if(!ApiCallDone){
       getCouponHandler("bottom",filterCondition);
  
        
       }
    }
  
    });
    
 
  
}

void dispose(){
scrollController.dispose();
  super.dispose();
}

Future<void> getCouponHandler(String type, String filter)async {
  if(CompleteAPI) return;
   final list = Provider.of<CouponProvider>(context, listen: false);


  List<GroceryCouponModel> _list= [];

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
       String url = "${ApiServices.coupon}?type=2&page=${current_page}&per_page=${per_page}&${filter}";
     print(url);
    var response = await http.get(Uri.parse(url));
list.addGroCalled();
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
            _list.add(GroceryCouponModel.fromJson(json));
         
       }

       setState(() {
    current_page = current_page + 1;
    });
      if(type == "init"){
      list.addAllGrocery(_list);   
      }else{
       list.addGrocery(_list);   
     
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
  final list = Provider.of<CouponProvider>(context, listen: false);
 ResetState();
  list.addAllGrocery([]);

String val = '';
if(selectedDate != ""){
 val = "&selected_date=${selectedDate}";
}
if(fromDate != "" && toDate != ""){
 val = "&from_date=${fromDate}&to_date=${toDate}";

}
filterCondition = val;
setState(() {});
getCouponHandler("init", val);
}



  @override
  Widget build(BuildContext context) {
     final list = Provider.of<CouponProvider>(context, listen: true);

    return Scaffold(
      body: RefreshIndicator(
             onRefresh: () async{
              ResetState();
                await getCouponHandler("init", "");
               
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
                await getCouponHandler("init", "search=${val}");
              
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
                          itemCount: list?.grocery?.length ?? 0,
                          itemBuilder: (BuildContext context, int index){
                            final data = list?.grocery;
                           return InkWell(
                            onTap: (){
                               Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => 
                        ViewGroceryCouponScreen(coupon: data![index],)),
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
                                          
                                             
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                     
                                      Text(data?[index].couponCode ?? '', style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w400),),
                                     Text("RS ${data?[index].amount ?? ''}", style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w400),)
                                   
                                    
                                   
                                    ],
                                  ),

                                    Column(
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: data?[index]?.status == "available" ? Colors.green : (data?[index]?.status == "expired" ? AppColors.primaryColor : AppColors.greycolor)
                                                  ),
                                                  child: Text("${data?[index]?.status ?? ""}",
                                                  style: TextStyle(color: AppColors.whitecolor,fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(8)),
                                                  ),
                                                ),
                                      
                                        Container(
                                            padding: const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: AppColors.primaryColor
                                                  ),
                                                  child: Text("${data?[index]?.appliedCount ?? 0}",
                                                  style: TextStyle(color: AppColors.whitecolor,fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(11)),
                                                  ),
                                                ),
                                      ],
                                    ),
                                ],
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