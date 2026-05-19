import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

/// Service untuk komunikasi auth dengan Laravel API.
class AuthService {
  /// Login ke Laravel API.
  ///
  /// Mengembalikan Map response body dari server.
  /// Throw [Exception] jika terjadi error jaringan.
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConstants.loginUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && body['success'] == true) {
        return body;
      } else {
        // Server mengembalikan error (401, 422, dll)
        final message = _extractErrorMessage(body, response.statusCode);
        throw Exception(message);
      }
    } on SocketException {
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    } on HttpException {
      throw Exception('Terjadi kesalahan pada server.');
    } on FormatException {
      throw Exception('Response dari server tidak valid.');
    }
  }

  /// Register mahasiswa baru ke Laravel API.
  ///
  /// Mengembalikan Map response body dari server.
  /// Throw [Exception] jika terjadi error jaringan atau validasi.
  static Future<Map<String, dynamic>> register({
    required String nama,
    required String nim,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String nipDosen,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConstants.registerUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'nama': nama,
              'nim': nim,
              'email': email,
              'password': password,
              'password_confirmation': passwordConfirmation,
              'nip_dosen': nipDosen,
            }),
          )
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          body['success'] == true) {
        return body;
      } else {
        final message = _extractErrorMessage(body, response.statusCode);
        throw Exception(message);
      }
    } on SocketException {
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    } on HttpException {
      throw Exception('Terjadi kesalahan pada server.');
    } on FormatException {
      throw Exception('Response dari server tidak valid.');
    }
  }

  /// Reset Password langsung (tanpa link email).
  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConstants.resetPasswordUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'email': email,
              'password': password,
              'password_confirmation': passwordConfirmation,
            }),
          )
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          body['success'] == true) {
        return body;
      } else {
        final message = _extractErrorMessage(body, response.statusCode);
        throw Exception(message);
      }
    } on SocketException {
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda.');
    } on HttpException {
      throw Exception('Terjadi kesalahan pada server.');
    } on FormatException {
      throw Exception('Response dari server tidak valid.');
    }
  }

  /// Extract pesan error dari response Laravel.
  /// Laravel validation error mengembalikan format:
  /// { "message": "...", "errors": { "field": ["error1", "error2"] } }
  static String _extractErrorMessage(Map<String, dynamic> body, int statusCode) {
    // Cek apakah ada validation errors (422)
    if (statusCode == 422 && body.containsKey('errors')) {
      final errors = body['errors'] as Map<String, dynamic>;
      // Ambil pesan error pertama dari field pertama
      final firstField = errors.values.first;
      if (firstField is List && firstField.isNotEmpty) {
        return firstField.first.toString();
      }
    }

    // Fallback ke message utama
    return body['message']?.toString() ?? 'Terjadi kesalahan';
  }
}
