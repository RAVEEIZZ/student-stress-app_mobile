import 'dart:math';
import 'package:flutter/material.dart';
import '../models/question_model.dart';

class QuestionnaireProvider extends ChangeNotifier {
  final List<QuestionModel> _questions = QuestionModel.defaultQuestions;
  final Map<int, int> _answers = {};
  int _currentIndex = 0;
  bool _isSubmitting = false;
  Map<String, dynamic>? _result;

  List<QuestionModel> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get totalQuestions => _questions.length;
  double get progress => (_currentIndex + 1) / _questions.length;
  QuestionModel get currentQuestion => _questions[_currentIndex];
  Map<int, int> get answers => _answers;
  bool get isSubmitting => _isSubmitting;
  Map<String, dynamic>? get result => _result;

  int? getAnswer(int questionId) => _answers[questionId];

  void setAnswer(int questionId, int value) {
    _answers[questionId] = value;
    notifyListeners();
  }

  bool canGoNext() => _answers.containsKey(_questions[_currentIndex].id);

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
  bool get allAnswered => _answers.length == _questions.length;

  Future<Map<String, dynamic>> submitAnswers() async {
    _isSubmitting = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Mock prediction result
    final random = Random();
    final totalScore = _answers.values.reduce((a, b) => a + b);
    final maxScore = _questions.length * 5;
    final percentage = (totalScore / maxScore) * 100;

    String level;
    String emoji;
    String message;

    if (percentage < 40) {
      level = 'Rendah';
      emoji = '😊';
      message = 'Tingkat stres Anda tergolong rendah. Pertahankan pola hidup sehat dan keseimbangan aktivitas Anda!';
    } else if (percentage < 70) {
      level = 'Sedang';
      emoji = '😐';
      message = 'Tingkat stres Anda sedang. Cobalah untuk mengatur waktu istirahat, lakukan aktivitas relaksasi, dan bicarakan perasaan Anda dengan orang terdekat.';
    } else {
      level = 'Tinggi';
      emoji = '😰';
      message = 'Tingkat stres Anda tinggi. Sangat disarankan untuk berkonsultasi dengan konselor atau psikolog profesional untuk mendapatkan bantuan.';
    }

    // Calculate category breakdowns
    final categories = <String, double>{};
    for (final category in ['Akademik', 'Fisik', 'Psikologis', 'Sosial']) {
      final categoryQuestions = _questions.where((q) => q.category == category);
      double sum = 0;
      int count = 0;
      for (final q in categoryQuestions) {
        if (_answers.containsKey(q.id)) {
          sum += _answers[q.id]!;
          count++;
        }
      }
      categories[category] = count > 0 ? (sum / (count * 5)) * 100 : 0;
    }

    _result = {
      'level': level,
      'score': percentage,
      'confidence': 80.0 + random.nextDouble() * 15,
      'emoji': emoji,
      'message': message,
      'categories': categories,
      'date': DateTime.now(),
    };

    _isSubmitting = false;
    notifyListeners();
    return _result!;
  }

  void reset() {
    _currentIndex = 0;
    _answers.clear();
    _result = null;
    notifyListeners();
  }
}
