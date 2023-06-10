import 'package:admin/Provider/groceryProductsProvider.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/GroceryProductModel.dart';
import 'package:admin/screen/EditProductScreen/EditProductScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';




class GroceryCard extends StatelessWidget {
  final GroceryProductModel product;
  
  const GroceryCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {

    

    return Container(
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
          Container(height: (MediaQuery.of(context).size.height / 1.5) / 4, width: double.infinity, 
          child: Image.network(product?.image?.toString() ?? '',
          errorBuilder: ((context, error, stackTrace) {
            return Image.asset("assets/images/no-image.jpg");
          }),
          ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:10.0, top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product?.name?.toString() ?? '',textAlign: TextAlign.left, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(14.0)),),
                
                SizedBox(height: 15.0,),
                Text(product?.weight?.toString() ?? "", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.pricecolor.withOpacity(0.8), fontFamily: FONT_FAMILY, fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(12.0)),),
               SizedBox(height: 8.0,),
               
                if(product.combo == 1)
                Text(product?.comboDescription?.toString() ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.pricecolor.withOpacity(0.8), fontFamily: FONT_FAMILY, fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(12.0)),),
              

                             Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
                    Column(
                      children: [
                       
                        Text("Rs ${product?.price?.toString() ?? ''}",maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontWeight: FontWeight.w600,fontSize: ScreenUtil().setSp(12.0)),),
                      
                       if(product?.salePrice != 0 && product?.offers == "true")
                        Text("Rs ${product?.regularPrice?.toString() ?? ''}",maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(decoration: TextDecoration.lineThrough,color: AppColors.pricecolor, fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(12.0)),),
                       
                      ],
                    ),
                   
               InkWell(
                onTap: (){
                   Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => 
                         EditProductScreen(gproduct: product)),
                        );
                },
                 child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
                      margin: const EdgeInsets.only(right: 10.0),
                      child: Text("Edit", style: TextStyle(letterSpacing: 1.0,color: AppColors.primaryColor, fontFamily: FONT_FAMILY, fontWeight: FontWeight.w500,fontSize: ScreenUtil().setSp(14.0)),),
                           ),
               )
                             
               
             ],
               )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Switch(value: product?.status ==  1 ? true : false, onChanged: (value){
                
    final products = Provider.of<GroceryProductsProvider>(context, listen: false);
                  product?.status = product?.status == 1 ? 0 : 1;
                  products.updateProduct(product);
                   
                  },
                  
                     activeColor: AppColors.primaryColor,  
                        activeTrackColor: Color(0xFFFDD4D7),  
                        inactiveThumbColor: AppColors.greyBlackcolor,  
                        inactiveTrackColor: AppColors.lightgreycolor,  
                    
                  ),
               InkWell(
                    child: Icon(Icons.delete, size: ScreenUtil().setSp(19), color: AppColors.primaryColor,),
                   ),
            ],
          )
        ],
       ),
              );
  }
}
