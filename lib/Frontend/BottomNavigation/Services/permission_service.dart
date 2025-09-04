import 'package:chem_earth_app/utils/import_export.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

/// Enum for permission types (Open/Closed Principle)
enum AppPermissionType {
  microphone,
  notification,
  camera,
  storage,
  location,
}

/// Permission result model (Single Responsibility Principle)
class PermissionResult {
  final PermissionStatus status;
  final String message;
  final bool isGranted;
  final bool isPermanentlyDenied;

  const PermissionResult({
    required this.status,
    required this.message,
    required this.isGranted,
    required this.isPermanentlyDenied,
  });

  factory PermissionResult.granted() => const PermissionResult(
        status: PermissionStatus.granted,
        message: 'Permission granted',
        isGranted: true,
        isPermanentlyDenied: false,
      );

  factory PermissionResult.denied() => const PermissionResult(
        status: PermissionStatus.denied,
        message: 'Permission denied',
        isGranted: false,
        isPermanentlyDenied: false,
      );

  factory PermissionResult.permanentlyDenied() => const PermissionResult(
        status: PermissionStatus.permanentlyDenied,
        message: 'Permission permanently denied',
        isGranted: false,
        isPermanentlyDenied: true,
      );

  factory PermissionResult.restricted() => const PermissionResult(
        status: PermissionStatus.restricted,
        message: 'Permission restricted',
        isGranted: false,
        isPermanentlyDenied: false,
      );
}

/// Enhanced permission service interface (Interface Segregation Principle)
abstract class IEnhancedPermissionService {
  Future<PermissionResult> checkPermission(AppPermissionType permissionType);
  Future<PermissionResult> requestPermission(AppPermissionType permissionType);
  Future<Map<AppPermissionType, PermissionResult>> checkMultiplePermissions(
      List<AppPermissionType> permissionTypes);
  Future<Map<AppPermissionType, PermissionResult>> requestMultiplePermissions(
      List<AppPermissionType> permissionTypes);
  Future<bool> openAppSettings();
  Future<bool> shouldShowRequestPermissionRationale(AppPermissionType permissionType);
}

/// Enhanced permission service implementation
class EnhancedPermissionService implements IEnhancedPermissionService {
  
  /// Maps app permission types to permission_handler Permission objects
  static final Map<AppPermissionType, Permission> _permissionMap = {
    AppPermissionType.microphone: Permission.microphone,
    AppPermissionType.notification: Permission.notification,
    AppPermissionType.camera: Permission.camera,
    AppPermissionType.storage: Permission.storage,
    AppPermissionType.location: Permission.location,
  };

  @override
  Future<PermissionResult> checkPermission(AppPermissionType permissionType) async {
    try {
      final permission = _permissionMap[permissionType];
      if (permission == null) {
        return PermissionResult.denied();
      }

      final status = await permission.status;
      return _mapStatusToResult(status);
    } catch (e) {
      return PermissionResult.denied();
    }
  }

  @override
  Future<PermissionResult> requestPermission(AppPermissionType permissionType) async {
    try {
      final permission = _permissionMap[permissionType];
      if (permission == null) {
        return PermissionResult.denied();
      }

      final status = await permission.request();
      return _mapStatusToResult(status);
    } catch (e) {
      return PermissionResult.denied();
    }
  }

  @override
  Future<Map<AppPermissionType, PermissionResult>> checkMultiplePermissions(
      List<AppPermissionType> permissionTypes) async {
    final results = <AppPermissionType, PermissionResult>{};
    
    for (final permissionType in permissionTypes) {
      results[permissionType] = await checkPermission(permissionType);
    }
    
    return results;
  }

  @override
  Future<Map<AppPermissionType, PermissionResult>> requestMultiplePermissions(
      List<AppPermissionType> permissionTypes) async {
    final results = <AppPermissionType, PermissionResult>{};
    
    // Convert to Permission objects for batch request
    final permissions = permissionTypes
        .map((type) => _permissionMap[type])
        .where((p) => p != null)
        .cast<Permission>()
        .toList();

    try {
      final statuses = await permissions.request();
      
      // Map results back to AppPermissionType
      for (int i = 0; i < permissionTypes.length; i++) {
        final permissionType = permissionTypes[i];
        final permission = _permissionMap[permissionType];
        if (permission != null && statuses.containsKey(permission)) {
          results[permissionType] = _mapStatusToResult(statuses[permission]!);
        } else {
          results[permissionType] = PermissionResult.denied();
        }
      }
    } catch (e) {
      // If batch request fails, fallback to individual requests
      for (final permissionType in permissionTypes) {
        results[permissionType] = await requestPermission(permissionType);
      }
    }
    
    return results;
  }

  @override
  Future<bool> openAppSettings() async {
    try {
      return await ph.openAppSettings();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> shouldShowRequestPermissionRationale(AppPermissionType permissionType) async {
    try {
      final permission = _permissionMap[permissionType];
      if (permission == null) return false;

      return await permission.shouldShowRequestRationale;
    } catch (e) {
      return false;
    }
  }

  /// Maps PermissionStatus to PermissionResult
  PermissionResult _mapStatusToResult(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return PermissionResult.granted();
      case PermissionStatus.denied:
        return PermissionResult.denied();
      case PermissionStatus.permanentlyDenied:
        return PermissionResult.permanentlyDenied();
      case PermissionStatus.restricted:
        return PermissionResult.restricted();
      case PermissionStatus.limited:
        return PermissionResult.denied();
      case PermissionStatus.provisional:
        return PermissionResult.denied();
    }
  }
}

/// Permission manager for handling common permission operations
class PermissionManager {
  static final IEnhancedPermissionService _permissionService = 
      EnhancedPermissionService();

  /// Check if permission is granted
  static Future<bool> isPermissionGranted(AppPermissionType permissionType) async {
    final result = await _permissionService.checkPermission(permissionType);
    return result.isGranted;
  }

  /// Request permission with proper error handling
  static Future<PermissionResult> requestPermissionSafely(
      AppPermissionType permissionType) async {
    try {
      return await _permissionService.requestPermission(permissionType);
    } catch (e) {
      return PermissionResult.denied();
    }
  }

  /// Check multiple permissions at once
  static Future<bool> arePermissionsGranted(
      List<AppPermissionType> permissionTypes) async {
    final results = await _permissionService.checkMultiplePermissions(permissionTypes);
    return results.values.every((result) => result.isGranted);
  }

  /// Request multiple permissions at once
  static Future<Map<AppPermissionType, PermissionResult>> requestMultiplePermissions(
      List<AppPermissionType> permissionTypes) async {
    return await _permissionService.requestMultiplePermissions(permissionTypes);
  }

  /// Open app settings
  static Future<bool> openSettings() async {
    return await _permissionService.openAppSettings();
  }

  /// Show rationale for permission request
  static Future<bool> shouldShowRationale(AppPermissionType permissionType) async {
    return await _permissionService.shouldShowRequestPermissionRationale(permissionType);
  }
}
