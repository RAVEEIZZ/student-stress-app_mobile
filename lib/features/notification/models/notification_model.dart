/// Model untuk notifikasi follow-up dari dosen.
/// Disesuaikan dengan response Laravel API GET /api/follow-ups.
class NotificationModel {
  final int id;
  final String note;
  final DosenInfo dosen;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.note,
    required this.dosen,
    required this.isRead,
    required this.createdAt,
  });

  /// Parse dari JSON response Laravel API.
  ///
  /// Expected format:
  /// ```json
  /// {
  ///   "id": 1,
  ///   "note": "Segera konsultasi dengan dosen.",
  ///   "dosen": { "id": 2, "nama": "Dr. Ahmad Fauzi" },
  ///   "is_read": false,
  ///   "created_at": "2026-05-17T10:30:00.000000Z"
  /// }
  /// ```
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      note: json['note'] ?? '',
      dosen: DosenInfo.fromJson(json['dosen'] ?? {}),
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      note: note,
      dosen: dosen,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }

  /// Hitung waktu relatif (misal: "2 jam lalu", "3 hari lalu").
  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 30) return '${diff.inDays} hari lalu';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()} bulan lalu';
    return '${(diff.inDays / 365).floor()} tahun lalu';
  }
}

/// Info dosen yang mengirim follow-up.
class DosenInfo {
  final int id;
  final String nama;

  DosenInfo({
    required this.id,
    required this.nama,
  });

  factory DosenInfo.fromJson(Map<String, dynamic> json) {
    return DosenInfo(
      id: json['id'] is int ? json['id'] : 0,
      nama: json['nama'] ?? 'Dosen',
    );
  }
}
