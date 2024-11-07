import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationUpdateService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Timer? _locationUpdateTimer;
  List<Map<String, double>> locationList = [];

  LocationService() {
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    // const initializationSettingsIOS = IOSInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> startLocationUpdates(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showSnackbar(context, "Location services are disabled.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackbar(context, "Location permission denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showSnackbar(context, "Location permission is permanently denied.");
      openAppSettings();
      return;
    }

    // _showNotification("Location update started");

    _locationUpdateTimer?.cancel();
    _locationUpdateTimer = Timer.periodic(Duration(seconds: 30), (_) async {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      Map<String, double> locationData = {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };

      locationList.add(locationData);
      await _saveLocationsToPreferences();
      _showSnackbar(context, "Location updated: Lat ${position.latitude}, Long ${position.longitude}");
    });
  }



  Future<void> _saveLocationsToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> locationStrings = locationList.map((loc) => jsonEncode(loc)).toList();
    await prefs.setStringList('locations', locationStrings);
  }

  Future<List<Map<String, double>>> loadLocationsFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? locationStrings = prefs.getStringList('locations');
    if (locationStrings != null) {
      locationList = locationStrings.map((loc) => Map<String, double>.from(jsonDecode(loc))).toList();
    }
    return locationList;
  }

  void stopLocationUpdates() {
    _locationUpdateTimer?.cancel();
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
