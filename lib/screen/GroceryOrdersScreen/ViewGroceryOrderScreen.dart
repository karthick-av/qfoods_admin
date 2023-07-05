import 'dart:convert';

import 'package:admin/components/CustomAlertDialog.dart';
import 'package:admin/constants/CustomDialog.dart';
import 'package:admin/constants/CustomSnackBar.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/GroceryOrderModel.dart';
import 'package:admin/screen/GroceryOrdersScreen/GroceryOrdersScreen.dart';
import 'package:admin/screen/RestaurantOrdersScreen/TimeLine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewGroceryOrderScreen extends StatefulWidget {
final GroceryOrderModel? orderDetail;
  const ViewGroceryOrderScreen({super.key, required this.orderDetail});

  @override
  State<ViewGroceryOrderScreen> createState() => _ViewGroceryOrderScreenState();
}

class _ViewGroceryOrderScreenState extends State<ViewGroceryOrderScreen> {
  GroceryOrderModel? order;
  
   bool? loading = false;
  bool bottombtnLoading = false;
  bool statusloading = false;
  
  @override
  void initState(){
    order = widget.orderDetail;
super.initState();
  }

Future<void> getOrderHandler() async{
 // final orderProvider = Provider.of<OrdersProvider>(context, listen: false);
   setState(() {
    loading = true;
  });
  try{
 var response = await http.get(Uri.parse("${ApiServices.grocery_get_order}${order?.orderId}"));
     setState(() {
    loading = false;
  });
    if(response.statusCode == 200){
       var response_body = json.decode(response.body);
       GroceryOrderModel __order = GroceryOrderModel.fromJson(response_body);

   //      orderProvider.GroceryOrderStatusChanger(__order);
       order = __order;
       setState(() {});
    }
  }catch(e){
 
  }
}


Future<void> AcceptOrderAPIHandler() async{
   final orderProvider = Provider.of<GroceryOrdersProvider>(context, listen: false);
 
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bottombtnLoading = true;
  setState(() {});
  final admin_id = await prefs.getInt("admin_id") ?? null;
  if(admin_id == null) return;
 try{
   dynamic data = {
    "vendor_id": admin_id?.toString(),
    "order_id": order?.orderId?.toString()
  };

 var response = await http.post(Uri.parse("${ApiServices.grocery_accept_order}"),body: data);
   bottombtnLoading = false;
  setState(() {});
  if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      if(responseJson?["message"] == "Already Taken"){
         CustomSnackBar().ErrorMsgSnackBar("Already Taken");
      }
     GroceryOrderModel __order = GroceryOrderModel.fromJson(responseJson);
     if(__order?.orderId != null){
      order = __order;
      setState(() { });
     orderProvider.UpdateOrder(__order);
         CustomSnackBar().ErrorMsgSnackBar("Order Taken By you");
     
     }    
  }else{
     bottombtnLoading = false;
  setState(() {});
  CustomSnackBar().ErrorSnackBar();
  }
 
 }
 catch(e){
print(e);
     bottombtnLoading = false;
  setState(() {});
  CustomSnackBar().ErrorSnackBar();
 } 
}




Future<void> CancelOrderHandler(String reason) async{
 
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final admin_id = await prefs.getInt("admin_id") ?? null;
  if(admin_id == null) return;
  statusloading = true;
 // final orderProvider = Provider.of<OrdersProvider>(context, listen: false);
  setState(() {});
 try{
   dynamic data = {
   "order_id": order?.orderId?.toString(), 
    "cancellor_id": admin_id?.toString(),
     "cancellor_type": "Delivery", 
     "reason": reason
  };

 var response = await http.put(Uri.parse("${ApiServices.grocery_cancel_order}"),body: data);
   statusloading = false;
  setState(() {});
  if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      
     GroceryOrderModel __order = GroceryOrderModel.fromJson(responseJson);
     if(__order?.orderId != null){
         CustomSnackBar().ErrorMsgSnackBar("Order Cancelled");
   //      orderProvider.GroceryOrderStatusChanger(__order);
      order = __order;
     
      setState(() { });
     
     }    
  }else{
     statusloading = false;
  setState(() {});
  CustomSnackBar().ErrorSnackBar();
  }
 
 }
 catch(e){
print(e);
     bottombtnLoading = false;
  setState(() {});
  CustomSnackBar().ErrorSnackBar();
 } 
}

void AcceptOrder(){
  showDialog(context: context, builder: (BuildContext context) => CustomAlertDialog(title: "Confirm", message: "Are you sure take this order?", ok: (){
    Navigator.of(context).pop();
    AcceptOrderAPIHandler();
  }));
}

