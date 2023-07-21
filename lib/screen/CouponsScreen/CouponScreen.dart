
import 'package:admin/constants/colors.dart';
import 'package:admin/model/CouponModel.dart';
import 'package:admin/model/GroceryCouponModel.dart';
import 'package:admin/navigation/DrawerNavigation.dart';
import 'package:admin/screen/CouponsScreen/AddCoupon.dart';
import 'package:admin/screen/CouponsScreen/GroceryCouponsScreen.dart';
import 'package:admin/screen/CouponsScreen/RestaurantCouponsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 2,
      child: Scaffold(
            drawer: DrawerMenu(),
    appBar: AppBar(
          title: Text("Coupons"),
          bottom: TabBar( 
              tabs: [  
                Tab( text: "Restaurant"),  
                Tab( text: "Grocery"),  
              
              ],  
            ),
         actions: [
         
           Container(
            
            margin: const EdgeInsets.only(right: 10, left: 10),
             child: InkWell(
            onTap: (){
           AddCoupon(context);
            },
              child: Icon(Icons.add_circle, color: AppColors.whitecolor, size: ScreenUtil().setSp(20),),
                   ),
           ),
           
         ],
    
        ),
         backgroundColor: AppColors.whitecolor,  
         body: TabBarView(  
            children: [  
           RestaurantCouponsScreen(),  
           GroceryCouponsScreen(),
            ],  
          ),  
      ),
    );
  }
}


class CouponProvider extends ChangeNotifier{
List<CouponModel> restaurant = [];
List<GroceryCouponModel> grocery= [];

bool apiResCalled = false;
bool apiGroCalled = false;


addAllRestaurant(List<CouponModel> data){
  restaurant = data;
  notifyListeners();
}
addRestaurant(List<CouponModel> data){
  restaurant = [...restaurant, ...data];
  notifyListeners();
}
addNewRestaurant(CouponModel data){
  restaurant.add(data);
  notifyListeners();
}

updateRestaurant(CouponModel data){
   int index = restaurant?.indexWhere((e) => e?.id ==  data?.id) ?? -1;
   if(index != -1){
    restaurant[index] = data;
    notifyListeners();
   }

}

deleteRestaurant(int id){
  restaurant?.removeWhere((e) => e?.id == id);
  notifyListeners();
}
addResCalled() {
  apiResCalled = true;
  notifyListeners();
}



addAllGrocery(List<GroceryCouponModel> data){
  grocery = data;
  notifyListeners();
}
addGrocery(List<GroceryCouponModel> data){
  grocery = [...grocery, ...data];
  notifyListeners();
}
addGroCalled() {
  apiGroCalled = true;
  notifyListeners();
}

addNewGrocery(GroceryCouponModel data){
  grocery.add(data);
  notifyListeners();
}

updateGrocery(GroceryCouponModel data){
   int index = grocery?.indexWhere((e) => e?.id ==  data?.id) ?? -1;
   if(index != -1){
    grocery[index] = data;
    notifyListeners();
   }

}
deleteGrocery(int id){
  grocery?.removeWhere((e) => e?.id == id);
  notifyListeners();
}
}