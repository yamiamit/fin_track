import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;//initially setting it to dark

  ThemeMode get themeMode => _themeMode;//getter for allowing other widgets to access themeMode

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;//most imp if this is a light mode swtich to dark mode
    notifyListeners();// notify all other scrreens regarding the change
  }
}
