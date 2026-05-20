import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

/// Service untuk mengirim hasil prediksi stres ke Laravel API (Post 2).
///
/// Digunakan setelah menerima hasil prediksi dari Railway FastAPI,
/// agar data tersimpan di database Laravel untuk monitoring dosen.
class StressResultService {
  /// Kirim hasil prediksi ke Laravel API.
  ///
  /// Return `true` jika berhasil, `false` jika gagal.
  /// Tidak throw exception — gagal diam-diam agar tidak mengganggu UX.
  static Future<bool> sendPrediction({
    required String nim,
    required String tingkatStres,
    List<String>? topFactors,
    String? recommendation,
    int? predictionRaw,
    double? score,
    double? confidence,
    Map<String, double>? answers,
  }) async {
    try {
      final body = <String, dynamic>{
        'nim': nim,
        'tingkat_stres': tingkatStres,
      };

      if (topFactors != null && topFactors.isNotEmpty) {
        body['top_factors'] = topFactors;
      }
      if (recommendation != null && recommendation.isNotEmpty) {
        body['recommendation'] = recommendation;
      }
      if (predictionRaw != null) {
        body['prediction_raw'] = predictionRaw;
      }
      if (score != null) {
        body['score'] = score;
      }
      if (confidence != null) {
        body['confidence'] = confidence;
      }
      if (answers != null) {
        body['answers'] = answers;
      }

      debugPrint('📤 Sending prediction to Laravel: ${ApiConstants.stressResultsUrl}');
      debugPrint('   Payload: ${jsonEncode(body)}');

      final response = await http
          .post(
            Uri.parse(ApiConstants.stressResultsUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        debugPrint('✅ Prediction saved to Laravel successfully');
        return true;
      } else {
        debugPrint('❌ Laravel responded with ${response.statusCode}: ${response.body}');
        return false;
      }
    } on SocketException catch (e) {
      debugPrint('❌ Network error sending to Laravel: $e');
      return false;
    } catch (e) {
      debugPrint('❌ Error sending prediction to Laravel: $e');
      return false;
    }
  }

  /// Ambil riwayat prediksi dari Laravel berdasarkan NIM.
  ///
  /// Return list of prediction maps, atau empty list jika gagal.
  static Future<List<Map<String, dynamic>>> fetchHistory(String nim) async {
    try {
      final url = '${ApiConstants.stressResultsUrl}?nim=$nim';
      debugPrint('📥 Fetching history from: $url');

      final response = await http
          .get(
            Uri.parse(url),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        if (body['success'] == true) {
          final data = List<Map<String, dynamic>>.from(body['data'] ?? []);
          debugPrint('✅ Fetched ${data.length} history records');
          return data;
        }
      }

      debugPrint('❌ Failed to fetch history: ${response.statusCode}');
      return [];
    } catch (e) {
      debugPrint('❌ Error fetching history: $e');
      return [];
    }
  }
}
