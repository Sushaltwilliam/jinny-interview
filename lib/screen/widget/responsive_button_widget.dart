import 'package:flutter/material.dart';
import 'package:location_task/const/colors.dart';
import 'package:location_task/model/button_model.dart';
import 'package:location_task/screen/widget/location_alert_dialog.dart';
import 'package:location_task/services/location_services.dart';
import 'package:location_task/services/location_update.dart';
import 'package:location_task/services/notification_services.dart';
import 'package:location_task/utils/mediaquery_utils.dart';
import 'package:provider/provider.dart';

import '../../provider/location_provider.dart';

class ResponsiveButton extends StatefulWidget {
  @override
  State<ResponsiveButton> createState() => _ResponsiveButtonState();
}

class _ResponsiveButtonState extends State<ResponsiveButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQueryUtil.screenHeight(context) * 0.33,
      color: CustomColors.appBarColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use a threshold width to decide between one or two columns
          bool isLargeScreen = constraints.maxWidth > 600;

          return Consumer<LocationProvider>(builder: (context, snap, _) {
            if (isLargeScreen) {
              // Display in a grid with two columns for larger screens
              return GridView.builder(
                itemCount: snap.allButtonModels.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio:
                      5, // Adjust as needed to control item height
                ),
                itemBuilder: (ctx, index) {
                  return _buildButtonContainer(
                      snap.allButtonModels[index], context);
                },
              );
            } else {
              // Display in a single-column list for smaller screens
              return ListView.builder(
                itemCount: snap.allButtonModels.length,
                itemBuilder: (ctx, index) {
                  return _buildButtonContainer(
                      snap.allButtonModels[index], context);
                },
              );
            }
          });
        },
      ),
    );
  }

  // Function to build the container for each button
  Widget _buildButtonContainer(ButtonModel buttonModel, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (buttonModel.id == "1") {
          await LocationService().requestLocationPermission(context);
        } else if (buttonModel.id == "2") {
          await NotificationService().requestNotificationPermission(context);
        } else if (buttonModel.id == "3") {
          LocationAlertDialog().showConfirmationDialog(context);
        } else if (buttonModel.id == "4") {
          LocationAlertDialog().showStopConfirmationDialog(context);
        }
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        height: 50,
        decoration: BoxDecoration(
          color: buttonModel.buttonColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            buttonModel.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: buttonModel.fontColor,
            ),
          ),
        ),
      ),
    );
  }
}
