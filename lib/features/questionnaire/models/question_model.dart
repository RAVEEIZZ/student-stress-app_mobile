class QuestionModel {
  final int id;
  final String text;
  final String category; // Akademik, Fisik, Psikologis, Sosial

  const QuestionModel({
    required this.id,
    required this.text,
    required this.category,
  });

  static const List<QuestionModel> defaultQuestions = [
    // Akademik (1-5)
    QuestionModel(id: 1, text: 'Seberapa sering Anda merasa tertekan dengan tugas kuliah?', category: 'Akademik'),
    QuestionModel(id: 2, text: 'Apakah Anda merasa kesulitan memahami materi perkuliahan?', category: 'Akademik'),
    QuestionModel(id: 3, text: 'Seberapa sering Anda merasa cemas menjelang ujian?', category: 'Akademik'),
    QuestionModel(id: 4, text: 'Apakah beban akademik mengganggu waktu istirahat Anda?', category: 'Akademik'),
    QuestionModel(id: 5, text: 'Seberapa puas Anda dengan pencapaian akademik saat ini?', category: 'Akademik'),

    // Fisik (6-10)
    QuestionModel(id: 6, text: 'Seberapa sering Anda mengalami sakit kepala atau pusing?', category: 'Fisik'),
    QuestionModel(id: 7, text: 'Apakah Anda tidur kurang dari 6 jam per hari?', category: 'Fisik'),
    QuestionModel(id: 8, text: 'Seberapa sering Anda melewatkan waktu makan?', category: 'Fisik'),
    QuestionModel(id: 9, text: 'Apakah Anda merasa lelah secara fisik sepanjang hari?', category: 'Fisik'),
    QuestionModel(id: 10, text: 'Seberapa sering Anda berolahraga dalam seminggu?', category: 'Fisik'),

    // Psikologis (11-15)
    QuestionModel(id: 11, text: 'Seberapa sering Anda merasa cemas tanpa alasan yang jelas?', category: 'Psikologis'),
    QuestionModel(id: 12, text: 'Apakah Anda sulit berkonsentrasi saat belajar?', category: 'Psikologis'),
    QuestionModel(id: 13, text: 'Seberapa sering Anda merasa tidak bersemangat?', category: 'Psikologis'),
    QuestionModel(id: 14, text: 'Apakah Anda sering merasa kewalahan dengan tanggung jawab?', category: 'Psikologis'),
    QuestionModel(id: 15, text: 'Seberapa sering Anda merasa suasana hati berubah drastis?', category: 'Psikologis'),

    // Sosial (16-20)
    QuestionModel(id: 16, text: 'Apakah Anda merasa kesulitan bergaul dengan teman sekelas?', category: 'Sosial'),
    QuestionModel(id: 17, text: 'Seberapa sering Anda merasa kesepian di kampus?', category: 'Sosial'),
    QuestionModel(id: 18, text: 'Apakah hubungan Anda dengan keluarga memengaruhi mood?', category: 'Sosial'),
    QuestionModel(id: 19, text: 'Seberapa sering Anda menghindari interaksi sosial?', category: 'Sosial'),
    QuestionModel(id: 20, text: 'Apakah Anda merasa didukung oleh lingkungan sekitar?', category: 'Sosial'),
  ];
}
