import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/controller/DrawerController.dart';
import 'package:admin/model/DashboardModel.dart';
import 'package:admin/screen/CategoryScreen/CategoryScreen.dart';
import 'package:admin/screen/DeliveryPersonsScreen/DeliveryPersonsScreen.dart';
import 'package:admin/screen/GroceryBrandsScreen/GroceryBrandsScreen.dart';
import 'package:admin/screen/GroceryCategoryScreen/GroceryCategoryScreen.dart';
import 'package:admin/screen/GroceryProductsScreen/GroceryProductsScreen.dart';
import 'package:admin/screen/GroceryTagScreen/GroceryTagScreen.dart';
import 'package:admin/screen/GroceryTypesScreen/GroceryTypesScreen.dart';
import 'package:admin/screen/Home/HomeScreen.dart';
import 'package:admin/screen/HomeCategoryScreen/HomeCategoryScreen.dart';
import 'package:admin/screen/HomeGroceryCategoryScreen/HomeGroceryCategoryScreen.dart';
import 'package:admin/screen/HomeGroceryTagsScreen/HomeGroceryTagsScreen.dart';
import 'package:admin/screen/OfficeLocationScreen/OfficeLocationScreen.dart';
import 'package:admin/screen/ReportsScreen/ReportsScreen.dart';
import 'package:admin/screen/RestaurantOrdersScreen/RestaurantOrdersScreen.dart';
import 'package:admin/screen/RestaurantScreen/RestaurantScreen.dart';
import 'package:admin/screen/DeliveryChargesScreen/DeliveryChargesScreen.dart';
import 'package:admin/screen/TopRestaurantsScreen/TopRestaurantScreen.dart';
import 'package:admin/screen/login/loginScreen.dart';
import 'package:admin/screen/tagsScreen/tagsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import 'package:shared_preferences/shared_preferences.dart';
class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {

