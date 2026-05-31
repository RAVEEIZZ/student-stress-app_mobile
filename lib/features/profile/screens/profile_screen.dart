import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/decorative_circles.dart';
import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      body: Stack(
        children: [
          const DecorativeCircles(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Iconsax.arrow_left, size: 22),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('Profil', style: AppTextStyles.subtitle1.copyWith(fontSize: 18)),
                    ],
                  ).animate().fadeIn(duration: 300.ms),
                  const SizedBox(height: 32),
                  // Avatar
                  Container(
                    width: 90, height: 90,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 8))],
                    ),
                    child: Center(
                      child: Text(
                        (user?.name ?? 'U')[0].toUpperCase(),
                        style: AppTextStyles.heading1.copyWith(color: Colors.white, fontSize: 36),
                      ),
                    ),
                  ).animate().fadeIn(delay: 100.ms, duration: 500.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), delay: 100.ms, duration: 500.ms),
                  const SizedBox(height: 16),
                  Text(user?.name ?? 'User', style: AppTextStyles.heading3).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                  const SizedBox(height: 4),
                  Text(user?.email ?? 'user@email.com', style: AppTextStyles.bodySmall).animate().fadeIn(delay: 250.ms, duration: 400.ms),
                  const SizedBox(height: 32),
                  // Info cards
                  _infoTile(Iconsax.user, 'Nama Lengkap', user?.name ?? '-'),
                  const SizedBox(height: 12),
                  _infoTile(Iconsax.sms, 'Email', user?.email ?? '-'),
                  const SizedBox(height: 12),
                  _infoTile(Iconsax.card, 'NIM', user?.nim ?? '-'),
                  const SizedBox(height: 12),
                  _infoTile(Iconsax.calendar_1, 'Bergabung Sejak', user?.createdAt != null ? _formatDate(user!.createdAt!.toLocal()) : '-'),
                  const SizedBox(height: 32),
                  // Stats
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 16, offset: const Offset(0, 4))],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statItem('12', 'Prediksi', AppColors.primary),
                        Container(width: 1, height: 36, color: AppColors.border),
                        _statItem(
                          _formatActiveDuration(user?.createdAt),
                          _formatActiveDurationLabel(user?.createdAt),
                          AppColors.stressLow,
                        ),
                        Container(width: 1, height: 36, color: AppColors.border),
                        _statItem('87%', 'Avg Conf', AppColors.stressMedium),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
                  const SizedBox(height: 32),
                  // Logout
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        auth.logout();
                        context.go(AppRoutes.login);
                      },
                      icon: const Icon(Iconsax.logout, color: AppColors.stressHigh),
                      label: Text('Keluar', style: AppTextStyles.subtitle1.copyWith(color: AppColors.stressHigh)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.stressHigh),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption),
                const SizedBox(height: 2),
                Text(value, style: AppTextStyles.subtitle2.copyWith(color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.heading3.copyWith(color: color)),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  /// Hitung angka durasi aktif dari createdAt sampai sekarang.
  /// < 30 hari → tampil jumlah hari, >= 30 hari → tampil jumlah bulan.
  String _formatActiveDuration(DateTime? createdAt) {
    if (createdAt == null) return '-';
    final diff = DateTime.now().difference(createdAt);
    final days = diff.inDays;
    if (days < 30) return '${days < 1 ? 1 : days}';
    return '${(days / 30).floor()}';
  }

  /// Label satuan untuk durasi aktif.
  String _formatActiveDurationLabel(DateTime? createdAt) {
    if (createdAt == null) return 'Aktif';
    final diff = DateTime.now().difference(createdAt);
    return diff.inDays < 30 ? 'Hari' : 'Bulan';
  }
}
