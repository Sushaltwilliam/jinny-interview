import 'package:flutter/material.dart';
import 'package:location_task/const/colors.dart';
import 'package:location_task/provider/location_provider.dart';
import 'package:location_task/screen/locationScreen/location_screen.dart';
import 'package:location_task/services/location_update.dart';
import 'package:provider/provider.dart';

class ResponsiveValueWidget extends StatefulWidget {
  const ResponsiveValueWidget({super.key});

  @override
  State<ResponsiveValueWidget> createState() => _ResponsiveValueWidgetState();
}

class _ResponsiveValueWidgetState extends State<ResponsiveValueWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<LocationProvider>(builder: (context, snap, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            // Determine if the screen is large enough to show a two-column grid
            bool isLargeScreen = constraints.maxWidth > 700;

            return isLargeScreen
                ? GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two columns for large screens
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio:
                          5, // Adjust as needed to control item height
                    ),
                    itemCount: snap.locationList
                        .length, // Update this with the actual count of items
                    itemBuilder: (ctx, index) {
                      return _buildRequestContainer(
                          index, snap.locationList[index]);
                    },
                  )
                : ListView.builder(
                    itemCount: snap.locationList
                        .length, // Update this with the actual count of items
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildRequestContainer(
                            index, snap.locationList[index]),
                      );
                    },
                  );
          },
        );
      }),
    );
  }

  Widget _buildRequestContainer(int index, dynamic value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 80, // Adjust this as needed
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: CustomColors.lightGreyColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Request $index", style: TextStyle(fontSize: 18)),
          Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Text(
                    "Lat : ${value["latitude"]}",
                    style: TextStyle(fontSize: 13),
                  )),
              SizedBox(width: 8),
              Expanded(
                  flex: 2,
                  child: Text(
                    "Lng : ${value["longitude"]}",
                    style: TextStyle(fontSize: 13),
                  )), // Corrected label
              SizedBox(width: 8),
              Expanded(
                  flex: 2,
                  child: Text(
                    "Speed : ${value["speed"].toStringAsFixed(2)}km",
                    style: TextStyle(fontSize: 13),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
