class PredictionModel {
  final String level;
  final double score;
  final double confidence;
  final Map<String, double> categories;
  final DateTime date;

  PredictionModel({
    required this.level,
    required this.score,
    required this.confidence,
    required this.categories,
    required this.date,
  });

  factory PredictionModel.fromMap(Map<String, dynamic> map) {
    return PredictionModel(
      level: map['level'] ?? 'Rendah',
      score: (map['score'] as num?)?.toDouble() ?? 0,
      confidence: (map['confidence'] as num?)?.toDouble() ?? 0,
      categories: Map<String, double>.from(map['categories'] ?? {}),
      date: map['date'] is DateTime
          ? map['date']
          : DateTime.tryParse(map['date']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'level': level,
        'score': score,
        'confidence': confidence,
        'categories': categories,
        'date': date.toIso8601String(),
      };

  String get emoji {
    switch (level.toLowerCase()) {
      case 'rendah':
        return '😊';
      case 'sedang':
        return '😐';
      case 'tinggi':
        return '😰';
      default:
        return '🤔';
    }
  }

  String get message {
    switch (level.toLowerCase()) {
      case 'rendah':
        return 'Tingkat stres Anda tergolong rendah. Pertahankan pola hidup sehat!';
      case 'sedang':
        return 'Tingkat stres Anda sedang. Cobalah untuk mengatur waktu istirahat.';
      case 'tinggi':
        return 'Tingkat stres Anda tinggi. Konsultasikan dengan profesional.';
      default:
        return '';
    }
  }

  static List<String> getRecommendations(String level) {
    switch (level.toLowerCase()) {
      case 'rendah':
        return [
          'Pertahankan pola tidur teratur 7-8 jam',
          'Lanjutkan aktivitas olahraga rutin',
          'Jaga komunikasi yang baik dengan teman dan keluarga',
          'Tetap konsisten dengan jadwal belajar',
        ];
      case 'sedang':
        return [
          'Atur waktu istirahat di antara aktivitas belajar',
          'Coba teknik relaksasi seperti meditasi atau pernapasan dalam',
          'Bicarakan perasaan Anda dengan orang yang dipercaya',
          'Kurangi konsumsi kafein dan makanan tidak sehat',
          'Luangkan waktu untuk hobi dan aktivitas menyenangkan',
        ];
      case 'tinggi':
        return [
          'Segera hubungi konselor atau psikolog kampus',
          'Bicarakan kondisi Anda dengan dosen pembimbing',
          'Prioritaskan kesehatan mental daripada nilai akademik',
          'Pertimbangkan untuk mengambil cuti akademik jika diperlukan',
          'Hindari isolasi sosial, tetap berkomunikasi dengan keluarga',
          'Lakukan olahraga ringan seperti jalan kaki 30 menit per hari',
        ];
      default:
        return [];
    }
  }
}
