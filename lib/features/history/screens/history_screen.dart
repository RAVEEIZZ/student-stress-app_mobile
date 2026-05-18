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
import '../providers/history_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch history saat screen dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchHistory();
    });
  }

  void _fetchHistory() {
    final nim = context.read<AuthProvider>().user?.nim ?? '';
    if (nim.isNotEmpty) {
      context.read<HistoryProvider>().fetchHistory(nim);
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryProvider>();

    return Scaffold(
      body: Stack(
        children: [
          const DecorativeCircles(),
          SafeArea(
            bottom: false,
            child: RefreshIndicator(
              onRefresh: () async {
                final nim = context.read<AuthProvider>().user?.nim ?? '';
                if (nim.isNotEmpty) {
                  await context.read<HistoryProvider>().refresh(nim);
                }
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Riwayat Prediksi', style: AppTextStyles.heading2)
                        .animate()
                        .fadeIn(duration: 400.ms),

                    const SizedBox(height: 8),

                    Text(
                      'Semua hasil prediksi stres Anda',
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 14),
                    ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

                    const SizedBox(height: 24),

                    // Stats row
                    Row(
                      children: [
                        _StatBadge(
                          label: 'Total',
                          value: '${history.totalPredictions}',
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 10),
                        _StatBadge(
                          label: 'Rendah',
                          value: '${history.lowCount}',
                          color: AppColors.stressLow,
                        ),
                        const SizedBox(width: 10),
                        _StatBadge(
                          label: 'Sedang',
                          value: '${history.mediumCount}',
                          color: AppColors.stressMedium,
                        ),
                        const SizedBox(width: 10),
                        _StatBadge(
                          label: 'Tinggi',
                          value: '${history.highCount}',
                          color: AppColors.stressHigh,
                        ),
                      ],
                    ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                    const SizedBox(height: 28),

                    // Loading state
                    if (history.isLoading)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            children: [
                              const CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 3,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Memuat riwayat...',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      )
                    // Empty state
                    else if (history.predictions.isEmpty && history.hasFetched)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            children: [
                              Icon(
                                Iconsax.document_text,
                                size: 64,
                                color: AppColors.textHint.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Belum ada riwayat prediksi',
                                style: AppTextStyles.subtitle2.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Lakukan prediksi stres untuk melihat riwayat di sini.',
                                style: AppTextStyles.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              OutlinedButton.icon(
                                onPressed: () => context.go(AppRoutes.questionnaire),
                                icon: const Icon(Iconsax.add_circle, size: 18),
                                label: const Text('Mulai Prediksi'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  side: const BorderSide(color: AppColors.primary),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: 300.ms, duration: 400.ms)
                    // Error state
                    else if (history.error != null)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            children: [
                              Icon(
                                Iconsax.warning_2,
                                size: 48,
                                color: AppColors.stressHigh.withOpacity(0.7),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                history.error!,
                                style: AppTextStyles.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              TextButton.icon(
                                onPressed: _fetchHistory,
                                icon: const Icon(Iconsax.refresh, size: 18),
                                label: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        ),
                      )
                    // Prediction list
                    else
                      ...history.predictions.asMap().entries.map((entry) {
                        final index = entry.key;
                        final pred = entry.value;
                        final color = AppColors.stressColor(pred['level']);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onTap: () => context.push(
                              AppRoutes.detailPrediction,
                              extra: pred,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.shadow,
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Level indicator
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      _getStressIcon(pred['level']),
                                      color: color,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: color.withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                'Stres ${pred['level']}',
                                                style: TextStyle(
                                                  color: color,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          _formatDate(pred['date'] is DateTime
                                              ? pred['date']
                                              : DateTime.now()),
                                          style: AppTextStyles.caption,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${(pred['score'] as num).toDouble().toStringAsFixed(1)}%',
                                        style: AppTextStyles.subtitle1.copyWith(
                                          color: color,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Conf: ${(pred['confidence'] as num).toDouble().toStringAsFixed(0)}%',
                                        style: AppTextStyles.caption,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Iconsax.arrow_right_3,
                                    color: AppColors.textHint,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ).animate().fadeIn(
                              delay: (300 + index * 80).ms,
                              duration: 400.ms,
                            );
                      }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStressIcon(String level) {
    switch (level.toLowerCase()) {
      case 'rendah':
        return Iconsax.emoji_happy;
      case 'sedang':
        return Iconsax.emoji_normal;
      case 'tinggi':
        return Iconsax.emoji_sad;
      default:
        return Iconsax.chart_2;
    }
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.subtitle1.copyWith(
                color: color,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
