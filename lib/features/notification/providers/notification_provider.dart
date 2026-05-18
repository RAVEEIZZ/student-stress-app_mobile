import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../../../core/services/notification_service.dart';

/// Provider untuk mengelola state notifikasi follow-up dari dosen.
class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _error;
  bool _hasFetched = false;

  NotificationProvider() {
    // Add dummy notifications for testing
    _notifications = [
      NotificationModel(
        id: 1,
        note: 'Jadwal konsultasi dengan konselor kampus besok pukul 10.00 WIB. Berdasarkan hasil prediksi stres Anda, saya ingin membahas kondisi akademik dan kesejahteraan Anda lebih lanjut.',
        dosen: DosenInfo(id: 1, nama: 'Dr. Rina Sari, M.Psi'),
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      NotificationModel(
        id: 2,
        note: 'Sudah 2 minggu sejak prediksi terakhir. Isi kuesioner untuk update kondisi Anda. Saya ingin memantau perkembangan tingkat stres Anda secara berkala.',
        dosen: DosenInfo(id: 2, nama: 'Prof. Ahmad Fauzi, M.Kom'),
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      NotificationModel(
        id: 3,
        note: 'Hasil prediksi stres Anda sudah tersedia. Lihat detail dan rekomendasi. Saya perhatikan ada peningkatan tingkat stres dalam beberapa minggu terakhir.',
        dosen: DosenInfo(id: 3, nama: 'Dr. Siti Nurhaliza, S.Psi'),
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      NotificationModel(
        id: 4,
        note: 'Baca artikel terbaru tentang cara mengelola stres akademik di masa ujian. Saya lampirkan beberapa tips yang mungkin berguna untuk Anda.',
        dosen: DosenInfo(id: 4, nama: 'Dr. Budi Santoso, M.Pd'),
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasFetched => _hasFetched;

  /// Jumlah notifikasi yang belum dibaca.
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  /// Fetch notifikasi follow-up dari Laravel API.
  ///
  /// [studentId] diambil dari AuthProvider.user!.id.
  Future<void> fetchNotifications(int studentId) async {
    // Jangan re-fetch kalau sudah ada data (cukup refresh manual)
    if (_hasFetched && _notifications.isNotEmpty) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await NotificationService.fetchFollowUps(
        studentId: studentId,
      );

      // Hanya timpa data kalau API return hasil yang tidak kosong
      if (result.isNotEmpty) {
        _notifications = result;
      }
      // Kalau API kosong → pertahankan dummy data yang ada di constructor

      _hasFetched = true;
      _isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      // Kalau error → jangan kosongkan _notifications, cukup simpan pesan error
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      _hasFetched = true;
      notifyListeners();
    }
  }

  /// Refresh notifikasi (pull to refresh).
  /// Selalu re-fetch dari API, abaikan guard hasFetched.
  Future<void> refresh(int studentId) async {
    _hasFetched = false; // Reset agar fetchNotifications tidak di-skip
    await fetchNotifications(studentId);
  }

  /// Clear semua state (misal saat logout).
  void clear() {
    _notifications = [];
    _isLoading = false;
    _error = null;
    _hasFetched = false;
    notifyListeners();
  }
}
