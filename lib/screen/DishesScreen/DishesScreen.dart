import 'dart:convert';

import 'package:admin/Provider/DishesProvider.dart';
import 'package:admin/components/AddDishForm.dart';
import 'package:admin/components/DishCard.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/restaurantModel.dart';
import 'package:admin/navigation/DrawerNavigation.dart';
import 'package:admin/screen/RestaurantScreen/MenusScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:scroll_to_index/scroll_to_index.dart';

class DishesScreen extends StatefulWidget {
  final RestaurantModel restaurant;
  const DishesScreen({super.key, required this.restaurant});


  
  @override
  State<DishesScreen> createState() => _DishesScreenState();
}

class _DishesScreenState extends State<DishesScreen> {

void initState(){
  
     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<DishesProvider>(context, listen: false).getDishes(widget.restaurant?.restaurantId?.toString() ?? '');
         Provider.of<DishesProvider>(context, listen: false).getMenus(widget.restaurant?.restaurantId?.toString() ?? '');
   
      
    });
  super.initState();
}

  void reorderData(int oldindex, int newindex) {
    //    final menus = Provider.of<MenuProvider>(context, listen: false).menus;
 
    // setState(() {
    //   if (newindex > oldindex) {
    //     newindex -= 1;
    //   }
    //   final items = menus.removeAt(oldindex);
    //      menus.insert(newindex, items);

    // });
  }

  @override
  Widget build(BuildContext context) {
    final dishes = Provider.of<DishesProvider>(context, listen: true).dishes;
    double height =  MediaQuery.of(context).size.height;
    double width =  MediaQuery.of(context).size.width;
   
    return Scaffold(
      
            bottomNavigationBar: 
      (dishes?.length ?? 0) > 0 ?
      Container( 
        height: height * 0.08,
         width: width,
         alignment: Alignment.center,
         padding: const EdgeInsets.all(2),
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
         child: InkWell( 
          onTap: (){
         Provider.of<DishesProvider>(context, listen: false).UpdateDishes();
          },
          child: Container( 
             height: height * 0.055,
            width: width * 0.90,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration( 
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Text("Update", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14), fontWeight: FontWeight.w500),),
          ),
         ),
          ): SizedBox(),

       backgroundColor: AppColors.whitecolor,
       drawer: DrawerMenu(),
         appBar: AppBar( 
         iconTheme: IconThemeData(color: AppColors.greyBlackcolor),
        elevation: 0.5,
        backgroundColor: AppColors.whitecolor,
        
         title: Text('Dishes',style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(16))),
        actions: [
           Container(
            margin: const EdgeInsets.only(right: 10),
            child: InkWell(
          onTap: (){
              Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => 
                        MenusScreen(restaurant: widget.restaurant,)),
                        );
          },
              child: Icon(Icons.menu_rounded, color: AppColors.primaryColor, size: ScreenUtil().setSp(25),),
            ),
          ),
        ], 
      ),

      body: RefreshIndicator(
        onRefresh: ()async {
           await Provider.of<DishesProvider>(context, listen: false).getDishes(widget.restaurant?.restaurantId?.toString() ?? '');
       await  Provider.of<DishesProvider>(context, listen: false).getMenus(widget.restaurant?.restaurantId?.toString() ?? '');
  },
        child: SingleChildScrollView( 
          child: Column(
            children: [
                Padding(
               padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                //  itemScrollController: itemScrollController,
              
                   itemCount: dishes.length ?? 0,
                   physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                padding: EdgeInsets.only(left: 10, right: 10),
                   itemBuilder: ((context, index) {
                   return Container(
                     margin: const EdgeInsets.symmetric(vertical: 10.0),
                       padding: const EdgeInsets.all(10.0),
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
                         title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text(
                              dishes?[index]?.menuName ?? "",maxLines: 2,style: TextStyle(fontFamily: "Poppins", overflow: TextOverflow.ellipsis,fontWeight: FontWeight.bold, color: AppColors.blackcolor, fontSize: ScreenUtil().setSp(14.0)),
                             ),

                             InkWell(
                              onTap: (){
                                AddDishForm(context, dishes[index]?.menuId ?? 0, widget!.restaurant!.restaurantId ?? 0);
                              },
                              child: Icon(Icons.add_circle_outline_rounded, color: AppColors.primaryColor,
                              size: ScreenUtil().setSp(20),
                              ),
                             )
                           ],
                         ),
                         
                         children: [
                    //       ListView.builder(
                    //          physics: NeverScrollableScrollPhysics(),
                    // shrinkWrap: true,
                    //  itemCount: dishes[index]?.dishes?.length ?? 0,
                    //        itemBuilder: ((context, i) {
                    //          return DishCard(dish: dishes[index]?.dishes?[i]);
                   
                    //        })
                    //       )
      
                    ReorderableListView(
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shrinkWrap: true,
            onReorder: (int oldIndex, int newIndex) {
               final dishes_ = Provider.of<DishesProvider>(context, listen: false).dishes[index]?.dishes;
             if(newIndex > oldIndex){
                 newIndex -= 1;
           
             }
             final items= dishes_!.removeAt(oldIndex);
           dishes_?.insert(newIndex, items);
          for(int i = 0; i < (dishes[index]?.dishes?.length ?? 0); i++ ){
            dishes[index]?.dishes?[i].position = i + 1;
          }
          final r = json.encode(dishes_);
          print(r);
          Provider.of<DishesProvider>(context, listen: false).addDishes(dishes);
        
           },
                  children: [
                    for(int i = 0; i < (dishes?[index]?.dishes?.length ?? 0); i++)
                    Container(
                         key: ValueKey(dishes[index]?.dishes?[i]),
                      child: DishCard(
                        cxt: context,
                        restaurant: widget!.restaurant,
                        dish: dishes[index]?.dishes?[i], menuIndex: index, dishIndex: i,),
                    )
                 
                  ],
                    )
                  
                         ],
                       ),
                   ));
                 })),
              ),


              SizedBox(height: height,),
            ],
          ),
        ),
      ),
    
    );
  }
}