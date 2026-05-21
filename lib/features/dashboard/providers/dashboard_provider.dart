import 'package:flutter/material.dart';
import '../../history/providers/history_provider.dart';

/// Provider dashboard yang mengambil data dari HistoryProvider (real data).
///
/// Tidak lagi menggunakan data hardcoded — semua nilai berasal
/// dari riwayat prediksi yang sudah disimpan di Laravel.
class DashboardProvider extends ChangeNotifier {
  final HistoryProvider _historyProvider;
  String _userName = '';

  DashboardProvider({required HistoryProvider historyProvider})
      : _historyProvider = historyProvider {
    // Listen to changes in HistoryProvider
    _historyProvider.addListener(_onHistoryChanged);
  }

  void _onHistoryChanged() {
    notifyListeners();
  }

  /// Set nama user dari AuthProvider (dipanggil dari DashboardScreen).
  void setUserName(String name) {
    if (_userName != name) {
      _userName = name;
      notifyListeners();
    }
  }

  String get userName => _userName.isNotEmpty ? _userName : 'Mahasiswa';

  int get totalPredictions => _historyProvider.totalPredictions;

  bool get hasPredictions => _historyProvider.predictions.isNotEmpty;

  String get lastPredictionLevel {
    if (_historyProvider.predictions.isEmpty) return '-';
    return _historyProvider.predictions.first['level'] ?? '-';
  }

  double get lastPredictionScore {
    if (_historyProvider.predictions.isEmpty) return 0.0;
    return (_historyProvider.predictions.first['score'] as num?)?.toDouble() ?? 0.0;
  }

  double get lastConfidence {
    if (_historyProvider.predictions.isEmpty) return 0.0;
    return (_historyProvider.predictions.first['confidence'] as num?)?.toDouble() ?? 0.0;
  }

  DateTime get lastPredictionDate {
    if (_historyProvider.predictions.isEmpty) return DateTime.now();
    final date = _historyProvider.predictions.first['date'];
    return date is DateTime ? date : DateTime.now();
  }

  String get insightMessage {
    if (!hasPredictions) {
      return 'Belum ada data prediksi. Lakukan prediksi pertama Anda untuk mendapatkan insight! 📝';
    }
    switch (lastPredictionLevel.toLowerCase()) {
      case 'rendah':
      case 'low':
        return 'Kondisi stres Anda baik! Tetap jaga keseimbangan aktivitas dan istirahat. 🌟';
      case 'sedang':
      case 'moderate':
        return 'Tingkat stres Anda cukup tinggi. Cobalah untuk mengatur waktu istirahat dan aktivitas relaksasi. 🧘';
      case 'tinggi':
      case 'high':
        return 'Tingkat stres Anda tinggi. Sangat disarankan untuk berkonsultasi dengan konselor profesional. ⚠️';
      default:
        return 'Lakukan prediksi untuk mendapatkan insight.';
    }
  }

  /// 3 prediksi terbaru dari riwayat nyata.
  List<Map<String, dynamic>> get recentPredictions {
    final preds = _historyProvider.predictions;
    if (preds.isEmpty) return [];
    return preds.take(3).toList();
  }

  @override
  void dispose() {
    _historyProvider.removeListener(_onHistoryChanged);
    super.dispose();
  }
}
