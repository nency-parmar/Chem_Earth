import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  // Default to light mode
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    update(); // Notify GetBuilder
  }

  void setSystemDefault() {
    _themeMode = ThemeMode.system;
    update();
  }
}
