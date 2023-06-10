import 'dart:convert';

import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/GroceryProductModel.dart';
import 'package:admin/screen/EditProductScreen/GroceryVariantItemForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';



class GroceryVariantItemCard extends StatelessWidget {
  final Items? item;
  final int? vid;
  final int? iid;
  final Function? toggleItemStatus;
  final Function? deleteVariantItemHandler;
  final int? grocery_id;
  final VariantItems variant;
  final void Function(GroceryProductModel data)? ModifyProduct;
    GroceryVariantItemCard({super.key,required this.item, required this.vid, required this.iid, required this.toggleItemStatus, required this.deleteVariantItemHandler, required this.ModifyProduct, required this.grocery_id, required this.variant});

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
                                    Text("${item?.name ?? ''}",
                                maxLines: 2,style: TextStyle(fontFamily: FONT_FAMILY, overflow: TextOverflow.ellipsis,fontWeight: FontWeight.w600, color: AppColors.blackcolor,fontSize: ScreenUtil().setSp(12.0)),
                                ),
                                SizedBox(height: 5.0,),
                                  Text(
                                  "Rs ${item?.price ?? ''}",
                                maxLines: 2,style: TextStyle(fontFamily: FONT_FAMILY, overflow: TextOverflow.ellipsis,fontWeight: FontWeight.normal, color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(14.0)),
                                ),
                                 SizedBox(height: 5.0,),
                                 Text("${item?.description ?? ''}",
                                maxLines: 2,style: TextStyle(fontFamily: FONT_FAMILY, overflow: TextOverflow.ellipsis,fontWeight: FontWeight.normal, color: AppColors.pricecolor, fontSize: ScreenUtil().setSp(12.0)),
                                ),
                                  ],
                                ),
                              
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Switch(value: item?.status == 1 ? true : false,
                                  onChanged: (value){
                                  toggleItemStatus!(vid, iid);
                                  }, 
                                  
                                     activeColor: AppColors.primaryColor,  
                  activeTrackColor: Color(0xFFFDD4D7),  
                  inactiveThumbColor: AppColors.greyBlackcolor,  
                  inactiveTrackColor: AppColors.lightgreycolor,  
              
                                  ),

                                 
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                                       VariantItemEditForm(context,variant, grocery_id ??0, item!, ModifyProduct!);
                                
                                      //  VariantItemEditForm(context, dish_id!,dish!, restaurantId, modifyDish);
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
           deleteVariantItemHandler!(item?.id);
         //  deleteVariant(dish?.variantItemId);
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
                              )
                              ]
                            )
                          );
 
  }
}