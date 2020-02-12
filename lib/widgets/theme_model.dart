import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class ThemeModel extends StatesRebuilder {
  Brightness brightness = Brightness.dark;
  String sender = "Dark";
  String receiver = "Light";
  bool isDark = true;
  int count = 0;
  void changeBrightness() {
    brightness = isDark ? Brightness.light : Brightness.dark;
    isDark = brightness == Brightness.dark;
    sender = isDark ? "Dark" : "Light";
    receiver = isDark ? "Light" : "Dark";
    rebuildStates();
  }

  void increment() {
    count++;
    rebuildStates();
  }
}
