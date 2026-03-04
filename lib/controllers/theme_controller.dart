import 'package:get/get.dart';

class ThemeController extends GetxController {
  final RxBool isDarkMode = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    loadThemePreference();
  }

  void loadThemePreference() {
    // You can load theme preference from Hive
    // isDarkMode.value = HiveService.getSetting('isDarkMode', defaultValue: false);
  }

  void toggleTheme() {
    isDarkMode.toggle();
    // Save preference
    // HiveService.saveSetting('isDarkMode', isDarkMode.value);
  }

  void setDarkMode(bool isDark) {
    isDarkMode.value = isDark;
    // HiveService.saveSetting('isDarkMode', isDark);
  }
}
