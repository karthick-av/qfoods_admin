

import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

void FilterBottomSheet(BuildContext context, void Function(String selectedDate, String fromDate, String toDate) filterHandler){
   double height  = MediaQuery.of(context).size.height;
  double width  = MediaQuery.of(context).size.width;

  String selected_date = "";
  String from_date = "";
  String to_date = "";
  
Future<void> SelectedDateHandler(BuildContext context, StateSetter mystate) async{
 final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(picked);
  selected_date  = formatted;
  from_date = "";
  to_date = "";
  mystate((){});
    }
}

Future<void> RangeDateHandler(BuildContext context, String type, StateSetter mystate) async{
 final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String formatted = formatter.format(picked);
  selected_date  = "";
  if(type == "from"){
   from_date = formatted;
  }else{
    to_date = formatted;
  }
  mystate((){});
    }
}
 
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
     shape: RoundedRectangleBorder(
     borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20.0),
      topRight: Radius.circular(20.0)
     ),
  ),
    builder: (context) {
      return StatefulBuilder(
       builder: (BuildContext ctx, StateSetter mystate) {
                                 return Container(
            height: height * 0.50,
            width: double.infinity,
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                    SingleChildScrollView(
                  child: Column(
                    children: [
                   Padding(
                                               padding: const EdgeInsets.all(8.0),
                                               child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Filter", style: TextStyle(color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(18), fontFamily: FONT_FAMILY, fontWeight: FontWeight.bold),)
                                               
                                                  ,
                                                  InkWell(
                                                    onTap: (){
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.all(1),
                                                    child: Icon(Icons.close, color: AppColors.blackcolor, size: ScreenUtil().setSp(20),),
                                                      ),
                                                  ),
                                                  
                                                            
                                                  
                                                ],
                                               ),
                                             ),
              
                   InkWell(
                       onTap: (){
                          print("object");
                          SelectedDateHandler(context, mystate);
                        },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: width * 0.90,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Text("${selected_date == '' ? "Select Date" : selected_date}", style: TextStyle(fontFamily: FONT_FAMILY, fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(15)),),
                    ),
                   ),
                  SizedBox(height: 10,),
                 Container(
                  width: width * 0.90,
                  
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       InkWell(
                        onTap: (){
                          RangeDateHandler(context, "from", mystate);
                        },
                     
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: width * 0.40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Text("${from_date == '' ? "Select Date" : from_date}", style: TextStyle(fontFamily: FONT_FAMILY, fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(15)),),
                    ),
                   ),
                    InkWell(
                      onTap: (){
                        
                          RangeDateHandler(context, "to", mystate);
                      },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: width * 0.40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Text("${to_date == '' ? "Select Date" : to_date}", style: TextStyle(fontFamily: FONT_FAMILY, fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(15)),),
                    ),
                   )
                    ],
                  ),
                 )
                    
                  ]),
                ),                             
               
               InkWell(
                onTap: (){
                 print(from_date != '' && to_date != '');
                  if((selected_date != "") || (from_date != '' && to_date != '')){
                    filterHandler(selected_date, from_date, to_date);
                  }
                 Navigator.of(context).pop();
                },
                 child: Container(
                  width: width * 0.90,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(8)
                  ),
                         child: Text("Filter",
                         style: TextStyle(fontFamily: FONT_FAMILY, color: AppColors.whitecolor,fontWeight: FontWeight.w300,fontSize: ScreenUtil().setSp(15))
                         ),
                 ),
               )
              
              ],
            ),
                             
          );
        }
      );
    });
}