void CancelOrder(){
  showDialog(context: context, builder: (BuildContext context) => CustomAlertDialog(title: "Confirm", message: "Are you sure Cancel this order?", ok: (){

    Navigator.of(context).pop();
  CancelDialog(context, CancelOrderHandler);
  }));
}

  @override
  Widget build(BuildContext context) {
      double width = MediaQuery.of(context).size.width;
  String current_status = order?.orderStatus?.firstWhere((element) => element?.statusId == order?.status)?.status ?? '';
  
  double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.whitecolor,
        bottomNavigationBar:
      (order?.status == 1 && order?.deliveryPersonId == null && order?.isCancelled == 0 && order?.isDelivered == 0)
      ?
      (
        (bottombtnLoading)
        ?
           Container(
        width: double.infinity,
        height: height * 0.09,
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
        alignment: Alignment.center,
        child: SizedBox(
          height: ScreenUtil().setHeight(20),
          width: ScreenUtil().setWidth(20),
          child: CircularProgressIndicator())
           )
        :
         Container(
        width: double.infinity,
        height: height * 0.09,
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
        alignment: Alignment.center,
        child: Container(
          width: width * 0.90,
          padding:  const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            InkWell(
              onTap: AcceptOrder,
              child: Container(
                height: height * 0.06,
                padding: const EdgeInsets.all(10),
                width: width * 0.38,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(10)),
                      child: Text("Accept", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12)),),
              ),
            ),
            InkWell(
              onTap: CancelOrder,
              child: Container(
                height: height * 0.06,
                padding: const EdgeInsets.all(10),
                width: width * 0.38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryColor),
                  color: AppColors.whitecolor, borderRadius: BorderRadius.circular(10)),
                      child: Text("Cancel", style: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12)),),
              ),
            )
          ],),
        )
      )
      ): SizedBox(),
    
      body: SafeArea(
        child: Column(
          children: [
             Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                 child: Row(
                   children: [
                     InkWell(
                      child: Icon(Icons.arrow_back, color: AppColors.blackcolor, size: ScreenUtil().setSp(18),),
                      
                     ),
                     SizedBox(width: 10,),
                     Text("View Order", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(18), fontWeight: FontWeight.w500),)
                   ],
                 ),
               ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primaryColor,
                onRefresh: () async {
            await getOrderHandler();
        return ;
          },

                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8),
                  child:  Column(
                      children: [
                        
                          Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      width: double.infinity,
                                      height: 1,
                                      color: Color(0XFFe9e9eb),
                                     ),
                      
                      SizedBox(height: 8,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                             Column(
                              children: [
                                   Text("Order Id: ${order?.orderId ?? ''}", style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15)),)
                               
                              ],
                             ),
                             Text("Total Rs ${order?.grandTotal ?? '0'}", style: TextStyle(color: AppColors.blackcolor, fontWeight: FontWeight.bold,fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15)),)
                             ],
                            ),
                          )  ,

                           if(order?.isCancelled  == 1)
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.all(14.0),
                                          width: width * 0.90,
                                           decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 4),
                                      blurRadius: 20,
                                      color: const Color(0xFFB0CCE1).withOpacity(0.29),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Cancelled Reason:-", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),)
                                    ,
                                    SizedBox(height: 5,),
                                     Text("${order?.cancelDetail?.cancelledReason ?? ''}", 
                                     style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(13), fontWeight: FontWeight.normal),)
                                 
                                  ],
                                ),
                      ),


                      if(order?.deliveryPersonId != null && order?.deliveryPersonDetail?.phoneNumber != null)
                              Container(
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
                                 child: Theme(
                             data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                             child: ExpansionTile(
                                  tilePadding: EdgeInsets.all(0),
                                   collapsedTextColor: AppColors.blackcolor,
                                   collapsedIconColor: AppColors.blackcolor,
                                   textColor: AppColors.blackcolor,
                                   iconColor: AppColors.blackcolor,
                             
                                   initiallyExpanded: true,
                                   title:      Container(
                                  
                         width: width * 0.80,
                    child: Text("Delivery Person", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.bold))),
                     children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                      Container(
             width: ScreenUtil().setWidth(50),
             height: ScreenUtil().setHeight(50),
             decoration: BoxDecoration(
               color: const Color(0xff7c94b6),
               image: DecorationImage(
                 image: NetworkImage('${order?.deliveryPersonDetail?.image ?? ''}'),
                 fit: BoxFit.cover,
               ),
               borderRadius: BorderRadius.all( Radius.circular(50.0)),
              
             ),
           ),

           Container(
            margin: const EdgeInsets.only(left: 10),
             child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${order?.deliveryPersonDetail?.name ?? ''}", style: TextStyle(color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(14), fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500),),
               SizedBox(height: 3,),
                Text("${order?.deliveryPersonDetail?.phoneNumber ?? ''}", style: TextStyle(color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(14), fontFamily: FONT_FAMILY),),
              ],
             ),
           )

                          ],
                        ),
                      )
                     ],                       
                             )
                                 ),                   
                              ),
                              SizedBox(
                                height: 9,
                              ),
                      
                        
                              Container(
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
                                 child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Delievery Address :-", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.bold),),
                      SizedBox(height: 3,),
                               Theme(
                             data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                             child: ExpansionTile(
                                tilePadding: EdgeInsets.all(0),
                                 collapsedTextColor: AppColors.blackcolor,
                                 collapsedIconColor: AppColors.blackcolor,
                                 textColor: AppColors.blackcolor,
                                 iconColor: AppColors.blackcolor,
                             
                                 initiallyExpanded: false,
                                 title:      Container(
                                
                         width: width * 0.80,
                    child: Text("${order?.address?.address1 != '' ? order?.address?.address1 : order?.address?.address2}", style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), fontWeight: FontWeight.w500),)),
                     children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                    width: width * 0.80,
                              child: Text("${order?.address?.address2 ?? ''}", style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), fontWeight: FontWeight.w500),))
                           , Container(
                            margin: const EdgeInsets.only(top: 5),
                                    width: width * 0.80,
                              child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Land Mark:-", style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), fontWeight: FontWeight.w500),),
                                  Container(
                                    width: width * 0.40,
                              
                                    child: Text("${order?.address?.landmark ?? ''}", 
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), fontWeight: FontWeight.w500),)),
                                ],
                              )),
                              Container(
                            margin: const EdgeInsets.only(top: 5),
                                    width: width * 0.80,
                              child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Alt phone Number:-", style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), fontWeight: FontWeight.w500),),
                                  Container(
                                    width: width * 0.40,
                              
                                    child: Text("${order?.address?.alternatePhoneNumber ?? ''}", 
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), fontWeight: FontWeight.w500),)),
                                ],
                              ))
                          
                          
                          ],
                        ),
                      )
                     ],                       
                             )
                               )
                                
                                 ]),                   
                              ),
                            

                            
                              SizedBox(height: 10,),
                         Container(
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
                          child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("Sub Total", style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.w500),),
                                                Text("Rs ${order?.subTotal ?? '0'}", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.bold),)
                                              
                                              ],
                                            ),
                                            
                                            SizedBox(height: ScreenUtil().setSp(20.0),),
                                             Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Delivery Charges", style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.w500),),
                                                    SizedBox(height: 4,),
                                                  //  if(_checkouttotal?.kms != null)
                                                    
                                                  ],
                                                ),
                                                Text("Rs ${order?.deliveryCharges ?? '0'}", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.bold),)
                                              
                                              ],
                                            ),
                                            SizedBox(height: ScreenUtil().setSp(20.0),),
                                             Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text("Grand Total", style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.w500),),
                                                Text("Rs ${order?.grandTotal ?? '0'}", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.bold),)
                                              
                                              ],
                                            )
                                          ],
                                        ),
                         )
                              
                                ,
                                 SizedBox(height: 10,),                 
                    
                                Container(
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
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    
                      Text("Order Items :-", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.bold),),
                      SizedBox(height: 3,),
                                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: order?.items?.length,
                    itemBuilder: ((context, index) {
                    return 
                     Container(
                        width: width * 0.90,
                        margin: const EdgeInsets.only(top: 5),
                         padding: const EdgeInsets.all(1),             
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: width * 0.60,
                                child:  Text("${order?.items?[index]?.productName ?? ''}  (X${order?.items?[index]?.quantity ?? ''})",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(14), fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 1),
                                width: width * 0.60,
                                child:  Text("${order?.items?[index]?.name ?? ''}",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(11), fontFamily: FONT_FAMILY),
                                ),
                                
                              ),
                              
                            ],
                          ),
                           Container(
                            alignment: Alignment.centerRight,
                            width: width * 0.20,
                            child:  Text("Rs ${order?.items?[index]?.total ?? ''}",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500,fontFamily: FONT_FAMILY),
                            ),
                          )
                      ],),
                    );
                                })),
                      ],
                    ),
                                ),

                                                         if(order?.isCancelled  == 0)
  Padding(
                           padding:  EdgeInsets.all(8.0),
                           child: GroceryTimeLine(order: order!),
                         ),
                      
                              SizedBox(
                                height: 5,
                              ),

                      

                              
                      ],
                    ),
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}