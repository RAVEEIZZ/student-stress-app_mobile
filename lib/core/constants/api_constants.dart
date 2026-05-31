import 'package:flutter/foundation.dart' show kIsWeb;

/// Konstanta API untuk koneksi ke backend.
class ApiConstants {
  ApiConstants._();

  /// Base URL Laravel API server (auth, follow-ups)
  /// 10.0.2.2 untuk Android emulator, localhost untuk web/desktop
  static String get baseUrl => kIsWeb
      ? 'http://192.168.100.144:8000'
      : 'http://192.168.100.144:8000';

  /// Endpoint paths — Laravel
  static const String loginEndpoint = '/api/login';
  static const String registerEndpoint = '/api/register';
  static const String resetPasswordEndpoint = '/api/reset-password';
  static const String followUpsEndpoint = '/api/follow-ups';
  static const String stressResultsEndpoint = '/api/stress-results';
  static const String railwayProxyEndpoint = '/api/railway'; // Laravel proxy to Railway

  /// Full URLs — Laravel (Auth & Data)
  static String get loginUrl => '$baseUrl$loginEndpoint';
  static String get registerUrl => '$baseUrl$registerEndpoint';
  static String get resetPasswordUrl => '$baseUrl$resetPasswordEndpoint';
  static String get followUpsUrl => '$baseUrl$followUpsEndpoint';
  static String get stressResultsUrl => '$baseUrl$stressResultsEndpoint';

  /// Full URL — Prediction via Laravel Proxy (CORS-safe)
  /// Laravel akan forward ke Railway: /api/railway/predict → Railway /predict
  static String get predictUrl => '$baseUrl$railwayProxyEndpoint/predict';
}