import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  static const String _sessionKey = 'user_session';
  static const String _userEmailKey = 'registered_email';
  static const String _userPasswordKey = 'registered_password';

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    
    // Default credentials for testing
    final savedEmail = prefs.getString(_userEmailKey) ?? "admin@investor.com";
    final savedPassword = prefs.getString(_userPasswordKey) ?? "password123";

    if (email == savedEmail && password == savedPassword) {
      await prefs.setBool(_sessionKey, true);
      return true;
    }
    return false;
  }

  Future<bool> register(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email.isNotEmpty && password.length >= 6) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userEmailKey, email);
      await prefs.setString(_userPasswordKey, password);
      await prefs.setBool(_sessionKey, true); // Auto login after registration
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_sessionKey) ?? false;
  }
}
