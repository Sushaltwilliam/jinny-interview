  import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location_task/provider/location_provider.dart';
import 'package:provider/provider.dart';

class LocationAlertDialog{


void showConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      if (Platform.isIOS) {
        return CupertinoAlertDialog(
          title: Text("Confirmation"),
          content: Text("Are you sure you want to start location updates?"),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("NO"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text("YES"),
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<LocationProvider>(context, listen: false)
                    .startLocationUpdates(context);
              },
            ),
          ],
        );
      } else {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Are you sure you want to start location updates?"),
          actions: <Widget>[
            TextButton(
              child: Text("NO"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("YES"),
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<LocationProvider>(context, listen: false)
                    .startLocationUpdates(context);
              },
            ),
          ],
        );
      }
    },
  );
}

 void showStopConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Text("Stop Location Updates"),
            content: Text("If you cancel the update, all the data will be cleared. Are you sure?"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("NO"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                child: Text("YES"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Provider.of<LocationProvider>(context, listen: false).stopLocationUpdatesAndClearData();
                },
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: Text("Stop Location Updates"),
            content: Text("If you cancel the update, all the data will be cleared. Are you sure?"),
            actions: <Widget>[
              TextButton(
                child: Text("NO"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("YES"),
                onPressed: () {
                  Navigator.of(context).pop();
                  Provider.of<LocationProvider>(context, listen: false).stopLocationUpdatesAndClearData();
                },
              ),
            ],
          );
        }
      },
    );
  }

}