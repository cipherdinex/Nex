import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/services.dart';

class Permissions {
  static Future<bool> cameraAndGalleryPermissionsGranted() async {
    PermissionStatus cameraPermissionStatus = await _getCameraPermission();
    PermissionStatus galleryPermissionStatus = await _getGalleryPermission();

    if (cameraPermissionStatus == PermissionStatus.granted &&
        galleryPermissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      _handleCameraGalleryInvalidPermissions(
          cameraPermissionStatus, galleryPermissionStatus);
      return false;
    }
  }

  static Future<PermissionStatus> _getCameraPermission() async {
    PermissionStatus permission = await Permission.camera.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      PermissionStatus permissionStatus = await Permission.camera.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  static Future<PermissionStatus> _getGalleryPermission() async {
    PermissionStatus permission = await Permission.photos.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      PermissionStatus permissionStatus = await Permission.photos.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  static void _handleCameraGalleryInvalidPermissions(
    PermissionStatus cameraPermissionStatus,
    PermissionStatus galleryPermissionStatus,
  ) {
    if (cameraPermissionStatus == PermissionStatus.denied &&
        galleryPermissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to camera and Photos denied",
          details: null);
    } else if (cameraPermissionStatus == PermissionStatus.denied &&
        galleryPermissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    }
  }
}
