import 'package:flutter/foundation.dart' show kIsWeb;

/// Konstanta API untuk koneksi ke backend.
class ApiConstants {
  ApiConstants._();

  /// Base URL Laravel API server (auth, follow-ups)
  /// 10.0.2.2 untuk Android emulator, localhost untuk web/desktop
  static String get baseUrl => kIsWeb
      ? 'http://10.15.156.99:8000'
      : 'http://10.15.156.99:8000';

  /// Base URL FastAPI Prediction server (Railway)
  static const String predictionBaseUrl = 'https://stress-api-deploy-production.up.railway.app';

  /// Endpoint paths — Laravel
  static const String loginEndpoint = '/api/login';
  static const String registerEndpoint = '/api/register';
  static const String resetPasswordEndpoint = '/api/reset-password';
  static const String followUpsEndpoint = '/api/follow-ups';
  static const String stressResultsEndpoint = '/api/stress-results';

  /// Endpoint paths — FastAPI (Prediction)
  static const String predictEndpoint = '/predict';

  /// Full URLs — Laravel (Auth & Data)
  static String get loginUrl => '$baseUrl$loginEndpoint';
  static String get registerUrl => '$baseUrl$registerEndpoint';
  static String get resetPasswordUrl => '$baseUrl$resetPasswordEndpoint';
  static String get followUpsUrl => '$baseUrl$followUpsEndpoint';
  static String get stressResultsUrl => '$baseUrl$stressResultsEndpoint';

  /// Full URL — FastAPI (Prediction)
  static String get predictUrl => '$predictionBaseUrl$predictEndpoint';
}