/// Konstanta API untuk koneksi ke backend.
class ApiConstants {
  ApiConstants._();

  /// Base URL Laravel API server (auth, follow-ups)
  static const String baseUrl = 'http://192.168.40.89:8000';

  /// Base URL FastAPI Prediction server (Railway)
  static const String predictionBaseUrl = 'https://stress-api-deploy-production.up.railway.app';

  /// Endpoint paths — Laravel
  static const String loginEndpoint = '/api/login';
  static const String registerEndpoint = '/api/register';
  static const String followUpsEndpoint = '/api/follow-ups';
  static const String stressResultsEndpoint = '/api/stress-results';

  /// Endpoint paths — FastAPI (Prediction)
  static const String predictEndpoint = '/predict';

  /// Full URLs — Laravel (Auth & Data)
  static String get loginUrl => '$baseUrl$loginEndpoint';
  static String get registerUrl => '$baseUrl$registerEndpoint';
  static String get followUpsUrl => '$baseUrl$followUpsEndpoint';
  static String get stressResultsUrl => '$baseUrl$stressResultsEndpoint';

  /// Full URL — FastAPI (Prediction)
  static String get predictUrl => '$predictionBaseUrl$predictEndpoint';
}