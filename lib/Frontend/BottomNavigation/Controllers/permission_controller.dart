import 'package:chem_earth_app/utils/import_export.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

/// Interface for permission handling (Dependency Inversion Principle)
abstract class IPermissionService {
  Future<PermissionStatus> checkPermission(Permission permission);
  Future<PermissionStatus> requestPermission(Permission permission);
  Future<bool> openAppSettings();
}

/// Concrete implementation of permission service
class PermissionService implements IPermissionService {
  @override
  Future<PermissionStatus> checkPermission(Permission permission) async {
    return await permission.status;
  }

  @override
  Future<PermissionStatus> requestPermission(Permission permission) async {
    return await permission.request();
  }

  @override
  Future<bool> openAppSettings() async {
    return await ph.openAppSettings();
  }
}

/// Permission Controller following SOLID principles
class PermissionController extends GetxController {
  final IPermissionService _permissionService;
  
  // Constructor injection (Dependency Inversion)
  PermissionController({IPermissionService? permissionService}) 
      : _permissionService = permissionService ?? PermissionService();

  // Observable states
  final _microphonePermissionStatus = PermissionStatus.denied.obs;
  final _notificationPermissionStatus = PermissionStatus.denied.obs;
  final _isLoading = false.obs;

  // Getters
  PermissionStatus get microphonePermissionStatus => _microphonePermissionStatus.value;
  PermissionStatus get notificationPermissionStatus => _notificationPermissionStatus.value;
  bool get isLoading => _isLoading.value;

  // Computed properties
  bool get isMicrophoneGranted => _microphonePermissionStatus.value == PermissionStatus.granted;
  bool get isNotificationGranted => _notificationPermissionStatus.value == PermissionStatus.granted;
  
  String get microphoneStatusText {
    switch (_microphonePermissionStatus.value) {
      case PermissionStatus.granted:
        return 'Granted';
      case PermissionStatus.denied:
        return 'Denied';
      case PermissionStatus.permanentlyDenied:
        return 'Permanently Denied';
      case PermissionStatus.restricted:
        return 'Restricted';
      default:
        return 'Unknown';
    }
  }

  String get notificationStatusText {
    switch (_notificationPermissionStatus.value) {
      case PermissionStatus.granted:
        return 'Granted';
      case PermissionStatus.denied:
        return 'Denied';
      case PermissionStatus.permanentlyDenied:
        return 'Permanently Denied';
      case PermissionStatus.restricted:
        return 'Restricted';
      default:
        return 'Unknown';
    }
  }

  @override
  void onInit() {
    super.onInit();
    _checkAllPermissions();
  }

  /// Check all permissions status (Single Responsibility)
  Future<void> _checkAllPermissions() async {
    await _checkMicrophonePermission();
    await _checkNotificationPermission();
  }

  /// Check microphone permission status
  Future<void> _checkMicrophonePermission() async {
    try {
      final status = await _permissionService.checkPermission(Permission.microphone);
      _microphonePermissionStatus.value = status;
    } catch (e) {
      _showErrorSnackbar('Failed to check microphone permission');
    }
  }

  /// Check notification permission status
  Future<void> _checkNotificationPermission() async {
    try {
      final status = await _permissionService.checkPermission(Permission.notification);
      _notificationPermissionStatus.value = status;
    } catch (e) {
      _showErrorSnackbar('Failed to check notification permission');
    }
  }

  /// Request microphone permission
  Future<void> requestMicrophonePermission() async {
    if (_isLoading.value) return;
    
    _isLoading.value = true;
    try {
      final status = await _permissionService.requestPermission(Permission.microphone);
      _microphonePermissionStatus.value = status;
      
      if (status == PermissionStatus.granted) {
        _showSuccessSnackbar('Microphone permission granted');
      } else if (status == PermissionStatus.permanentlyDenied) {
        _showPermanentlyDeniedDialog('Microphone');
      } else {
        _showErrorSnackbar('Microphone permission denied');
      }
    } catch (e) {
      _showErrorSnackbar('Failed to request microphone permission');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Request notification permission
  Future<void> requestNotificationPermission() async {
    if (_isLoading.value) return;
    
    _isLoading.value = true;
    try {
      final status = await _permissionService.requestPermission(Permission.notification);
      _notificationPermissionStatus.value = status;
      
      if (status == PermissionStatus.granted) {
        _showSuccessSnackbar('Notification permission granted');
      } else if (status == PermissionStatus.permanentlyDenied) {
        _showPermanentlyDeniedDialog('Notification');
      } else {
        _showErrorSnackbar('Notification permission denied');
      }
    } catch (e) {
      _showErrorSnackbar('Failed to request notification permission');
    } finally {
      _isLoading.value = false;
    }
  }

  /// Open app settings for permanently denied permissions
  Future<void> openAppSettings() async {
    try {
      final opened = await _permissionService.openAppSettings();
      if (!opened) {
        _showErrorSnackbar('Could not open app settings');
      }
    } catch (e) {
      _showErrorSnackbar('Failed to open app settings');
    }
  }

  /// Refresh all permission statuses
  Future<void> refreshPermissions() async {
    _isLoading.value = true;
    await _checkAllPermissions();
    _isLoading.value = false;
    _showSuccessSnackbar('Permissions refreshed');
  }

  // Helper methods for UI feedback
  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 2),
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      icon: const Icon(Icons.error, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  void _showPermanentlyDeniedDialog(String permissionType) {
    Get.dialog(
      AlertDialog(
        title: Text('$permissionType Permission Required'),
        content: Text(
          '$permissionType permission has been permanently denied. Please enable it in app settings to use this feature.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
