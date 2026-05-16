import 'dart:math';
import 'package:flutter/material.dart';
import '../models/question_model.dart';

class QuestionnaireProvider extends ChangeNotifier {
  final List<QuestionModel> _questions = QuestionModel.defaultQuestions;
  final Map<int, int> _likertAnswers = {}; // questionId -> 1..5
  String? _selectedFaculty;
  int _currentIndex = 0;
  bool _isSubmitting = false;
  Map<String, dynamic>? _result;

  List<QuestionModel> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get totalQuestions => _questions.length;
  double get progress => (_currentIndex + 1) / _questions.length;
  QuestionModel get currentQuestion => _questions[_currentIndex];
  bool get isSubmitting => _isSubmitting;
  Map<String, dynamic>? get result => _result;
  String? get selectedFaculty => _selectedFaculty;

  int? getLikertAnswer(int questionId) => _likertAnswers[questionId];

  void setLikertAnswer(int questionId, int value) {
    _likertAnswers[questionId] = value;
    notifyListeners();
  }

  void setFaculty(String faculty) {
    _selectedFaculty = faculty;
    notifyListeners();
  }

  bool canGoNext() {
    final q = _questions[_currentIndex];
    if (q.type == QuestionType.faculty) {
      return _selectedFaculty != null;
    }
    return _likertAnswers.containsKey(q.id);
  }

  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentIndex > 0) {
      _currentIndex--;
      notifyListeners();
    }
  }

  bool get isLastQuestion => _currentIndex == _questions.length - 1;
  bool get isFirstQuestion => _currentIndex == 0;

  bool get allAnswered {
    final likertQuestions =
        _questions.where((q) => q.type == QuestionType.likert);
    final allLikert =
        likertQuestions.every((q) => _likertAnswers.containsKey(q.id));
    return allLikert && _selectedFaculty != null;
  }

  /// Build JSON payload sesuai format API:
  /// { "faculty": "FIT", "p1": 5, "p2": 4, ... "p13": 4 }
  Map<String, dynamic> buildPayload() {
    final payload = <String, dynamic>{
      'faculty': _selectedFaculty ?? '',
    };
    for (final q in _questions) {
      if (q.type == QuestionType.likert) {
        payload[q.key] = _likertAnswers[q.id] ?? 0;
      }
    }
    return payload;
  }

  Future<Map<String, dynamic>> submitAnswers() async {
    _isSubmitting = true;
    notifyListeners();

    // Simulate API call — ganti dengan real API call ke backend
    await Future.delayed(const Duration(seconds: 2));

    final payload = buildPayload();

    // Hitung Academic_Stress_Score = rata-rata p1..p6
    final academicKeys = ['p1', 'p2', 'p3', 'p4', 'p5', 'p6'];
    final academicScores = academicKeys
        .map((k) => (payload[k] as int? ?? 0).toDouble())
        .toList();
    final academicStressScore =
        academicScores.reduce((a, b) => a + b) / academicScores.length;

    // Hitung total score dari semua p1..p13
    final allLikertKeys =
        _questions.where((q) => q.type == QuestionType.likert).map((q) => q.key);
    final totalScore = allLikertKeys
        .map((k) => (payload[k] as int? ?? 0))
        .reduce((a, b) => a + b);
    final maxScore = 13 * 5;
    final percentage = (totalScore / maxScore) * 100;

    String level;
    String emoji;
    String message;

    if (percentage < 40) {
      level = 'Rendah';
      emoji = '😊';
      message =
          'Tingkat stres Anda tergolong rendah. Pertahankan pola hidup sehat dan keseimbangan aktivitas Anda!';
    } else if (percentage < 70) {
      level = 'Sedang';
      emoji = '😐';
      message =
          'Tingkat stres Anda sedang. Cobalah untuk mengatur waktu istirahat, lakukan aktivitas relaksasi, dan bicarakan perasaan Anda dengan orang terdekat.';
    } else {
      level = 'Tinggi';
      emoji = '😰';
      message =
          'Tingkat stres Anda tinggi. Sangat disarankan untuk berkonsultasi dengan konselor atau psikolog profesional.';
    }

    // Breakdown kategori berdasarkan variabel
    final categories = <String, double>{
      'Akademik': _categoryAvg(payload, ['p1', 'p2', 'p3', 'p4', 'p5', 'p6']),
      'Personal & Emosional':
          _categoryAvg(payload, ['p7', 'p8', 'p9']),
      'Tekanan Nilai & Karier':
          _categoryAvg(payload, ['p10', 'p11']),
      'Kebiasaan & Harapan':
          _categoryAvg(payload, ['p12', 'p13']),
    };

    _result = {
      'level': level,
      'score': percentage,
      'confidence': 80.0 + Random().nextDouble() * 15,
      'emoji': emoji,
      'message': message,
      'categories': categories,
      'date': DateTime.now(),
      'academic_stress_score': academicStressScore,
      'faculty': _selectedFaculty,
      'payload': payload,
    };

    _isSubmitting = false;
    notifyListeners();
    return _result!;
  }

  double _categoryAvg(Map<String, dynamic> payload, List<String> keys) {
    final scores = keys.map((k) => (payload[k] as int? ?? 0).toDouble());
    final avg = scores.reduce((a, b) => a + b) / keys.length;
    return (avg / 5) * 100;
  }

  void reset() {
    _currentIndex = 0;
    _likertAnswers.clear();
    _selectedFaculty = null;
    _result = null;
    notifyListeners();
  }
}
