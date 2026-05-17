import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../../../core/services/notification_service.dart';

/// Provider untuk mengelola state notifikasi follow-up dari dosen.
class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _error;
  bool _hasFetched = false;

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
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _notifications = await NotificationService.fetchFollowUps(
        studentId: studentId,
      );
      _hasFetched = true;
      _isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      _hasFetched = true;
      notifyListeners();
    }
  }

  /// Refresh notifikasi (pull to refresh).
  Future<void> refresh(int studentId) async {
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
