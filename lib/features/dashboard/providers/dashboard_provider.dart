import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  /// Pesan insight berdasarkan level stres terakhir user.
  String insightMessage(String level) {
    switch (level.toLowerCase()) {
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
        return 'Lakukan prediksi pertama Anda untuk mendapatkan insight.';
    }
  }
}
