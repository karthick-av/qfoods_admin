import 'dart:convert';

import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/dishesModel.dart';
import 'package:admin/screen/EditDishScreen/VariantItemForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';



class VariantDishCard extends StatelessWidget {
  final VariantItems? dish;
  final int? dish_id;
  final int variant_index;
  final int item_index;
  final int restaurantId;
  Function toggleVisible;
  Function modifyDish;
  Function deleteVariant;
   VariantDishCard({super.key,required this.dish_id,required this.dish,required this.deleteVariant,required this.restaurantId,required this.variant_index, required this.item_index,required this.toggleVisible, required this.modifyDish});

  @override
  Widget build(BuildContext context) {
        return Container(
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(width: 0.5, color: AppColors.lightgreycolor))
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${dish?.name ?? ''}",
                                maxLines: 2,style: TextStyle(fontFamily: FONT_FAMILY, overflow: TextOverflow.ellipsis,fontWeight: FontWeight.w600, color: AppColors.blackcolor,fontSize: ScreenUtil().setSp(12.0)),
                                ),
                                SizedBox(height: 5.0,),
                                  Text(
                                  "Rs ${dish?.price ?? ''}",
                                maxLines: 2,style: TextStyle(fontFamily: FONT_FAMILY, overflow: TextOverflow.ellipsis,fontWeight: FontWeight.normal, color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(14.0)),
                                ),
                                 SizedBox(height: 5.0,),
                                 Text("${dish?.description ?? ''}",
                                maxLines: 2,style: TextStyle(fontFamily: FONT_FAMILY, overflow: TextOverflow.ellipsis,fontWeight: FontWeight.normal, color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(12.0)),
                                ),
                                  ],
                                ),
                              
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Switch(value: dish?.status == 1 ? true : false,
                                  onChanged: (value){
      toggleVisible(variant_index, item_index);
                                  }, 
                                  
                                     activeColor: AppColors.primaryColor,  
                  activeTrackColor: Color(0xFFFDD4D7),  
                  inactiveThumbColor: AppColors.greyBlackcolor,  
                  inactiveTrackColor: AppColors.lightgreycolor,  
              
                                  ),

                                 dish?.image  == ""
                                 ?
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                        VariantItemEditForm(context, dish_id!,dish!, restaurantId, modifyDish);
                                        },
                                        child: Container(
                                      //  margin:  EdgeInsets.only(right: ScreenUtil().setHeight(14.0)),
                                        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0 ),
                                        decoration: BoxDecoration(
                                          color: AppColors.whitecolor,
                                          borderRadius: BorderRadius.circular(5.0),
                                          border: Border.all(width: 1, color: AppColors.primaryColor),
                                             boxShadow: [
                                                            BoxShadow(
                                                              offset: Offset(0, 4),
                                                              blurRadius: 20,
                                                              color: const Color(0xFFB0CCE1).withOpacity(0.29),
                                                            ),
                                                          ],
                                        ),
                                        child: Text("Edit", style: TextStyle(letterSpacing: 1.0,color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(14.0)),),
                                      ),
                                      ),

                                       InkWell(
                                  onTap: (){
                                     showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
    title: Text("Confirmation"),
    content: Text("Are you sure want to delete this ?"),
    actions: [
       TextButton(
    child: Text("yes"),
    onPressed:  () {
           Navigator.of(context).pop();
           deleteVariant(dish?.variantItemId);
    },
  ),
       TextButton(
    child: Text("no"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  ),
    ],
  );
    },
                                   );
                                  },
                                  child: Icon(Icons.delete,color: AppColors.primaryColor, size: ScreenUtil().setSp(22),),
                                )
                                    ],
                                  )
                                  : Container(
                                  margin: const EdgeInsets.only(bottom: 10.0),
                                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                  child: Stack(
                                    alignment: new Alignment(0.0, 1.5),
                                    children: [
                                      ClipRRect(
                                          borderRadius: BorderRadius.circular(10.0),
                                          child:  (dish?.status == 0)
                               
                                          ? ColorFiltered(child: Image.network("${dish?.image ?? ''}", fit: BoxFit.cover,height: ScreenUtil().setHeight(80.0), width: ScreenUtil().setWidth(100.0),),
                                            colorFilter: ColorFilter.mode(
    Colors.grey,
    BlendMode.saturation,
  ),
                                          )
                                          : Image.network("${dish?.image ?? ''}", fit: BoxFit.cover,height: ScreenUtil().setHeight(80.0), width: ScreenUtil().setWidth(100.0),)),
                                   Row(
                                     children: [
                                       (
                                        InkWell(
                                           onTap: (){
                                          //  EditDishModal(context);
                                           VariantItemEditForm(context, dish_id!, dish!, restaurantId, modifyDish);
                                       
                                           
                                  },
                                          child:  Container(
                                            
                                           padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0 ),
                                                                         decoration: BoxDecoration(
                                                                            color: AppColors.whitecolor,
                                          borderRadius: BorderRadius.circular(5.0),
                                          border: Border.all(width: 1, color: AppColors.primaryColor),
                                             boxShadow: [
                                                                BoxShadow(
                                                                  offset: Offset(0, 4),
                                                                  blurRadius: 20,
                                                                  color: const Color(0xFFB0CCE1).withOpacity(0.29),
                                                                ),
                                                              ],
                                          ),
                                            child: Text("Edit", style: TextStyle(letterSpacing: 1.0,color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(14.0)),)),
                                        )
                                  ),

                                   InkWell(
                                  onTap: (){
                                     showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
    title: Text("Confirmation"),
    content: Text("Are you sure want to delete this ?"),
    actions: [
       TextButton(
    child: Text("yes"),
    onPressed:  () {
           Navigator.of(context).pop();
           deleteVariant(dish?.variantItemId);
    },
  ),
       TextButton(
    child: Text("no"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  ),
    ],
  );
    },
                                   );
                                  },
                                  child: Icon(Icons.delete,color: AppColors.primaryColor, size: ScreenUtil().setSp(22),),
                                )
                                     ],
                                   )
                                    ],
                                  ),
                                )
                                ],
                              )
                              ]
                            )
                          );
 
  }
}