import 'package:admin/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomSnackBar{

  void MaximumQuantitySnackBar(){
    Get.snackbar("", 
    "Sorry you can't  add more  of this item",
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppColors.blackcolor,
    colorText: AppColors.whitecolor,
    titleText: SizedBox(height: 0,),
    margin:  EdgeInsets.only(bottom: ScreenUtil().setHeight(20.0)),
    maxWidth: ScreenUtil().setWidth(330)
    );
  }

  void ErrorSnackBar(){
    Get.snackbar("", 
    "Please..Try Again Later !!",
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppColors.blackcolor,
    colorText: AppColors.whitecolor,
    titleText: SizedBox(height: 0,),
    margin:  EdgeInsets.only(bottom: ScreenUtil().setHeight(20.0)),
    maxWidth: ScreenUtil().setWidth(330)
    );
  }

  void ErrorMsgSnackBar(String msg){
    Get.snackbar("", 
    msg,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: AppColors.blackcolor,
    colorText: AppColors.whitecolor,
    titleText: SizedBox(height: 0,),
    margin:  EdgeInsets.only(bottom: ScreenUtil().setHeight(20.0)),
    maxWidth: ScreenUtil().setWidth(330)
    );
  }

}