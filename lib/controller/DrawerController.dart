import 'package:get/get.dart';

class DrawerIndexController extends GetxController {
  final currentIndex = 1.obs;
  setIndex(int index) => currentIndex.value = index;
}