import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      final request = LoginRequest(email: email, password: password);
      final response = await ApiService.login(request);
      _user = response.user;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    _setLoading(true);
    _setError(null);

    try {
      final request = UserCreateRequest(
        username: username,
        email: email,
        password: password,
      );
      final response = await ApiService.register(request);
      _user = response.user;
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  Future<bool> checkAuth() async {
    _setLoading(true);
    
    try {
      _user = await ApiService.getCurrentUser();
      _setLoading(false);
      return _user != null;
    } catch (e) {
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await ApiService.logout();
    _user = null;
    _setError(null);
    notifyListeners();
  }

  void clearError() {
    _setError(null);
  }
}
