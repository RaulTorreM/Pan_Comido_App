import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class LoginController extends ChangeNotifier {
  bool isLoading = false;
  final ApiService _apiService = ApiService();

  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.login(email, password);

      if (response['token'] != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('api_token', response['token']);
        isLoading = false;
        notifyListeners();
        return true;
      } else {
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _apiService.logout();
  }

  static Future<void> clearLocalToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('api_token');
  }
}
