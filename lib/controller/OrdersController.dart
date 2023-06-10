import 'package:admin/model/OrderModel.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController{
 List<OrderModel> orders = [];
  addAllOrders(List<OrderModel> data) => orders = data;
  addOrders(List<OrderModel> data) => orders = [...orders, ...data];

 
}