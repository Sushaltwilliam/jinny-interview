import 'package:flutter/material.dart';
import 'package:location_task/const/colors.dart';
import 'package:location_task/screen/widget/response_value.dart';
import 'package:location_task/screen/widget/responsive_button_widget.dart';
import 'package:location_task/utils/mediaquery_utils.dart';

class LocationUpdateScreen extends StatefulWidget {
  const LocationUpdateScreen({super.key});

  @override
  State<LocationUpdateScreen> createState() => _LocationUpdateScreenState();
}

class _LocationUpdateScreenState extends State<LocationUpdateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.appBarColor,
        title: const Text(
          "Test App",
          style: TextStyle(color: CustomColors.appBarFontColor),
        ),
      ),
      body: Column(
        children: [
          ResponsiveButton(),
         ResponsiveValueWidget(),
        ],
      ),
    );
  }
}
