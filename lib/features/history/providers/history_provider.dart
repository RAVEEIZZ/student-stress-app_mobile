import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../core/services/stress_result_service.dart';

/// Provider untuk mengelola riwayat prediksi stres.
///
/// Data diambil dari Laravel API berdasarkan NIM mahasiswa yang login.
/// History di mobile kosong sampai user melakukan prediksi baru.
class HistoryProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _predictions = [];
  bool _isLoading = false;
  bool _hasFetched = false;
  String? _error;

  List<Map<String, dynamic>> get predictions => _predictions;
  bool get isLoading => _isLoading;
  bool get hasFetched => _hasFetched;
  String? get error => _error;

  int get totalPredictions => _predictions.length;

  int get lowCount =>
      _predictions.where((p) => _isLevel(p, 'low')).length;
  int get mediumCount =>
      _predictions.where((p) => _isLevel(p, 'moderate')).length;
  int get highCount =>
      _predictions.where((p) => _isLevel(p, 'high')).length;

  /// Fetch riwayat prediksi dari Laravel API.
  ///
  /// [nim] NIM mahasiswa yang login untuk filter data.
  Future<void> fetchHistory(String nim) async {
    if (nim.isEmpty) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await StressResultService.fetchHistory(nim);

      // Transform data dari format Laravel API ke format yang digunakan UI
      _predictions = data.map((item) {
        Map<String, double> categories = {
          'Akademik': 0,
          'Fisik': 0,
          'Psikologis': 0,
          'Sosial': 0,
        };
        
        if (item['answers'] != null) {
          try {
            final parsed = item['answers'] is String 
                ? jsonDecode(item['answers']) 
                : item['answers'];
                
            if (parsed is Map) {
              parsed.forEach((k, v) {
                categories[k.toString()] = (v as num).toDouble();
              });
            }
          } catch (e) {
            debugPrint('Error parsing answers in history: $e');
          }
        }

        return <String, dynamic>{
          'id': item['id']?.toString() ?? '',
          'date': DateTime.tryParse(item['created_at'] ?? '') ?? DateTime.now(),
          'level': _mapLevelToIndonesian(item['tingkat_stres'] ?? ''),
          'score': (item['score'] as num?)?.toDouble() ?? 0.0,
          'confidence': (item['confidence'] as num?)?.toDouble() ?? 0.0,
          'top_factors': item['top_factors'],
          'recommendation': item['recommendation'],
          'categories': categories,
        };
      }).toList();

      _hasFetched = true;
    } catch (e) {
      _error = 'Gagal memuat riwayat: $e';
      debugPrint('❌ HistoryProvider fetch error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Refresh data (pull-to-refresh)
  Future<void> refresh(String nim) async {
    await fetchHistory(nim);
  }

  /// Kosongkan riwayat lokal (setelah reset form).
  void clear() {
    _predictions = [];
    _hasFetched = false;
    _error = null;
    notifyListeners();
  }

  /// Map level dari API (English) ke Bahasa Indonesia untuk UI.
  String _mapLevelToIndonesian(String level) {
    switch (level.toLowerCase()) {
      case 'low':
        return 'Rendah';
      case 'moderate':
        return 'Sedang';
      case 'high':
        return 'Tinggi';
      default:
        return level;
    }
  }

  /// Cek apakah item cocok dengan level tertentu (case-insensitive).
  bool _isLevel(Map<String, dynamic> p, String level) {
    final itemLevel = (p['level'] ?? '').toString().toLowerCase();
    final targetLevel = level.toLowerCase();

    // Support both Indonesian and English level names
    switch (targetLevel) {
      case 'low':
        return itemLevel == 'low' || itemLevel == 'rendah';
      case 'moderate':
        return itemLevel == 'moderate' || itemLevel == 'sedang';
      case 'high':
        return itemLevel == 'high' || itemLevel == 'tinggi';
      default:
        return itemLevel == targetLevel;
    }
  }
}
