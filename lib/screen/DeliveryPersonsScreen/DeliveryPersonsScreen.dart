import 'dart:convert';

import 'package:admin/components/AddDeliveryPersonsForm.dart';
import 'package:admin/constants/CustomSnackBar.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/DeliveryPersonsModel.dart';
import 'package:admin/navigation/DrawerNavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class DeliveryPersonsScreen extends StatefulWidget {
  const DeliveryPersonsScreen({super.key});

  @override
  State<DeliveryPersonsScreen> createState() => _DeliveryPersonsScreenState();
}

class _DeliveryPersonsScreenState extends State<DeliveryPersonsScreen> {

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
     final detailProvider = Provider.of<deliverypersonsProvider>(context, listen: false);
 
   if((detailProvider?.list?.length ?? 0) == 0){
      getDetailHandler("init", "");
  
   }
  });
     scrollController.addListener(() { 
      //listener 
    
      // if(scrollController.offset.toInt() > ScreenUtil().setHeight(32.0).toInt()){
        
        
      // }
        if(scrollController.position.maxScrollExtent == scrollController.offset){
       if(!ApiCallDone){
       getDetailHandler("bottom",filterCondition);
  
        
       }
    }
  
    });
    
 
  
}

void dispose(){
scrollController.dispose();
  super.dispose();
}

Future<void> getDetailHandler(String type, String filter)async {
  if(CompleteAPI) return;
 final detailProvider = Provider.of<deliverypersonsProvider>(context, listen: false);
 
  List<DeliveryPersonsModel> _list= [];

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
       String url = "${ApiServices.deliverypersons}?page=${current_page}&per_page=${per_page}&${filter}";
   print(url);
    var response = await http.get(Uri.parse(url));

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
     
      _list.add(DeliveryPersonsModel.fromJson(json));
       }

       setState(() {
    current_page = current_page + 1;
    });
      if(type == "init"){
      detailProvider.addAll(_list);   
      }else{
       detailProvider.add(_list);   
     
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
 final detailProvider = Provider.of<deliverypersonsProvider>(context, listen: false);
 
  ResetState();
  detailProvider.addAll([]);

String val = '';
if(selectedDate != ""){
 val = "&selected_date=${selectedDate}";
}
if(fromDate != "" && toDate != ""){
 val = "&from_date=${fromDate}&to_date=${toDate}";

}
filterCondition = val;
setState(() {});
getDetailHandler("init", val);
}

Future<void> deleteHandler(DeliveryPersonsModel person) async{
  
loading = true;
setState((){});

 try{
    
    
    var response = await http.delete(Uri.parse("${ApiServices.deliverypersons}/${person?.personId}"));
    print(response.statusCode);

loading = false;
setState((){});

     if(response.statusCode == 200){
        Provider.of<deliverypersonsProvider>(context, listen: false).remove(person);
        CustomSnackBar().ErrorMsgSnackBar("Deleted");
      }else{
      CustomSnackBar().ErrorSnackBar();

     }
    }catch(e){
print(e);
CustomSnackBar().ErrorSnackBar();
 Navigator.of(context).pop();
  
  
loading = false;
setState((){});
    }
}

  @override
  Widget build(BuildContext context) {
     double height = MediaQuery.of(context).size.height;
        double width = MediaQuery.of(context).size.width;
  final list = Provider.of<deliverypersonsProvider>(context, listen: true).list;
 
    return Scaffold(
      backgroundColor: AppColors.whitecolor,
      drawer: DrawerMenu(),
        appBar: AppBar(
          actions: [
            InkWell(
          onTap: (){
           AddDeliveryPersonForm(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
             Icon(Icons.add_circle_outline_rounded, size: ScreenUtil().setSp(24), color: AppColors.whitecolor,)
            ,    SizedBox(width: 10,),
            ],
          ),
        )
          ],
   iconTheme: IconThemeData(
    color: Colors.white, // <-- SEE HERE
   ),
        elevation: 0.5,
        title: Text("Delivery Persons", style: TextStyle(fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(16.0), fontWeight: FontWeight.bold,color: AppColors.whitecolor),),
      ),
      body: SafeArea(
        child:  RefreshIndicator(
           color: AppColors.primaryColor,
                onRefresh: ()async{
                  ResetState();
             
                  await getDetailHandler("init", "");
                
          },
          child:  SingleChildScrollView(
            controller: scrollController,
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
                await getDetailHandler("init", "search=${val}");
              
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

                   if(loading)
                               LinearProgressIndicator(
                                
                                backgroundColor: AppColors.whitecolor,
                                 valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),  
                    minHeight: 10,
                              ),
               Container(
                              margin: const EdgeInsets.only(top: 10),
                              width: double.infinity,
                              height: 1,
                              color: Color(0XFFe9e9eb),
                             ),
                
              ListView.builder(
               physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: list?.length ?? 0,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemBuilder:(context, index) {
                 
                return InkWell(
                  onTap: (){
                 
                  },
                  child: Slidable(
                                       startActionPane: ActionPane(
                              extentRatio: 0.25,
                               motion: const ScrollMotion(),
children:  [
      // A SlidableAction can have an icon and/or a label.
      SlidableAction(
        onPressed: ((context) {
         // UpdateCategoryForm(context, data![index]);
         // UpdateDeliveryCharges(context, val, updateHandler);

         UpdateDeliveryPersonForm(context, list[index]);
        }),
        backgroundColor: AppColors.pricecolor,
        foregroundColor: Colors.white,
        icon: Icons.update,
        label: 'Update',
      )
    ],
                             ) ,
                             endActionPane: ActionPane(
                              extentRatio: 0.25,
                               motion: const ScrollMotion(),
children:  [
      // A SlidableAction can have an icon and/or a label.
      SlidableAction(
         onPressed: ((context) {
       // deleteHandler(data?[index]?.categoryId ?? 0);
       deleteHandler(list[index]);
        }),
        backgroundColor: Color(0xFFFE4A49),
        foregroundColor: Colors.white,
        icon: Icons.delete,
        label: 'Delete',
      )
    ],
                             ) ,
    
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${list[index]?.name  ?? ''}",style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14.0), fontWeight: FontWeight.w500)),
                          SizedBox(height: 5,),
                          Text("${list[index]?.phoneNumber ?? ''}",style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(11.0), fontWeight: FontWeight.w400)),
                       
                        ],
                      ),
                    ),
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
                         SizedBox(height: MediaQuery.of(context).size.height )
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class deliverypersonsProvider extends ChangeNotifier{
  List<DeliveryPersonsModel> list = [];
  addAll(List<DeliveryPersonsModel> data) {
    list = data;
    notifyListeners();
  }
  add(List<DeliveryPersonsModel> data){
  list = [...list, ...data];
  notifyListeners();
  }

  remove(DeliveryPersonsModel data){
    list?.removeWhere((e) => e?.personId == data?.personId);
    notifyListeners();
  }
   update(DeliveryPersonsModel data){
    int index = list?.indexWhere((e) => e?.personId == data?.personId) ?? -1;
    if(index != -1){
      list[index] = data;
    }
    notifyListeners();
  }

  addNew(DeliveryPersonsModel data){
  int index = list?.indexWhere((e) => e?.personId == data?.personId) ?? -1;
    if(index == -1){
      list.insert(0, data);
    }
    notifyListeners();
 
  }
 
}

