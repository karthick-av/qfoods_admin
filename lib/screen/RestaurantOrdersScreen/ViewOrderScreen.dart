import 'dart:convert';

import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/OrderModel.dart';
import 'package:admin/screen/RestaurantOrdersScreen/TimeLine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;

class ViewOrderScreen extends StatefulWidget {
  final OrderModel orderDetail;
  const ViewOrderScreen({super.key, required this.orderDetail});

  @override
  State<ViewOrderScreen> createState() => _ViewOrderScreenState();
}

class _ViewOrderScreenState extends State<ViewOrderScreen> {
  OrderModel? order;
  bool? loading;
  
  @override
  void initState(){
    order = widget.orderDetail;
 super.initState();
  }
  @override
void dispose() {
 
  super.dispose();
}
  

Future<void> getOrderHandler() async{
   setState(() {
    loading = true;
  });
  try{
  print("fff");
 var response = await http.get(Uri.parse("${ApiServices.get_orders}${order?.orderId}"));
     setState(() {
    loading = false;
  });
    if(response.statusCode == 200){
       var response_body = json.decode(response.body);
      OrderModel __order = OrderModel.fromJson(response_body);
   
 if(__order?.orderId != null){
    
       order = __order;
       setState(() {});
       print(response_body);
     }
    }
  }catch(e){
 print(e);
  }
}

  @override
  Widget build(BuildContext context) {
      double width = MediaQuery.of(context).size.width;
  
    return Scaffold(
      backgroundColor: AppColors.whitecolor,
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
            return;
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

                          

                          if(order?.isCancelled == 0)
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: TimeLine(order: order,),
                         ),
                         SizedBox(
                                height: 5,
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
                    itemCount: order?.dishItems?.length,
                    itemBuilder: ((context, index) {
                    return 
                    (order?.dishItems?[index]?.variantItems?.length ?? 0) > 0
                    ?
                    Theme(
                             data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                             child: ExpansionTile(
                                tilePadding: EdgeInsets.all(0),
                                 collapsedTextColor: AppColors.blackcolor,
                                 collapsedIconColor: AppColors.blackcolor,
                                 textColor: AppColors.blackcolor,
                                 iconColor: AppColors.blackcolor,
                             
                                 initiallyExpanded: false,
                                 title: Container(
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
                                child:  Text("${order?.dishItems?[index]?.name ?? ''}  (X${order?.dishItems?[index]?.quantity ?? ''})",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(14), fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 1),
                                width: width * 0.60,
                                child:  Text("${order?.dishItems?[index]?.restaurantName ?? ''}",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(11), fontFamily: FONT_FAMILY),
                                ),
                              
                                
                                
                              ),
                                Container(
                                margin: const EdgeInsets.only(top: 1),
                                width: width * 0.60,
                                child:  Text("${order?.dishItems?[index]?.variantName ?? ''}",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(11), fontFamily: FONT_FAMILY),
                                ),
                              
                                
                                
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 1),
                                width: width * 0.60,
                                child:  Text("Rs ${order?.dishItems?[index]?.total ?? ''}",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(11), fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500),
                                ),
                              
                                
                                
                              ),
                              
                              
                            ],
                          ),
                          
                      ],),
                    ),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: order?.dishItems?[index]?.variantItems?.length ?? 0,
                        itemBuilder: ((context, i) {
                          return Row(
                            children: [
                              Container(
                        width: width * 0.80,
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Color(0XFFe9e9eb))
                          )
                        ),
                         padding: const EdgeInsets.all(2),             
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: width * 0.30,
                            child:  Text("${order?.dishItems?[index]?.variantItems?[i]?.name ?? ''}",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(12), fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500),
                            ),
                          ),
                        Container(
                            alignment: Alignment.centerRight,
                            width: width * 0.20,
                            child:  Text("Rs ${order?.dishItems?[index]?.variantItems?[i]?.price ?? ''}",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w500,fontFamily: FONT_FAMILY),
                            ),
                          )
                      ],),
                    )
                            ],
                          );
                        }),
                      )
                    ],
                             )
                    )
                              
                                 : Container(
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
                                child:  Text("${order?.dishItems?[index]?.name ?? ''}  (X${order?.dishItems?[index]?.quantity ?? ''})",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(14), fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 1),
                                width: width * 0.60,
                                child:  Text("${order?.dishItems?[index]?.restaurantName ?? ''}",
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
                            child:  Text("Rs ${order?.dishItems?[index]?.total ?? ''}",
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
                                )
                              
                              
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