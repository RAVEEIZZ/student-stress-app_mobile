/// Konstanta API untuk koneksi ke Laravel backend.
class ApiConstants {
  ApiConstants._();

  /// Base URL Laravel API server
  static const String baseUrl = 'http://10.0.2.2:8000';

  /// Endpoint paths
  static const String loginEndpoint = '/api/login';
  static const String registerEndpoint = '/api/register';
  static const String followUpsEndpoint = '/api/follow-ups';

  /// Full URLs
  static String get loginUrl => '$baseUrl$loginEndpoint';
  static String get registerUrl => '$baseUrl$registerEndpoint';
  static String get followUpsUrl => '$baseUrl$followUpsEndpoint';
}