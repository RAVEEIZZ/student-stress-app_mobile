import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/decorative_circles.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/notification_provider.dart';
import '../models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch notifikasi dari API saat screen dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNotifications();
    });
  }

  void _loadNotifications() {
    final auth = context.read<AuthProvider>();
    if (auth.isLoggedIn) {
      context.read<NotificationProvider>().fetchNotifications(auth.user!.id);
    }
  }

  // Mock notifications (dipertahankan sebagai notif statis)
  static final _mockNotifications = [
    _NotifData(Iconsax.calendar_tick, 'Reminder Konsultasi',
        'Jadwal konsultasi dengan konselor kampus besok pukul 10.00 WIB.',
        '5 jam lalu', AppColors.stressMedium, false),
    _NotifData(Iconsax.clipboard_tick, 'Reminder Kuesioner',
        'Sudah 2 minggu sejak prediksi terakhir. Isi kuesioner untuk update kondisi Anda.',
        '1 hari lalu', AppColors.stressLow, true),
    _NotifData(Iconsax.chart_success, 'Hasil Prediksi Tersedia',
        'Hasil prediksi stres Anda sudah tersedia. Lihat detail dan rekomendasi.',
        '3 hari lalu', AppColors.primary, true),
    _NotifData(Iconsax.message_question, 'Tips Kesehatan Mental',
        'Baca artikel terbaru tentang cara mengelola stres akademik di masa ujian.',
        '5 hari lalu', const Color(0xFF5BA0F6), true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const DecorativeCircles(),
          SafeArea(
            bottom: false,
            child: Consumer<NotificationProvider>(
              builder: (context, notifProvider, _) {
                final apiNotifs = notifProvider.notifications;
                final totalUnread = notifProvider.unreadCount +
                    _mockNotifications.where((n) => !n.isRead).length;

                return RefreshIndicator(
                  onRefresh: () async {
                    final auth = context.read<AuthProvider>();
                    if (auth.isLoggedIn) {
                      await notifProvider.refresh(auth.user!.id);
                    }
                  },
                  color: AppColors.primary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Notifikasi', style: AppTextStyles.heading2),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$totalUnread baru',
                                style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(duration: 400.ms),

                        const SizedBox(height: 24),

                        // === NOTIFIKASI DARI API (FOLLOW-UP DOSEN) ===
                        if (notifProvider.isLoading)
                          _buildLoadingIndicator()
                        else if (notifProvider.error != null && apiNotifs.isEmpty)
                          _buildErrorCard(notifProvider.error!)
                        else if (apiNotifs.isNotEmpty) ...[
                          // Section header
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Icon(Iconsax.teacher, size: 18,
                                    color: AppColors.primary),
                                const SizedBox(width: 8),
                                Text('Follow-Up Dosen',
                                    style: AppTextStyles.subtitle2.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ).animate().fadeIn(duration: 300.ms),

                          // API notification cards
                          ...apiNotifs.asMap().entries.map((entry) {
                            final index = entry.key;
                            final notif = entry.value;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildApiNotifCard(notif),
                            ).animate().fadeIn(
                                delay: (100 + index * 80).ms,
                                duration: 400.ms);
                          }),

                          // Divider antara API dan mock
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                const Expanded(
                                    child: Divider(color: AppColors.textHint)),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text('Notifikasi Lainnya',
                                      style: AppTextStyles.caption
                                          .copyWith(fontSize: 11)),
                                ),
                                const Expanded(
                                    child: Divider(color: AppColors.textHint)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],

                        // === NOTIFIKASI MOCK (DIPERTAHANKAN) ===
                        ..._mockNotifications.asMap().entries.map((entry) {
                          final index = entry.key;
                          final n = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildMockNotifCard(n),
                          ).animate().fadeIn(
                              delay: (200 + index * 80).ms, duration: 400.ms);
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Card untuk notifikasi dari API (follow-up dosen).
  Widget _buildApiNotifCard(NotificationModel notif) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: notif.isRead
            ? AppColors.surface
            : AppColors.primary.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: notif.isRead
            ? null
            : Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon dosen
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Iconsax.teacher, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Pesan dari ${notif.dosen.nama}',
                        style: AppTextStyles.subtitle2.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight:
                              notif.isRead ? FontWeight.w600 : FontWeight.w700,
                        ),
                      ),
                    ),
                    if (!notif.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  notif.note,
                  style: AppTextStyles.bodySmall.copyWith(height: 1.4),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  notif.timeAgo,
                  style: AppTextStyles.caption.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Card untuk notifikasi mock (existing).
  Widget _buildMockNotifCard(_NotifData n) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: n.isRead
            ? AppColors.surface
            : AppColors.primary.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(20),
        border: n.isRead
            ? null
            : Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
                color: n.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14)),
            child: Icon(n.icon, color: n.color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(n.title,
                            style: AppTextStyles.subtitle2.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: n.isRead
                                    ? FontWeight.w600
                                    : FontWeight.w700))),
                    if (!n.isRead)
                      Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(n.subtitle,
                    style: AppTextStyles.bodySmall.copyWith(height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Text(n.time,
                    style: AppTextStyles.caption.copyWith(fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Loading indicator.
  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text('Memuat notifikasi...',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textHint)),
          ],
        ),
      ),
    );
  }

  /// Error card.
  Widget _buildErrorCard(String message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.stressHighBg,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Iconsax.warning_2,
                color: AppColors.stressHigh, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.stressHigh),
              ),
            ),
            IconButton(
              onPressed: _loadNotifications,
              icon: const Icon(Iconsax.refresh, size: 20),
              color: AppColors.stressHigh,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotifData {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;
  final Color color;
  final bool isRead;

  const _NotifData(
      this.icon, this.title, this.subtitle, this.time, this.color, this.isRead);
}
