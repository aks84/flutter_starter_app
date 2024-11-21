// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _username;
  String? _email;

  bool get isAuthenticated => _isAuthenticated;
  String? get username => _username;
  String? get email => _email;

  Future<bool> login(String username, String password) async {
    // Simulate login (replace with actual authentication logic)
    if (username == 'demo' && password == 'password') {
      final prefs = await SharedPreferences.getInstance();
      
      _isAuthenticated = true;
      _username = username;
      _email = '$username@example.com';
      
      // Save login state
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('username', username);
      await prefs.setString('email', _email!);
      
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    
    _isAuthenticated = false;
    _username = null;
    _email = null;
    
    // Clear saved login state
    await prefs.remove('isAuthenticated');
    await prefs.remove('username');
    await prefs.remove('email');
    
    notifyListeners();
  }
}