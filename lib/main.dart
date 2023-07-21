import 'package:admin/Provider/DishesProvider.dart';
import 'package:admin/Provider/OrdersProvider.dart';
import 'package:admin/Provider/RestaurantsProvider.dart';
import 'package:admin/Provider/CategoryProvider.dart';
import 'package:admin/Provider/groceryProductsProvider.dart';
import 'package:admin/constants/NotificationServices.dart';
import 'package:admin/screen/CategoryScreen/CategoryScreen.dart';
import 'package:admin/screen/CategoryScreen/ViewCategoryDishesScreen.dart';
import 'package:admin/screen/CouponsScreen/CouponScreen.dart';
import 'package:admin/screen/DeliveryPersonsScreen/DeliveryPersonsScreen.dart';
import 'package:admin/screen/GroceryBrandsScreen/GroceryBrandsScreen.dart';
import 'package:admin/screen/GroceryBrandsScreen/ViewGroceryBrandProductsScreen.dart';
import 'package:admin/screen/GroceryCategoryScreen/GroceryCategoryScreen.dart';
import 'package:admin/screen/GroceryTagScreen/GroceryTagScreen.dart';
import 'package:admin/screen/GroceryTagScreen/ViewGroceryTagProductsScreen.dart';
import 'package:admin/screen/GroceryTypesScreen/GroceryTypesScreen.dart';
import 'package:admin/screen/GroceryTypesScreen/ViewGroceryTypeProductsScreen.dart';
import 'package:admin/screen/Home/HomeScreen.dart';
import 'package:admin/screen/login/loginScreen.dart';
import 'package:admin/screen/tagsScreen/ViewTagsDishesScreen.dart';
import 'package:admin/screen/tagsScreen/tagsScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:loader_overlay/loader_overlay.dart';

import 'screen/GroceryCategoryScreen/ViewGroceryCategoryProducts.dart';
import 'screen/GroceryOrdersScreen/GroceryOrdersScreen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message?.notification?.title}');
  if(message.notification != null){
  NotificationService.createNotification(message, "background");
}
}

void main() async{
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
 FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
NotificationService.initalize();
   final SharedPreferences prefs = await SharedPreferences.getInstance();
  var isLoggedIn = ((prefs.getBool('isLogged') == null) ? false : prefs.getBool('isLogged')) ?? false;
 
 runApp(MultiProvider(
    providers: [
                      ChangeNotifierProvider(create: ((context) => RestaurantsProvider())),
  ChangeNotifierProvider(create: ((context) => DishesProvider())),
   ChangeNotifierProvider(create: ((context) => SelectedCategoryProvider())),
   ChangeNotifierProvider(create: ((context) => CategoryDishesProvider())),
   ChangeNotifierProvider(create: ((context) => SearchCategoryProvider())),
  ChangeNotifierProvider(create: ((context) => TagsDishesProvider())),
  ChangeNotifierProvider(create: ((context) => deliverypersonsProvider())),
  ChangeNotifierProvider(create: ((context) => SearchRestaurantsProvider())),
  ChangeNotifierProvider(create: ((context) => GroceryProductsProvider())),
  ChangeNotifierProvider(create: ((context) => SearchGroceryCategoryProvider())),
  ChangeNotifierProvider(create: ((context) => SearchGroceryTypesProvider())),
  ChangeNotifierProvider(create: ((context) => SearchGroceryBrandsProvider())),
  ChangeNotifierProvider(create: ((context) => SearchGroceryProductsProvider())),
  ChangeNotifierProvider(create: ((context) => GrocerycategoryProvider())),
  ChangeNotifierProvider(create: ((context) => CategoryProductsProvider())),
  ChangeNotifierProvider(create: ((context) => GroceryTagProvider())),
  ChangeNotifierProvider(create: ((context) => GroceryTagProductsProvider())),
  ChangeNotifierProvider(create: ((context) => GroceryBrandsProvider())),
  ChangeNotifierProvider(create: ((context) => GroceryBrandProductsProvider())),
  ChangeNotifierProvider(create: ((context) => GroceryTypesProvider())),
  ChangeNotifierProvider(create: ((context) => GroceryTypeProductsProvider())),
  ChangeNotifierProvider(create: ((context) => DishCategoryProvider())),
  ChangeNotifierProvider(create: ((context) => DishTagsProvider())),
  ChangeNotifierProvider(create: ((context) => SearchGroceryTagsProvider())),
  ChangeNotifierProvider(create: ((context) => GroceryOrdersProvider())),
  ChangeNotifierProvider(create: ((context) => OrdersProvider())),
  ChangeNotifierProvider(create: ((context) => CouponProvider())),
  
  
  
                  ],
   child: GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MaterialApp(
        title: 'Qfoods Vendor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
        
          primarySwatch: Colors.red,
        ),
        home:  LoaderOverlay(
          child: ScreenUtilInit(
             designSize: Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
                builder: ((context, child) {
                  return SafeArea(child:  isLoggedIn ? HomeScreen() : LoginScreen());
                }),
               ),
        )
      ),),
 ));
}
