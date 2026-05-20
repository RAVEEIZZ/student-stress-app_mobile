import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../core/services/stress_result_service.dart';
import '../models/question_model.dart';

class QuestionnaireProvider extends ChangeNotifier {
  final List<QuestionModel> _questions = QuestionModel.defaultQuestions;
  final Map<int, int> _likertAnswers = {}; // questionId -> 1..5
  String? _selectedFaculty;
  int _currentIndex = 0;
  bool _isSubmitting = false;
  Map<String, dynamic>? _result;
  bool _savedToLaravel = false;

  List<QuestionModel> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get totalQuestions => _questions.length;
  double get progress => (_currentIndex + 1) / _questions.length;
  QuestionModel get currentQuestion => _questions[_currentIndex];
  bool get isSubmitting => _isSubmitting;
  Map<String, dynamic>? get result => _result;
  String? get selectedFaculty => _selectedFaculty;
  bool get savedToLaravel => _savedToLaravel;

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

  /// Submit jawaban kuesioner dengan Double Post:
  ///
  /// 1. **Post 1** → Railway FastAPI: kirim kuesioner, terima prediksi
  /// 2. Tampilkan hasil ke user
  /// 3. **Post 2** → Laravel API: kirim hasil prediksi untuk monitoring dosen
  ///
  /// [nim] diperlukan untuk menyimpan data di Laravel (identifikasi mahasiswa).
  Future<Map<String, dynamic>> submitAnswers({required String nim}) async {
    _isSubmitting = true;
    _savedToLaravel = false;
    notifyListeners();

    try {
      final payload = buildPayload();

      // ============================================
      // POST 1: Kirim ke Railway FastAPI (Prediksi)
      // ============================================
      final response = await http.post(
        Uri.parse(ApiConstants.predictUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final apiResult = jsonDecode(response.body) as Map<String, dynamic>;

        debugPrint('🔍 Raw API response: ${response.body}');

        if (apiResult['status'] == 'success') {
          // Safe parsing: gunakan num→int agar tidak crash kalau API return double
          final prediction = (apiResult['prediction'] as num?)?.toInt() ?? 0;

          debugPrint('🔍 Parsed prediction=$prediction, score=${apiResult['score']}, confidence=${apiResult['confidence']}');

          // Mapping prediction level dari API
          String level;
          String levelForLaravel;
          String emoji;
          String message;

          switch (prediction) {
            case 0:
              level = 'Rendah';
              levelForLaravel = 'Low';
              emoji = '😊';
              message =
                  'Tingkat stres Anda tergolong rendah. Pertahankan pola hidup sehat dan keseimbangan aktivitas Anda!';
              break;
            case 1:
              level = 'Sedang';
              levelForLaravel = 'Moderate';
              emoji = '😐';
              message =
                  'Tingkat stres Anda sedang. Cobalah untuk mengatur waktu istirahat, lakukan aktivitas relaksasi, dan bicarakan perasaan Anda dengan orang terdekat.';
              break;
            case 2:
            default:
              level = 'Tinggi';
              levelForLaravel = 'High';
              emoji = '😰';
              message =
                  'Tingkat stres Anda tinggi. Sangat disarankan untuk berkonsultasi dengan konselor atau psikolog profesional.';
              break;
          }

          // Top factors dari SHAP (XAI) — langsung dari API
          final topFactors = List<String>.from(apiResult['top_factors'] ?? []);
          final recommendations =
              List<String>.from(apiResult['recommendations'] ?? []);

          // Parse score & confidence dari API response (num-safe)
          // Jika API belum mengirim field ini (versi Railway lama), hitung lokal
          double apiScore;
          if (apiResult.containsKey('score') && apiResult['score'] != null) {
            apiScore = (apiResult['score'] as num).toDouble();
            debugPrint('✅ Score dari API: $apiScore');
          } else {
            // Hitung lokal: (sum p1..p13 / 65) * 100 — sama seperti main.py
            final totalSum = ['p1','p2','p3','p4','p5','p6','p7','p8','p9','p10','p11','p12','p13']
                .map((k) => (payload[k] as int? ?? 0))
                .reduce((a, b) => a + b);
            apiScore = (totalSum / 65) * 100;
            debugPrint('⚠️ Score dihitung lokal: $apiScore');
          }

          double apiConfidence;
          if (apiResult.containsKey('confidence') && apiResult['confidence'] != null) {
            apiConfidence = (apiResult['confidence'] as num).toDouble();
            debugPrint('✅ Confidence dari API: $apiConfidence');
          } else {
            // Estimasi confidence berdasarkan seberapa jelas prediksi
            // Logika: semakin jauh score dari batas kelas, semakin yakin
            if (apiScore < 30 || apiScore > 75) {
              apiConfidence = 88.0 + (apiScore > 75 ? (apiScore - 75) * 0.4 : (30 - apiScore) * 0.4);
            } else {
              apiConfidence = 75.0;
            }
            apiConfidence = apiConfidence.clamp(60.0, 99.0);
            debugPrint('⚠️ Confidence diestimasi lokal: $apiConfidence');
          }

          // Parse categories dari API atau hitung lokal
          Map<String, double> categories;
          final rawCat = apiResult['categories'];
          if (rawCat != null && rawCat is Map) {
            categories = {
              'Akademik': (rawCat['akademik'] as num?)?.toDouble() ?? 0.0,
              'Fisik': (rawCat['fisik'] as num?)?.toDouble() ?? 0.0,
              'Psikologis': (rawCat['psikologis'] as num?)?.toDouble() ?? 0.0,
              'Sosial': (rawCat['sosial'] as num?)?.toDouble() ?? 0.0,
            };
            debugPrint('✅ Categories dari API: $categories');
          } else {
            // Hitung lokal — sama seperti main.py categories_real
            final akademik = ((payload['p1'] as int? ?? 0) + (payload['p2'] as int? ?? 0) +
                (payload['p3'] as int? ?? 0) + (payload['p4'] as int? ?? 0) +
                (payload['p5'] as int? ?? 0) + (payload['p6'] as int? ?? 0)) / 30 * 100;
            final fisik = ((payload['p7'] as int? ?? 0) + (payload['p8'] as int? ?? 0)) / 10 * 100;
            final psikologis = ((payload['p9'] as int? ?? 0) + (payload['p10'] as int? ?? 0) +
                (payload['p11'] as int? ?? 0)) / 15 * 100;
            final sosial = ((payload['p12'] as int? ?? 0) + (payload['p13'] as int? ?? 0)) / 10 * 100;
            categories = {
              'Akademik': double.parse(akademik.toStringAsFixed(2)),
              'Fisik': double.parse(fisik.toStringAsFixed(2)),
              'Psikologis': double.parse(psikologis.toStringAsFixed(2)),
              'Sosial': double.parse(sosial.toStringAsFixed(2)),
            };
            debugPrint('⚠️ Categories dihitung lokal: $categories');
          }

          _result = {
            'level': level,
            'score': apiScore,
            'confidence': apiConfidence,
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

          // ============================================
          // POST 2: Kirim ke Laravel API (Simpan riwayat)
          // ============================================
          // Non-blocking: jika gagal, user tetap bisa lihat hasil.
          // Dosen wali akan bisa lihat data ini di web monitoring.
          _sendToLaravel(
            nim: nim,
            tingkatStres: levelForLaravel,
            topFactors: topFactors,
            recommendations: recommendations,
            predictionRaw: prediction,
            score: apiScore,
            confidence: apiConfidence,
            answers: categories,
          );
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

      // Tetap coba kirim ke Laravel meskipun pakai fallback
      if (nim.isNotEmpty) {
        final level = _result!['level'] as String;
        String levelForLaravel;
        switch (level) {
          case 'Rendah':
            levelForLaravel = 'Low';
            break;
          case 'Sedang':
            levelForLaravel = 'Moderate';
            break;
          default:
            levelForLaravel = 'High';
        }
        _sendToLaravel(
          nim: nim,
          tingkatStres: levelForLaravel,
          topFactors: null,
          recommendations: null,
          predictionRaw: null,
          score: (_result!['score'] as num).toDouble(),
          confidence: (_result!['confidence'] as num).toDouble(),
          answers: _result!['categories'] as Map<String, double>?,
        );
      }
    }

    _isSubmitting = false;
    notifyListeners();
    return _result!;
  }

  /// Kirim hasil prediksi ke Laravel secara async (non-blocking).
  Future<void> _sendToLaravel({
    required String nim,
    required String tingkatStres,
    List<String>? topFactors,
    List<String>? recommendations,
    int? predictionRaw,
    double? score,
    double? confidence,
    Map<String, double>? answers,
  }) async {
    try {
      // Gabung recommendations menjadi satu string untuk kolom text
      String? recommendationText;
      if (recommendations != null && recommendations.isNotEmpty) {
        recommendationText = recommendations.join('\n• ');
        recommendationText = '• $recommendationText';
      }

      final success = await StressResultService.sendPrediction(
        nim: nim,
        tingkatStres: tingkatStres,
        topFactors: topFactors,
        recommendation: recommendationText,
        predictionRaw: predictionRaw,
        score: score,
        confidence: confidence,
        answers: answers,
      );

      _savedToLaravel = success;
      notifyListeners();
    } catch (e) {
      debugPrint('Error in _sendToLaravel: $e');
      _savedToLaravel = false;
    }
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
      'Fisik': _categoryAvg(payload, ['p7', 'p8']),
      'Psikologis': _categoryAvg(payload, ['p9', 'p10', 'p11']),
      'Sosial': _categoryAvg(payload, ['p12', 'p13']),
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
    _savedToLaravel = false;
    notifyListeners();
  }
}
