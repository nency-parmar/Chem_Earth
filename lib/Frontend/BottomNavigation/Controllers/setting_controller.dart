import 'package:chem_earth_app/utils/import_export.dart';

/// Interface for theme management (Interface Segregation Principle)
abstract class IThemeService {
  ThemeMode get currentTheme;
  void changeTheme(ThemeMode themeMode);
}

/// Concrete implementation of theme service
class ThemeService implements IThemeService {
  @override
  ThemeMode get currentTheme => Get.isDarkMode ? ThemeMode.dark : ThemeMode.light;

  @override
  void changeTheme(ThemeMode themeMode) {
    Get.changeThemeMode(themeMode);
  }
}

/// Enhanced Settings Controller following SOLID principles
class SettingsController extends GetxController {
  final IThemeService _themeService;
  late PermissionController _permissionController;
  
  // Constructor injection (Dependency Inversion)
  SettingsController({IThemeService? themeService}) 
      : _themeService = themeService ?? ThemeService();

  // Observable states
  final _isDarkMode = Get.isDarkMode.obs;

  // Getters
  bool get isDarkMode => _isDarkMode.value;

  @override
  void onInit() {
    super.onInit();
    // Initialize permission controller
    _permissionController = Get.put(PermissionController());
    _isDarkMode.value = Get.isDarkMode;
  }

  /// Toggle theme between light and dark mode (Single Responsibility)
  void toggleTheme(bool value) {
    _isDarkMode.value = value;
    final themeMode = value ? ThemeMode.dark : ThemeMode.light;
    _themeService.changeTheme(themeMode);
    
    // Provide user feedback
    Get.snackbar(
      'Theme Changed',
      value ? 'Dark mode enabled' : 'Light mode enabled',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: value ? Colors.grey[800] : Colors.white,
      colorText: value ? Colors.white : Colors.black,
      duration: const Duration(seconds: 1),
    );
  }

  /// Navigate to microphone permission page
  void navigateToMicrophonePermission() {
    Get.to(() => const MicrophonePermissionPage());
  }

  /// Navigate to notification permission page
  void navigateToNotificationPermission() {
    Get.to(() => const NotificationPermissionPage());
  }

  /// Get permission status text for display
  String getPermissionStatusText(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return 'Granted';
      case PermissionStatus.denied:
        return 'Denied';
      case PermissionStatus.permanentlyDenied:
        return 'Denied';
      case PermissionStatus.restricted:
        return 'Restricted';
      default:
        return 'Unknown';
    }
  }

  /// Get permission status color for display
  Color getPermissionStatusColor(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return Colors.green;
      case PermissionStatus.denied:
        return Colors.orange;
      case PermissionStatus.permanentlyDenied:
        return Colors.red;
      case PermissionStatus.restricted:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  void onClose() {
    // Clean up resources if needed
    super.onClose();
  }
}
