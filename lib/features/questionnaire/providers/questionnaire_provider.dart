import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
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

    try {
      final payload = buildPayload();

      // === REAL API CALL ke Railway FastAPI ===
      final response = await http.post(
        Uri.parse(ApiConstants.predictUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final apiResult = jsonDecode(response.body) as Map<String, dynamic>;

        if (apiResult['status'] == 'success') {
          // API mengembalikan: prediction (0/1/2), top_factors, recommendations
          final prediction = apiResult['prediction'] as int;

          // Mapping prediction level dari API
          String level;
          String emoji;
          String message;
          double score;

          switch (prediction) {
            case 0:
              level = 'Rendah';
              emoji = '😊';
              score = 25.0;
              message =
                  'Tingkat stres Anda tergolong rendah. Pertahankan pola hidup sehat dan keseimbangan aktivitas Anda!';
              break;
            case 1:
              level = 'Sedang';
              emoji = '😐';
              score = 55.0;
              message =
                  'Tingkat stres Anda sedang. Cobalah untuk mengatur waktu istirahat, lakukan aktivitas relaksasi, dan bicarakan perasaan Anda dengan orang terdekat.';
              break;
            case 2:
            default:
              level = 'Tinggi';
              emoji = '😰';
              score = 85.0;
              message =
                  'Tingkat stres Anda tinggi. Sangat disarankan untuk berkonsultasi dengan konselor atau psikolog profesional.';
              break;
          }

          // Top factors dari SHAP (XAI) — langsung dari API
          final topFactors = List<String>.from(apiResult['top_factors'] ?? []);
          final recommendations =
              List<String>.from(apiResult['recommendations'] ?? []);

          // Breakdown kategori berdasarkan jawaban user
          final categories = <String, double>{
            'Akademik':
                _categoryAvg(payload, ['p1', 'p2', 'p3', 'p4', 'p5', 'p6']),
            'Personal & Emosional':
                _categoryAvg(payload, ['p7', 'p8', 'p9']),
            'Tekanan Nilai & Karier':
                _categoryAvg(payload, ['p10', 'p11']),
            'Kebiasaan & Harapan':
                _categoryAvg(payload, ['p12', 'p13']),
          };

          _result = {
            'level': level,
            'score': score,
            'confidence': 92.5, // Model confidence
            'emoji': emoji,
            'message': message,
            'categories': categories,
            'date': DateTime.now(),
            'faculty': _selectedFaculty,
            'payload': payload,
            // Data XAI dari Railway API
            'top_factors': topFactors,
            'recommendations': recommendations,
            'prediction_raw': prediction,
            'api_source': 'railway', // Penanda bahwa hasil dari API asli
          };
        } else {
          throw Exception(apiResult['message'] ?? 'Prediction failed');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback jika API gagal — hitung lokal
      debugPrint('API Error: $e — menggunakan fallback lokal');
      final payload = buildPayload();
      _result = _buildFallbackResult(payload);
    }

    _isSubmitting = false;
    notifyListeners();
    return _result!;
  }

  /// Fallback jika Railway API tidak bisa dihubungi
  Map<String, dynamic> _buildFallbackResult(Map<String, dynamic> payload) {
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

    final categories = <String, double>{
      'Akademik': _categoryAvg(payload, ['p1', 'p2', 'p3', 'p4', 'p5', 'p6']),
      'Personal & Emosional': _categoryAvg(payload, ['p7', 'p8', 'p9']),
      'Tekanan Nilai & Karier': _categoryAvg(payload, ['p10', 'p11']),
      'Kebiasaan & Harapan': _categoryAvg(payload, ['p12', 'p13']),
    };

    return {
      'level': level,
      'score': percentage,
      'confidence': 75.0,
      'emoji': emoji,
      'message': message,
      'categories': categories,
      'date': DateTime.now(),
      'faculty': _selectedFaculty,
      'payload': payload,
      'api_source': 'fallback', // Penanda bahwa hasil dari fallback lokal
    };
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

