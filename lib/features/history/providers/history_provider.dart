import 'package:flutter/material.dart';

class HistoryProvider extends ChangeNotifier {
  List<Map<String, dynamic>> get predictions => [
    {
      'id': '1',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'level': 'Sedang',
      'score': 65.4,
      'confidence': 87.2,
      'categories': {'Akademik': 72.0, 'Fisik': 55.0, 'Psikologis': 68.0, 'Sosial': 60.0},
    },
    {
      'id': '2',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'level': 'Rendah',
      'score': 32.1,
      'confidence': 91.5,
      'categories': {'Akademik': 35.0, 'Fisik': 28.0, 'Psikologis': 30.0, 'Sosial': 25.0},
    },
    {
      'id': '3',
      'date': DateTime.now().subtract(const Duration(days: 12)),
      'level': 'Tinggi',
      'score': 82.7,
      'confidence': 85.3,
      'categories': {'Akademik': 88.0, 'Fisik': 75.0, 'Psikologis': 85.0, 'Sosial': 72.0},
    },
    {
      'id': '4',
      'date': DateTime.now().subtract(const Duration(days: 20)),
      'level': 'Sedang',
      'score': 58.2,
      'confidence': 88.9,
      'categories': {'Akademik': 62.0, 'Fisik': 50.0, 'Psikologis': 60.0, 'Sosial': 55.0},
    },
    {
      'id': '5',
      'date': DateTime.now().subtract(const Duration(days: 30)),
      'level': 'Rendah',
      'score': 28.5,
      'confidence': 92.1,
      'categories': {'Akademik': 30.0, 'Fisik': 22.0, 'Psikologis': 32.0, 'Sosial': 20.0},
    },
    {
      'id': '6',
      'date': DateTime.now().subtract(const Duration(days: 45)),
      'level': 'Sedang',
      'score': 55.0,
      'confidence': 86.7,
      'categories': {'Akademik': 58.0, 'Fisik': 48.0, 'Psikologis': 62.0, 'Sosial': 45.0},
    },
    {
      'id': '7',
      'date': DateTime.now().subtract(const Duration(days: 60)),
      'level': 'Tinggi',
      'score': 78.9,
      'confidence': 84.1,
      'categories': {'Akademik': 82.0, 'Fisik': 72.0, 'Psikologis': 80.0, 'Sosial': 70.0},
    },
  ];

  int get totalPredictions => predictions.length;

  int get lowCount => predictions.where((p) => p['level'] == 'Rendah').length;
  int get mediumCount => predictions.where((p) => p['level'] == 'Sedang').length;
  int get highCount => predictions.where((p) => p['level'] == 'Tinggi').length;
}
