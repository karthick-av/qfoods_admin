
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/model/GroceryOrderModel.dart';
import 'package:admin/navigation/DrawerNavigation.dart';
import 'package:admin/screen/GroceryOrdersScreen/GroceryOrdersCancelledScreen.dart';
import 'package:admin/screen/GroceryOrdersScreen/GroceryOrdersConfirmedScreen.dart';
import 'package:admin/screen/GroceryOrdersScreen/GroceryOrdersDeliveredScreen.dart';
import 'package:admin/screen/GroceryOrdersScreen/GroceryOrdersOntheWayScreen.dart';
import 'package:admin/screen/GroceryOrdersScreen/GroceryOrdersRecievedScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroceryOrdersScreen extends StatefulWidget {
  const GroceryOrdersScreen({super.key});

  @override
  State<GroceryOrdersScreen> createState() => _GroceryOrdersScreenState();
}

class _GroceryOrdersScreenState extends State<GroceryOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(  
        length: 5,  
        child: Scaffold(  
            drawer: DrawerMenu(),
    
          appBar: AppBar(  
            title: Text('Grocery Orders'),  
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
              GroceryOrdersRecievedScreen(),  
              GroceryOrdersConfirmedScreen(),  
              GroceryOrdersOntheWayScreen(),  
              GroceryOrdersDeliveredScreen(),  
              GroceryOrdersCancelledScreen(),  
            ],  
          ),  
        ),  
      );
  }

}


class GroceryOrdersStatusScreen extends StatefulWidget {
  const GroceryOrdersStatusScreen({super.key});

  @override
  State<GroceryOrdersStatusScreen> createState() => _GroceryOrdersStatusScreenState();
}

class _GroceryOrdersStatusScreenState extends State<GroceryOrdersStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
















class GroceryOrdersProvider extends ChangeNotifier{
List<GroceryOrderModel> received = [];
List<GroceryOrderModel> confirmed= [];
List<GroceryOrderModel> ontheway = [];
List<GroceryOrderModel> delivered = [];
List<GroceryOrderModel> cancelled = [];


bool lrecieved = false;
bool lconfirmed = false;
bool lontheway = false;
bool ldelivered = false;
bool lcancelled = false;



UpdateOrder(GroceryOrderModel order){
  int rind = received.indexWhere((e) => e?.orderId  == order?.orderId);
  if(rind != -1){
   received?.removeWhere((e) => e?.orderId == order?.orderId);
  }
 int cind = confirmed.indexWhere((e) => e?.orderId  == order?.orderId);
 if(cind == -1){
  confirmed.insert(0, order);
 }
 notifyListeners();
}


addAllReceived(List<GroceryOrderModel> data){
  received = data;
  notifyListeners();
}
addReceived(List<GroceryOrderModel> data){
  received = [...received, ...data];
  notifyListeners();
}


addAllConfirmed(List<GroceryOrderModel> data){
  confirmed = data;
  notifyListeners();
}
addConfirmed(List<GroceryOrderModel> data){
  confirmed = [...confirmed, ...data];
  notifyListeners();
}

addAllOntheway(List<GroceryOrderModel> data){
  ontheway = data;
  notifyListeners();
}
addOntheway(List<GroceryOrderModel> data){
  ontheway = [...ontheway, ...data];
  notifyListeners();
}


addAllDelivered(List<GroceryOrderModel> data){
  delivered = data;
  notifyListeners();
}
addDelivered(List<GroceryOrderModel> data){
  delivered = [...delivered, ...data];
  notifyListeners();
}


addAllCancelled(List<GroceryOrderModel> data){
  cancelled = data;
  notifyListeners();
}
addCanelled(List<GroceryOrderModel> data){
  cancelled = [...cancelled, ...data];
  notifyListeners();
}



updateRecieved(){
  lrecieved = true;
  notifyListeners();
}

updateConfirmed(){
  lconfirmed = true;
  notifyListeners();
}


updateOntheWay(){
  lontheway = true;
  notifyListeners();
}


updateDelivered(){
  ldelivered = true;
  notifyListeners();
}


updatecancelled(){
  lcancelled = true;
  notifyListeners();
}
}