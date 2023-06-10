
import 'dart:async';
import 'dart:convert';

import 'package:admin/components/bubbleArrow.dart';
import 'package:admin/constants/CustomSnackBar.dart';
import 'package:admin/constants/api_services.dart';
import 'package:admin/constants/colors.dart';
import 'package:admin/constants/font_family.dart';
import 'package:admin/navigation/DrawerNavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class officeLocationModel {
  int? id;
  String? name;
  String? latitude;
  String? longitude;

  officeLocationModel({this.id, this.name, this.latitude, this.longitude});

  officeLocationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}


class OfficeLocationScreen extends StatefulWidget {
  const OfficeLocationScreen({super.key});

  @override
  State<OfficeLocationScreen> createState() => _OfficeLocationScreenState();
}

class _OfficeLocationScreenState extends State<OfficeLocationScreen>  with TickerProviderStateMixin {

  double? _currentlat = 0;
  double? _currentlong = 0;
   late final MapController mapController;
  Timer? timer;
bool loading = false;
  


@override
void initState(){
mapController = MapController();
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
   officeLocationHandler();
    });
  super.initState();
}


Future<void> officeLocationHandler() async{
  loading = true;
    setState(() {});
  try{

      var response = await http.get(Uri.parse(ApiServices.office_location));
  loading = false;
    setState(() {});
    
   if(response.statusCode == 200){
    final responseBody = json.decode(response.body);

    officeLocationModel loc = officeLocationModel.fromJson(responseBody);
    _currentlat = double.parse(loc?.latitude ?? "0");
    _currentlong = double.parse(loc?.longitude ?? "0");

          LatLng? currentLatLong = LatLng(_currentlat ?? 0, _currentlong ?? 0);
       
      setState(() {});
       print(_currentlat);
       print(_currentlong);
         _animatedMapMove(currentLatLong, 18.0);
    setState(() { });

   }
  }catch(e){
    loading = false;
    setState(() {});
    CustomSnackBar().ErrorSnackBar();
  }
}



Future<void> updateLocationHandler() async{
  loading = true;
    setState(() {});
  try{

dynamic data = {
  "latitude": _currentlat?.toString(),
"longitude": _currentlong?.toString()
};
      var response = await http.put(Uri.parse(ApiServices.office_location), body: data);
  loading = false;
    setState(() {});
    
   if(response.statusCode == 200){
    final responseBody = json.decode(response.body);

    officeLocationModel loc = officeLocationModel.fromJson(responseBody);
    _currentlat = double.parse(loc?.latitude ?? "0");
    _currentlong = double.parse(loc?.longitude ?? "0");

          LatLng? currentLatLong = LatLng(_currentlat ?? 0, _currentlong ?? 0);
       
      setState(() {});
       print(_currentlat);
       print(_currentlong);
         _animatedMapMove(currentLatLong, 18.0);
    setState(() { });

   }
  }catch(e){
    loading = false;
    setState(() {});
    CustomSnackBar().ErrorSnackBar();
  }
}

@override
void dispose(){
  timer?.cancel();
  super.dispose();
}




