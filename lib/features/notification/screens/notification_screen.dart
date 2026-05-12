import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/decorative_circles.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      _NotifData(Iconsax.teacher, 'Permintaan Pertemuan Dosen', 'Dr. Sari ingin menjadwalkan pertemuan konsultasi terkait hasil prediksi stres Anda.', '2 jam lalu', AppColors.primary, false),
      _NotifData(Iconsax.calendar_tick, 'Reminder Konsultasi', 'Jadwal konsultasi dengan konselor kampus besok pukul 10.00 WIB.', '5 jam lalu', AppColors.stressMedium, false),
      _NotifData(Iconsax.clipboard_tick, 'Reminder Kuesioner', 'Sudah 2 minggu sejak prediksi terakhir. Isi kuesioner untuk update kondisi Anda.', '1 hari lalu', AppColors.stressLow, true),
      _NotifData(Iconsax.chart_success, 'Hasil Prediksi Tersedia', 'Hasil prediksi stres Anda sudah tersedia. Lihat detail dan rekomendasi.', '3 hari lalu', AppColors.primary, true),
      _NotifData(Iconsax.message_question, 'Tips Kesehatan Mental', 'Baca artikel terbaru tentang cara mengelola stres akademik di masa ujian.', '5 hari lalu', const Color(0xFF5BA0F6), true),
    ];

    final unreadCount = notifications.where((n) => !n.isRead).length;

    return Scaffold(
      body: Stack(
        children: [
          const DecorativeCircles(),
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Notifikasi', style: AppTextStyles.heading2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$unreadCount baru',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 24),
                  ...notifications.asMap().entries.map((entry) {
                    final index = entry.key;
                    final n = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: n.isRead ? AppColors.surface : AppColors.primary.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(20),
                          border: n.isRead ? null : Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
                          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: const Offset(0, 3))],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 46, height: 46,
                              decoration: BoxDecoration(color: n.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                              child: Icon(n.icon, color: n.color, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: Text(n.title, style: AppTextStyles.subtitle2.copyWith(color: AppColors.textPrimary, fontWeight: n.isRead ? FontWeight.w600 : FontWeight.w700))),
                                      if (!n.isRead) Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(n.subtitle, style: AppTextStyles.bodySmall.copyWith(height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 8),
                                  Text(n.time, style: AppTextStyles.caption.copyWith(fontSize: 11)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: (200 + index * 80).ms, duration: 400.ms);
                  }),
                ],
              ),
            ),
          ),
        ],
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

  const _NotifData(this.icon, this.title, this.subtitle, this.time, this.color, this.isRead);
}
