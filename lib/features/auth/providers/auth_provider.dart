import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  String? get error => _error;

  // Mock login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (email.isNotEmpty && password.isNotEmpty) {
      _user = UserModel(
        id: '1',
        name: 'Raditya Pratama',
        email: email,
        nim: '2024001234',
        createdAt: DateTime.now(),
      );
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _error = 'Email atau password salah';
    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Mock register
  Future<bool> register({
    required String name,
    required String email,
    required String nim,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _user = UserModel(
      id: '1',
      name: name,
      email: email,
      nim: nim,
      createdAt: DateTime.now(),
    );
    _isLoading = false;
    notifyListeners();
    return true;
  }

  // Mock forgot password
  Future<bool> forgotPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
