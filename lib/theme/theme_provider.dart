import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isLightMode = false;

  bool get isLightMode => _isLightMode;
  ThemeProvider() {
    _loadTheme();
  }
  _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getBool('theme') ?? false;
    _isLightMode = theme;
    notifyListeners();
  }

  void toggleTheme() async {
    _isLightMode = !isLightMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('theme', _isLightMode);
    notifyListeners();
  }
}