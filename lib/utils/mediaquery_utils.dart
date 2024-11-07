import 'package:flutter/widgets.dart';

class MediaQueryUtil {
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double topPadding(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double bottomPadding(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  static double devicePixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

 
}
