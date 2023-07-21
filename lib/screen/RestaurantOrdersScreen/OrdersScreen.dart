
import 'dart:convert';

import 'package:admin/navigation/DrawerNavigation.dart';
import 'package:admin/screen/RestaurantOrdersScreen/TabsOrders/OrdersCancelledScreen.dart';
import 'package:admin/screen/RestaurantOrdersScreen/TabsOrders/OrdersConfirmedScreen.dart';
import 'package:admin/screen/RestaurantOrdersScreen/TabsOrders/OrdersDeliveredScreen.dart';
import 'package:admin/screen/RestaurantOrdersScreen/TabsOrders/OrdersOntheWayScreen.dart';
import 'package:admin/screen/RestaurantOrdersScreen/TabsOrders/OrdersRecievedScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class RestauarantOrdersScreen extends StatefulWidget {
  const RestauarantOrdersScreen({super.key});

  @override
  State<RestauarantOrdersScreen> createState() => _RestauarantOrdersScreenState();
}

class _RestauarantOrdersScreenState extends State<RestauarantOrdersScreen> {
 
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(  
        length: 5,  
        
        child: Scaffold(  
            drawer: DrawerMenu(),
    
          appBar: AppBar(  
            title: Text('Orders'),  
            bottom: TabBar( 
              tabs: [  
                Tab( text: "Recieved"),  
                Tab( text: "Confirmed"),  
                Tab( text: "On the Way"),  
                Tab( text: "Delivered"),  
                Tab( text: "Cancelled")  
              ],  
            ),  
          ),  
          body: TabBarView(  
            children: [  
              OrdersRecievedScreen(),  
              OrdersConfirmedScreen(),  
              OrdersOntheWayScreen(),  
              OrdersDeliveredScreen(),  
              OrdersCancelledScreen(),  
            ],  
          ),  
        ),  
      );
  }
}




