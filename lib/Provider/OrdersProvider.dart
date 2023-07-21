


import 'package:admin/model/OrderModel.dart';
import 'package:flutter/material.dart';

class OrdersProvider extends ChangeNotifier{
List<OrderModel> received = [];
List<OrderModel> confirmed= [];
List<OrderModel> ontheway = [];
List<OrderModel> delivered = [];
List<OrderModel> cancelled = [];


bool lrecieved = false;
bool lconfirmed = false;
bool lontheway = false;
bool ldelivered = false;
bool lcancelled = false;


UpdateOrder(OrderModel order){
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


addAllReceived(List<OrderModel> data){
  received = data;
  notifyListeners();
}
addReceived(List<OrderModel> data){
  received = [...received, ...data];
  notifyListeners();
}


addAllConfirmed(List<OrderModel> data){
  confirmed = data;
  notifyListeners();
}
addConfirmed(List<OrderModel> data){
  confirmed = [...confirmed, ...data];
  notifyListeners();
}

addAllOntheway(List<OrderModel> data){
  ontheway = data;
  notifyListeners();
}
addOntheway(List<OrderModel> data){
  ontheway = [...ontheway, ...data];
  notifyListeners();
}


addAllDelivered(List<OrderModel> data){
  delivered = data;
  notifyListeners();
}
addDelivered(List<OrderModel> data){
  delivered = [...delivered, ...data];
  notifyListeners();
}


addAllCancelled(List<OrderModel> data){
  cancelled = data;
  notifyListeners();
}
addCanelled(List<OrderModel> data){
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