
import 'package:admin/model/CategoryModel.dart';
import 'package:admin/model/DashboardModel.dart';
import 'package:admin/model/GroceryDashboardModel.dart';
import 'package:admin/model/OrderModel.dart';
import 'package:get/get.dart';

class dashboardController extends GetxController{
 DashboardModel? dashboard;
 GroceryDashboardModel? gdashboard;
  addRdata(DashboardModel data) => dashboard =data;
addgData(GroceryDashboardModel? data) => gdashboard = data;

 
}

class TokenController extends GetxController{
  bool isUpdated = false;
  updateHandler() => isUpdated = true;
}