  @override
  Widget build(BuildContext context) {
 final DrawerIndexController controller = Get.put(DrawerIndexController());
 Color drawerColor(int index){
  print(controller.currentIndex);
Color color = controller.currentIndex ==  index ? AppColors.primaryColor : AppColors.greyBlackcolor;
return color;
 }
 
  return Drawer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: [
                  
                    ListTile(
                      leading: Icon(Icons.dashboard, size: ScreenUtil().setSp(25), color: drawerColor(1),),
                      title:  Text(' Dashboard', style: TextStyle(color: drawerColor(1), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),),
                      onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => 
                           HomeScreen()),
                          );
                         controller.currentIndex(1);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.dashboard, size: ScreenUtil().setSp(25), color: drawerColor(2),),
                      title: ExpansionTile( 
                                               tilePadding: EdgeInsets.all(0),
                         collapsedTextColor: AppColors.blackcolor,
                         collapsedIconColor: AppColors.blackcolor,
                         textColor: AppColors.blackcolor,
                         iconColor: AppColors.blackcolor,
                     
                         initiallyExpanded: false,
                         title:  Text(' Restaurant', style: TextStyle(color: drawerColor(2), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),),
                        children: [
                         ListTile(
                      leading: Icon(Icons.dashboard, size: ScreenUtil().setSp(25), color: drawerColor(3),),
                      title:  Text(' Restaurants', style: TextStyle(color: drawerColor(3), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),),
                      onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => 
                           RestaurantScreen()),
                          );
                         controller.currentIndex(3);
                      },
                    ), 
          
                       ListTile(
                      leading: Icon(Icons.padding_outlined, size: ScreenUtil().setSp(25), color: drawerColor(4),),
                      title:  Text(' Reports', style: TextStyle(color: drawerColor(4), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),),
                      onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => 
                           ReportsScreen()),
                          );
                         controller.currentIndex(4);
                      },
                    ), 
                    ListTile(
                      leading: Icon(Icons.menu_book, size: ScreenUtil().setSp(25), color: drawerColor(5),),
                      title:  Text(' View Orders', style: TextStyle(color: drawerColor(5), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),),
                      onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => 
                           RestaurantOrdersScreen()),
                          );
                         controller.currentIndex(5);
                      },
                    ),
          
          
                     ListTile(
                      leading: Icon(Icons.menu_book, size: ScreenUtil().setSp(25), color: drawerColor(6),),
                      title:  Text(' Categories', style: TextStyle(color: drawerColor(6), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),),
                      onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => 
                           CategoriesScreen()),
                          );
                         controller.currentIndex(6);
                      },
                    ), 
                    
          
                     ListTile(
                      leading: Icon(Icons.menu_book, size: ScreenUtil().setSp(25), color: drawerColor(7),),
                      title:  Text(' Home Categories', style: TextStyle(color: drawerColor(7), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),),
                      onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => 
                           HomeCategoryScreen()),
                          );
                         controller.currentIndex(7);
                      },
                    ), 
          
          
                      ListTile(
                      leading: Icon(Icons.menu_book, size: ScreenUtil().setSp(25), color: drawerColor(8),),
                      title:  Text(' Tags', style: TextStyle(color: drawerColor(8), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),),
                      onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => 
                           TagsScreen()),
                          );
                         controller.currentIndex(8);
                      },
                    ),
          
          
          
                      ListTile(
                      leading: Icon(Icons.menu_book, size: ScreenUtil().setSp(25), color: drawerColor(9),),
                      title:  Text(' Top Restaurants', style: TextStyle(color: drawerColor(9), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),),
                      onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => 
                           TopRestaurantsScreen()),
                          );
                         controller.currentIndex(9);
                      },
                    ), 
                        ],
                      ),
                    ),
          
          
                      ListTile(
                      leading: Icon(Icons.location_city, size: ScreenUtil().setSp(25), color: drawerColor(31),),
                      title:  Text(' Office Location', style: TextStyle(color: drawerColor(31), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),),
                      onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => 
                           OfficeLocationScreen()),
                          );
                         controller.currentIndex(31);
                      },
                    ),
          
          
                     ListTile(
                      leading: Icon(Icons.delivery_dining, size: ScreenUtil().setSp(25), color: drawerColor(41),),
                      title:  Text(' Delivery Charges', style: TextStyle(color: drawerColor(41), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),),
                      onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => 
                           DeliveryChargesScreen()),
                          );
                         controller.currentIndex(41);
                      },
                    ),
          
                     ListTile(
                      leading: Icon(Icons.delivery_dining, size: ScreenUtil().setSp(25), color: drawerColor(51),),
                      title:  Text(' Delivery Persons', style: TextStyle(color: drawerColor(51), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),),
                      onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => 
                           DeliveryPersonsScreen()),
                          );
                         controller.currentIndex(51);
                      },
                    ),
          
                      ListTile(
                      leading: Icon(Icons.dashboard, size: ScreenUtil().setSp(25), color: drawerColor(2),),
                      title: ExpansionTile( 
                                               tilePadding: EdgeInsets.all(0),
                         collapsedTextColor: AppColors.blackcolor,
                         collapsedIconColor: AppColors.blackcolor,
                         textColor: AppColors.blackcolor,
                         iconColor: AppColors.blackcolor,
                     
                         initiallyExpanded: false,
                         title:  Text(' Grocery', style: TextStyle(color: drawerColor(2), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),),
                        children: [
                   ListTile(
                      leading: Icon(Icons.delivery_dining, size: ScreenUtil().setSp(25), color: drawerColor(81),),
                      title:  Text(' Products', style: TextStyle(color: drawerColor(81), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),),
                      onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => 
                           GroceryProductsScreen()),
                          );
                         controller.currentIndex(81);
                      },
                    ),
          
          ListTile(
                      leading: Icon(Icons.delivery_dining, size: ScreenUtil().setSp(25), color: drawerColor(91),),
                      title:  Text(' Categories', style: TextStyle(color: drawerColor(91), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),),
                      onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => 
                           GroceryCategoriesScreen()),
                          );
                         controller.currentIndex(91);
                      },
                    ),

                      ListTile(
                      leading: Icon(Icons.delivery_dining, size: ScreenUtil().setSp(25), color: drawerColor(92),),
                      title:  Text(' Tags', style: TextStyle(color: drawerColor(92), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),),
                      onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => 
                           GroceryTagScreen()),
                          );
                         controller.currentIndex(92);
                      },
                    ),

                    ListTile(
                      leading: Icon(Icons.delivery_dining, size: ScreenUtil().setSp(25), color: drawerColor(93),),
                      title:  Text(' Brand', style: TextStyle(color: drawerColor(93), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),),
                      onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => 
                           GroceryBrandScreen()),
                          );
                         controller.currentIndex(93);
                      },
                    ),

                     ListTile(
                      leading: Icon(Icons.delivery_dining, size: ScreenUtil().setSp(25), color: drawerColor(94),),
                      title:  Text(' Types', style: TextStyle(color: drawerColor(94), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),),
                      onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => 
                           GroceryTypesScreen()),
                          );
                         controller.currentIndex(94);
                      },
                    ),


                      ListTile(
                      leading: Icon(Icons.delivery_dining, size: ScreenUtil().setSp(25), color: drawerColor(95),),
                      title:  Text(' Home Categories', style: TextStyle(color: drawerColor(95), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),),
                      onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => 
                           HomeGroceryCategoryScreen()),
                          );
                         controller.currentIndex(95);
                      },
                    ),


                      ListTile(
                      leading: Icon(Icons.delivery_dining, size: ScreenUtil().setSp(25), color: drawerColor(96),),
                      title:  Text(' Home Tags', style: TextStyle(color: drawerColor(96), fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),),
                      onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => 
                           HomeGroceryTagsScreen()),
                          );
                         controller.currentIndex(96);
                      },
                    ),
          
                        ]
                      )
                      )
                    
                  ]
                ),
                  
                 ListTile(
                      leading: Icon(Icons.logout, size: ScreenUtil().setSp(25)),
                     title:  Text('Logout', style: TextStyle(color: AppColors.greyBlackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(14)),),
                      onTap: () async{
                       final prefs = await SharedPreferences.getInstance();
                       prefs.remove("isLogged");
                       prefs.remove("admin_id");
                            Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => 
                           LoginScreen()),
                          );
                  
                      },
                    )
              ],
            ),
          ),
        )
        );
  }
}