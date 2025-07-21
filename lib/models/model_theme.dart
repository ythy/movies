import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  Color seedColor = Color(0xFF006A60);  //Color(0xFF00BBD4)
  Brightness brightness = Brightness.dark;

  void setColor(Color newColor) {
    seedColor = newColor;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void switchBrightness() {
    brightness = brightness == Brightness.dark ? Brightness.light : Brightness.dark;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

}