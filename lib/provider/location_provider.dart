import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_task/const/colors.dart';
import 'package:location_task/model/button_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/notification_services.dart';

class LocationProvider with ChangeNotifier {
  final List<ButtonModel> _allButtonModel = [
    ButtonModel(
        id: "1",
        name: "Request Location Permission",
        buttonColor: CustomColors.blueButton,
        fontColor: CustomColors.appBarFontColor),
    ButtonModel(
        id: "2",
        name: "Request Notification Permission",
        buttonColor: CustomColors.yellowButton,
        fontColor: CustomColors.appBarColor),
    ButtonModel(
        id: "3",
        name: "Start Location Update",
        buttonColor: CustomColors.greenButton,
        fontColor: CustomColors.appBarFontColor),
    ButtonModel(
        id: "4",
        name: "Stop Location Update",
        buttonColor: CustomColors.redButton,
        fontColor: CustomColors.appBarFontColor),
  ];
  List<ButtonModel> get allButtonModels => _allButtonModel;

  List<Map<String, double>> _locationList = [];
  Timer? _locationUpdateTimer;

  List<Map<String, double>> get locationList => _locationList;

  LocationProviders() {
    _loadLocationsFromPreferences();
  }

  Future<void> _loadLocationsFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedLocations = prefs.getStringList('locations');
    if (savedLocations != null) {
      _locationList = savedLocations
          .map((loc) => Map<String, double>.from(jsonDecode(loc)))
          .toList();
      notifyListeners();
    }
  }

  Future<void> _saveLocationsToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> locationStrings =
        _locationList.map((loc) => jsonEncode(loc)).toList();
    await prefs.setStringList('locations', locationStrings);
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
    await NotificationService.showNotification(
                  title: "Location Update",
                  body: "Location updated successfully",
                );

    _locationUpdateTimer?.cancel();
    _locationUpdateTimer = Timer.periodic(Duration(seconds: 5), (_) async {
      Position position = await Geolocator.getCurrentPosition();

      Map<String, double> locationData = {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'speed': position.speed,
      };
      print(locationData);
      _locationList.add(locationData);
      await _saveLocationsToPreferences();
      notifyListeners();
    });
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

  void stopLocationUpdatesAndClearData() {
  _locationUpdateTimer?.cancel();
  _locationList.clear(); // Clear the stored locations
  _saveLocationsToPreferences(); // Update SharedPreferences
  notifyListeners();
}
}
