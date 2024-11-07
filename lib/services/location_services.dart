import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  // Function to request location permission and show a snackbar
  Future<void> requestLocationPermission(BuildContext context) async {
    var status = await Permission.location.status;

    if (!status.isGranted) {
      // If permission is not granted, request it
      status = await Permission.location.request();
    }

    // Show snackbar based on permission status
    if (status.isGranted) {
      _showSnackbar(context, "Location permission granted.",Colors.green);
    } else if (status.isDenied) {
      _showSnackbar(context, "Location permission denied.",Colors.red);
    } else if (status.isPermanentlyDenied) {
      _showSnackbar(context, "Location permission permanently denied. Please enable it in settings.",Colors.red);
      openAppSettings();
    }
  }

  // Helper function to show a snackbar
  void _showSnackbar(BuildContext context, String message,Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