Future<void> _getLocation() async{
    _getLocationData().then((value) {
      LocationData? location = value;
      print(location?.latitude);
      print(location?.longitude);
      LatLng? currentLatLong = LatLng(location?.latitude ?? 0, location!.longitude ?? 0);
        _currentlat = location?.latitude;
        _currentlong = location?.longitude;
      
      setState(() {});
         _animatedMapMove(currentLatLong, 18.0);
    });
}
void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final latTween = Tween<double>(
        begin: mapController.center.latitude, end: destLocation.latitude);
    final lngTween = Tween<double>(
        begin: mapController.center.longitude, end: destLocation.longitude);
    final zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    final controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      mapController.move(
          LatLng(latTween.evaluate(animation), lngTween.evaluate(animation)),
          zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }

  Future<LocationData?> _getLocationData() async {
  Location location = new Location();
  LocationData _locationData;

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return null;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  _locationData = await location.getLocation();

  return _locationData;
}
  @override
  Widget build(BuildContext context) {
      LatLng currentLatLng;



    if (_currentlat != null && _currentlong != null) {
      currentLatLng =
          LatLng(_currentlat ?? 0, _currentlong ?? 0);
    } else {
      currentLatLng = LatLng(0, 0);
    }

  final markers = <Marker>[
      Marker(
        width: ScreenUtil().setWidth(200.0),
       height: ScreenUtil().setHeight(40.0),
        point: currentLatLng,
        builder: (ctx){
          return SizedBox();
        },
      ),
     ];

double itemWidth = MediaQuery.of(context).size.width * 0.80;
double width = MediaQuery.of(context).size.width * 0.90;
double height = MediaQuery.of(context).size.height;

  
    return  Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        title: Text("Office Location"),
       actions: [
        InkWell(
          onTap: (){
            _getLocation();
          },
          child: Icon(Icons.gps_fixed, color: AppColors.whitecolor, size: ScreenUtil().setSp(20),),
        ),
         Container(
          
          margin: const EdgeInsets.only(right: 10, left: 10),
           child: InkWell(
          onTap: (){
            officeLocationHandler();
          },
            child: Icon(Icons.refresh, color: AppColors.whitecolor, size: ScreenUtil().setSp(20),),
                 ),
         )
       ],

      ),
      bottomNavigationBar:  Container( 
        height: height * 0.19,
          width:  MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.whitecolor,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
          ),
          alignment: Alignment.center,
          child: 
          loading
          ? CircularProgressIndicator(color: AppColors.primaryColor, strokeWidth: 0.9,)
          :
          InkWell(
            onTap: (){
              updateLocationHandler();
            },
            child: Container(
              width: width * 0.90,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text("latitude", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w300),)
                        ,
                          Container(
                              padding: EdgeInsets.all(8),
                          width: width * 0.40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child:      Text("${_currentlat?.toStringAsFixed(4) ?? '0'}", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w300),)
                       
                          ),
          
                        ],
                      ),
          
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text("longitude", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(15), fontWeight: FontWeight.w300),)
                        ,
                          Container(
                              padding: EdgeInsets.all(8),
                          width: width * 0.40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child:      Text("${_currentlong?.toStringAsFixed(4) ?? '0'}", style: TextStyle(color: AppColors.blackcolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12), fontWeight: FontWeight.w300),)
                       
                          ),
          
                        ],
                      )
                    ],
                  ),
                  InkWell(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10),
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                         decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 20,
                            color: const Color(0xFFB0CCE1).withOpacity(0.29),
                          ),
                        ],
                      ),
                      child: Text("Update", style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(13), fontWeight: FontWeight.w400),),
                    ),
                  )
                ],
              ),
            ),
          )
        ),
      body: SafeArea(
       
        child: Stack(
        children: [
         FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: LatLng(10.7870,79.1378),
                onPositionChanged: ((position, hasGesture) {
                     timer?.cancel();
      
        timer = Timer(Duration(milliseconds: 1000), () {
          _currentlat = position.center?.latitude ?? 0;
          _currentlong = position.center?.longitude ?? 0;
          setState(() {});
        
        });
                }),
                zoom: 5,
              ),
              nonRotatedChildren: [
                AttributionWidget.defaultWidget(
                  source: 'OpenStreetMap contributors',
                  onSourceTapped: () {},
                ),
              ],
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                ),
                MarkerLayer(markers: markers),
              ],
            ),
          Center(child:CustomPaint(
            painter: customStyleArrow(),
          child: Container(
            decoration: BoxDecoration(
               color: AppColors.blackcolor,
           
              borderRadius: BorderRadius.circular(10.0)),
            padding: const EdgeInsets.all(10.0),
            child: Text("Order will be delivered here",
            style: TextStyle(color: AppColors.whitecolor, fontFamily: FONT_FAMILY, fontSize: ScreenUtil().setSp(12.0), fontWeight: FontWeight.normal),
            ),
          ),
          )), 

        ],
      )),
    );
  }
}