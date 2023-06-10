import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/restaurantModel.dart';
import 'package:admin/screen/DishesScreen/DishesScreen.dart';
import 'package:admin/screen/EditRestaurantScreen/EditRestaurantScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantCard extends StatelessWidget {
  final RestaurantModel RestaurantsModel;
  const RestaurantCard({super.key, required this.RestaurantsModel});


  @override
  Widget build(BuildContext context) {
     double itemheight = ScreenUtil().setHeight(100);

double itemWidth = MediaQuery.of(context).size.width * 0.90;


    return  InkWell(
                    onTap: (){

                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10.0),
                      height: itemheight,
                      width: itemWidth,
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
                      children: [
                        Container(
                          width: itemWidth * 0.80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: itemheight,
                                width: itemWidth * 0.32,
                               child: ClipRRect(
                           borderRadius: BorderRadius.circular(10.0),
                            child: 
                            Image.network(RestaurantsModel!.image!.toString() ?? "", fit: BoxFit.fitWidth,width: itemWidth/2.5 ),
                               )),
                                          
                               Padding(padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                               child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  
                                Container(
                                  width: itemWidth * 0.58,
                                  child:   Text(RestaurantsModel!.restaurantName!.toString() ?? "", maxLines: 2, overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), color: AppColors.blackcolor, fontWeight: FontWeight.bold),)
                                          ,
                                ),
                                 SizedBox(height: 2.0,),
                                Row(
                                  children: [
                                       Icon(Icons.stars, color: AppColors.primaryColor,size: ScreenUtil().setSp(14.0),),
                                     SizedBox(width: 2.0,),
                                       Text("4.7", style: TextStyle(fontFamily: FONT_FAMILY, color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(13.0)),)
                                  ],
                                 ),
                                 SizedBox(height: 2.0,),
                                 Container(
                                  width: itemWidth * 0.50,
                                  child:   Text(RestaurantsModel!.shortDescription!.toString() ?? "", maxLines: 2, overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(13.0), color: AppColors.greycolor, fontWeight: FontWeight.normal),)
                                          ,
                                ),
                                ],
                               ),
                               
                               )
                            ],
                          ),
                        ),

                        Container(
                             width: itemWidth * 0.20,
                       
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: (){
                                     Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => 
                         EditRestaurantScreen(restaurant: RestaurantsModel)),
                        );
                                },
                                
                                child: Container(
                                    decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: AppColors.primaryColor),
                                              boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 20,
                            color: const Color(0xFFB0CCE1).withOpacity(0.29),
                          ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  child: Text("Edit", style: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12)),),
                                ),
                              ),
                              SizedBox(height: 10,),
                              InkWell(

                                onTap: (){
                                   Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => 
                         DishesScreen(restaurant: RestaurantsModel)),
                        );
                                },
                                
                                child: Container(
                                    decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: AppColors.primaryColor),
                                              boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 20,
                            color: const Color(0xFFB0CCE1).withOpacity(0.29),
                          ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  child: Text("Menus", style: TextStyle(color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12)),),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    ),
                  );
 
  }
}