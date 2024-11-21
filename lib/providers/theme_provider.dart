// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  late ThemeData _currentTheme;
  late Color _accentColor;
  late double _fontSize;
  final SharedPreferences _prefs;

  ThemeProvider(this._prefs) {
    // Initialize with saved preferences
    _fontSize = _prefs.getDouble('fontSize') ?? 16.0;
    _accentColor = Color(_prefs.getInt('accentColor') ?? Colors.deepPurple.value);
    
    // Set initial theme
    _currentTheme = _prefs.getBool('isDarkMode') ?? false 
      ? _buildDarkTheme() 
      : _buildLightTheme();
  }

  ThemeData get currentTheme => _currentTheme;
  Color get accentColor => _accentColor;
  double get fontSize => _fontSize;

  void toggleTheme() {
    _currentTheme = _currentTheme.brightness == Brightness.dark 
      ? _buildLightTheme() 
      : _buildDarkTheme();
    
    _prefs.setBool('isDarkMode', _currentTheme.brightness == Brightness.dark);
    notifyListeners();
  }

  void setAccentColor(Color color) {
    _accentColor = color;
    _prefs.setInt('accentColor', color.value);
    _currentTheme = _currentTheme.brightness == Brightness.dark 
      ? _buildDarkTheme() 
      : _buildLightTheme();
    notifyListeners();
  }

  void setFontSize(double size) {
    _fontSize = size;
    _prefs.setDouble('fontSize', size);
    notifyListeners();
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: MaterialColor(_accentColor.value, {
        50: _accentColor.withOpacity(0.1),
        100: _accentColor.withOpacity(0.2),
        200: _accentColor.withOpacity(0.3),
        300: _accentColor.withOpacity(0.4),
        400: _accentColor.withOpacity(0.5),
        500: _accentColor.withOpacity(0.6),
        600: _accentColor.withOpacity(0.7),
        700: _accentColor.withOpacity(0.8),
        800: _accentColor.withOpacity(0.9),
        900: _accentColor.withOpacity(1),
      }),
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontSize: _fontSize),
        bodyMedium: TextStyle(fontSize: _fontSize * 0.9),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: MaterialColor(_accentColor.value, {
        50: _accentColor.withOpacity(0.1),
        100: _accentColor.withOpacity(0.2),
        200: _accentColor.withOpacity(0.3),
        300: _accentColor.withOpacity(0.4),
        400: _accentColor.withOpacity(0.5),
        500: _accentColor.withOpacity(0.6),
        600: _accentColor.withOpacity(0.7),
        700: _accentColor.withOpacity(0.8),
        800: _accentColor.withOpacity(0.9),
        900: _accentColor.withOpacity(1),
      }),
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontSize: _fontSize),
        bodyMedium: TextStyle(fontSize: _fontSize * 0.9),
      ),
    );
  }
}