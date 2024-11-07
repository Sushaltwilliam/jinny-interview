import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  // Function to request notification permission and show a snackbar
  Future<void> requestNotificationPermission(BuildContext context) async {
    var status = await Permission.notification.status;

    if (!status.isGranted) {
      // If permission is not granted, request it
      status = await Permission.notification.request();
    }

    // Show snackbar based on permission status
    if (status.isGranted) {
      _showSnackbar(context, "Notification permission granted.", Colors.green);
    } else if (status.isDenied) {
      _showSnackbar(context, "Notification permission denied.", Colors.red);
    } else if (status.isPermanentlyDenied) {
      _showSnackbar(
          context,
          "Notification permission permanently denied. Please enable it in settings.",
          Colors.red);
      openAppSettings();
    }
  }

  // Helper function to show a snackbar
  void _showSnackbar(
      BuildContext context, String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(); // Updated class name
    const initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _notifications.initialize(initializationSettings);
  }

  static Future<void> showNotification(
      {required String title, required String body}) async {
    const androidDetails = AndroidNotificationDetails(
      'location_channel', // channelId
      'Location Updates', // channelName
      channelDescription: 'Notification for location updates', // Named argument
      importance: Importance.high,
      priority: Priority.high,  
    );
    const iosDetails = DarwinNotificationDetails(); // Updated class name
    const notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _notifications.show(0, title, body, notificationDetails);
  }
}
