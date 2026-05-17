import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../../features/notification/models/notification_model.dart';

/// Service untuk fetch notifikasi follow-up dari Laravel API.
class NotificationService {
  /// Ambil daftar follow-up untuk student tertentu.
  ///
  /// GET /api/follow-ups?student_id={studentId}
  static Future<List<NotificationModel>> fetchFollowUps({
    required int studentId,
  }) async {
    try {
      final url = '${ApiConstants.followUpsUrl}?student_id=$studentId';

      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'Accept': 'application/json',
            },
          )
          .timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 && body['success'] == true) {
        final dataList = body['data'] as List<dynamic>;
        return dataList
            .map((json) =>
                NotificationModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        final message = body['message']?.toString() ?? 'Gagal memuat notifikasi';
        throw Exception(message);
      }
    } on SocketException {
      throw Exception('Tidak dapat terhubung ke server.');
    } on HttpException {
      throw Exception('Terjadi kesalahan pada server.');
    } on FormatException {
      throw Exception('Response dari server tidak valid.');
    }
  }
}
