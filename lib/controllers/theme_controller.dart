import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gixatapp/theme/theme.dart';

class ThemeController extends GetxController {
  final _box = GetStorage(); // Local storage instance
  final _key = 'isDarkMode'; // Key to store the theme preference

  // Observable variable to track the theme state
  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Load the theme state from local storage
    isDarkMode.value = _box.read(_key) ?? false;
    Get.changeTheme(
        isDarkMode.value ? AppThemes.darkTheme : AppThemes.lightTheme);
  }

  // Toggle between light and dark themes
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeTheme(
        isDarkMode.value ? AppThemes.darkTheme : AppThemes.lightTheme);
    _saveTheme(isDarkMode.value);
  }

  // Save the theme state to local storage
  void _saveTheme(bool isDarkMode) {
    _box.write(_key, isDarkMode);
  }
}
