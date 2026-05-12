import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  String get userName => 'Raditya';
  int get totalPredictions => 12;
  String get lastPredictionLevel => 'Sedang';
  double get lastPredictionScore => 65.4;
  double get lastConfidence => 87.2;
  DateTime get lastPredictionDate => DateTime.now().subtract(const Duration(days: 1));

  String get insightMessage {
    switch (lastPredictionLevel.toLowerCase()) {
      case 'rendah':
        return 'Kondisi stres Anda baik! Tetap jaga keseimbangan aktivitas dan istirahat. 🌟';
      case 'sedang':
        return 'Tingkat stres Anda cukup tinggi. Cobalah untuk mengatur waktu istirahat dan aktivitas relaksasi. 🧘';
      case 'tinggi':
        return 'Tingkat stres Anda tinggi. Sangat disarankan untuk berkonsultasi dengan konselor profesional. ⚠️';
      default:
        return 'Lakukan prediksi pertama Anda untuk mendapatkan insight.';
    }
  }

  // Recent predictions mock
  List<Map<String, dynamic>> get recentPredictions => [
        {
          'date': DateTime.now().subtract(const Duration(days: 1)),
          'level': 'Sedang',
          'score': 65.4,
          'confidence': 87.2,
        },
        {
          'date': DateTime.now().subtract(const Duration(days: 5)),
          'level': 'Rendah',
          'score': 32.1,
          'confidence': 91.5,
        },
        {
          'date': DateTime.now().subtract(const Duration(days: 12)),
          'level': 'Tinggi',
          'score': 82.7,
          'confidence': 85.3,
        },
      ];
}
