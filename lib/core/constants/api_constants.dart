/// Konstanta API untuk koneksi ke Laravel backend.
class ApiConstants {
  ApiConstants._();

  /// Base URL Laravel API server
  static const String baseUrl = 'http://10.0.2.2:8000';

  /// Endpoint paths
  static const String loginEndpoint = '/api/login';
  static const String registerEndpoint = '/api/register';

  /// Full URLs
  static String get loginUrl => '$baseUrl$loginEndpoint';
  static String get registerUrl => '$baseUrl$registerEndpoint';
}