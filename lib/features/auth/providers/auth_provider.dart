import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../../../core/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  String? get error => _error;

  /// Login via Laravel API.
  ///
  /// Return `true` jika login berhasil, `false` jika gagal.
  /// Error message disimpan di [error].
  Future<bool> login(String email, String password) async {
    // Validasi input sebelum kirim ke server
    if (email.isEmpty || password.isEmpty) {
      _error = 'Email dan password harus diisi';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await AuthService.login(
        email: email,
        password: password,
      );

      // Parse user data dari response
      final userData = response['data'] as Map<String, dynamic>;
      _user = UserModel.fromJson(userData);

      _isLoading = false;
      notifyListeners();
      return true;
    } on Exception catch (e) {
      // Hapus prefix "Exception: " dari pesan error
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Register mahasiswa baru via Laravel API.
  ///
  /// Setelah register sukses, user TIDAK otomatis login.
  /// User harus login manual setelah register berhasil.
  Future<bool> register({
    required String nama,
    required String nim,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String nipDosen,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await AuthService.register(
        nama: nama,
        nim: nim,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        nipDosen: nipDosen,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } on Exception catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword(String email, String nim, String password, String passwordConfirmation) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await AuthService.resetPassword(
        email: email,
        nim: nim,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } on Exception catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
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
