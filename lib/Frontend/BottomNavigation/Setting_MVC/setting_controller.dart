import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  var isDarkMode = Get.isDarkMode.obs;
  var selectedLanguage = const Locale('en', 'US').obs;

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void changeLanguage(String? langCode) {
    if (langCode == null) return;

    if (langCode == 'en') {
      selectedLanguage.value = const Locale('en', 'US');
    } else if (langCode == 'hi') {
      selectedLanguage.value = const Locale('hi', 'IN');
    } else if (langCode == 'gu') {
      selectedLanguage.value = const Locale('gu', 'IN');
    }

    Get.updateLocale(selectedLanguage.value);
  }

}