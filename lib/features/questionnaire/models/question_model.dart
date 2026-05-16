enum QuestionType { likert, faculty }

class QuestionModel {
  final int id;
  final String key; // JSON key: p1, p2, ..., faculty
  final String label; // Variable name e.g. Academic_Pressure
  final String text;
  final QuestionType type;

  const QuestionModel({
    required this.id,
    required this.key,
    required this.label,
    required this.text,
    this.type = QuestionType.likert,
  });

  static const List<String> faculties = [
    'FIT',
    'FEB',
    'FIF',
    'FTE',
    'FRI',
    'FKS',
    'FIK',
  ];

  static const List<QuestionModel> defaultQuestions = [
    QuestionModel(
      id: 1,
      key: 'faculty',
      label: 'Faculty',
      text: 'Fakultas apa anda terdaftar saat ini?',
      type: QuestionType.faculty,
    ),
    QuestionModel(
      id: 2,
      key: 'p1',
      label: 'Academic_Pressure',
      text: 'Apakah anda merasa gugup dan "tertekan" akibat tuntutan atau beban akademik?',
    ),
    QuestionModel(
      id: 3,
      key: 'p2',
      label: 'Cumulative_Difficulty',
      text: 'Apakah anda merasa kesulitan akademik menumpuk begitu tinggi sehingga anda tidak bisa mengatasinya (misalnya: mata kuliah sulit, banyak tugas deadline bersamaan)?',
    ),
    QuestionModel(
      id: 4,
      key: 'p3',
      label: 'Workload_Stress',
      text: 'Apakah tugas menumpuk dan deadline yang ketat sering meningkatkan tekanan psikologis saya?',
    ),
    QuestionModel(
      id: 5,
      key: 'p4',
      label: 'External_Expectation',
      text: 'Apakah anda merasa terbebani oleh ekspektasi tinggi dari orang tua/dosen/lingkungan?',
    ),
    QuestionModel(
      id: 6,
      key: 'p5',
      label: 'Lack_of_Control',
      text: 'Apakah anda merasa bahwa anda tidak mampu mengendalikan hal-hal penting yang berkaitan dengan studi Anda (misalnya: manajemen waktu belajar, penentuan topik skripsi)?',
    ),
    QuestionModel(
      id: 7,
      key: 'p6',
      label: 'Overwhelmed_Feeling',
      text: 'Apakah anda merasa tidak sanggup mengatasi semua kewajiban akademik yang harus anda penuhi (misalnya: tugas, presentasi, ujian, kegiatan organisasi)?',
    ),
    QuestionModel(
      id: 8,
      key: 'p7',
      label: 'Personal_Issues',
      text: 'Apakah masalah pribadi dan emosional (percintaan, keuangan, keluarga, dsb.) sering mengganggu fokus akademik anda?',
    ),
    QuestionModel(
      id: 9,
      key: 'p8',
      label: 'External_Frustration',
      text: 'Apakah anda merasa marah karena hal-hal di luar kendali anda yang memengaruhi studi (misalnya: kebijakan kampus yang berubah, masalah koneksi internet, nilai terlambat)?',
    ),
    QuestionModel(
      id: 10,
      key: 'p9',
      label: 'Academic_Changes_Stress',
      text: 'Apakah anda merasa kesal karena adanya perubahan mendadak pada kegiatan akademik?',
    ),
    QuestionModel(
      id: 11,
      key: 'p10',
      label: 'GPA_Pressure',
      text: 'Apakah anda merasa tertekan untuk selalu mendapatkan nilai tinggi dan mempertahankan IPK yang memuaskan?',
    ),
    QuestionModel(
      id: 12,
      key: 'p11',
      label: 'Career_Anxiety',
      text: 'Apakah anda merasa sangat bingung dan cemas dalam menentukan arah karier/magang/kerja setelah lulus?',
    ),
    QuestionModel(
      id: 13,
      key: 'p12',
      label: 'Unhealthy_Habits',
      text: 'Seberapa sering Anda melakukan kebiasaan buruk yang dapat mengganggu kesehatan (merokok, konsumsi alkohol, begadang tanpa alasan jelas)?',
    ),
    QuestionModel(
      id: 14,
      key: 'p13',
      label: 'Expectation_Alignment',
      text: 'Apakah anda merasa bahwa proses perkuliahan dan studi anda berjalan sesuai harapan?',
    ),
  ];
}
