import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var selectedIndex = 2.obs; // Default to MainPage

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
