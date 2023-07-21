import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/OrderModel.dart';
import 'package:admin/screen/RestaurantOrdersScreen/ViewOrdersScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final OrderModel? order;
  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    double width =  MediaQuery.of(context).size.width;
    
    var parsedDate = DateTime.parse(order?.orderCreated ?? '');
 String formatted = "";
 
  if(parsedDate != ""){
    final DateFormat formatter = DateFormat('MMM dd,yyyy hh:mm a');
    formatted =  parsedDate != "" ? formatter.format(parsedDate as DateTime) : '';

  }  
                        return InkWell(
                          onTap: (){
                                 Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => 
                       ViewOrderScreen(orderDetail: order!)),
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
                                    Text("Order Id: ${order?.orderId ?? ''}",style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.w500)),
                                    SizedBox(height: 5,),
                                    Text("${formatted ?? ''}",style: TextStyle(color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(11.0), fontWeight: FontWeight.w400)),
                                 
                                  ],
                                )
                             
                                ,Text("RS ${order?.grandTotal ?? ''}",style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.bold))
                             
                              ],
                            ),
                          ),
                        );
  }
}



