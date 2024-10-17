import 'package:flutter/material.dart';
import 'app_theme.dart'; // Ensure you have this import for AppTheme

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false; // Private variable to track the dark mode state

  // Method to toggle the theme
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Notify listeners to rebuild widgets that depend on this state
  }

  // Getter method to check if dark mode is enabled
  bool get isDarkMode => _isDarkMode;

  // Method to get the current theme based on the mode
  ThemeData getTheme() => _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
}
