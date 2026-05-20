import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../core/widgets/decorative_circles.dart';
import '../providers/dashboard_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../history/providers/history_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    final auth = context.read<AuthProvider>();
    final nim = auth.user?.nim ?? '';
    final name = auth.user?.nama ?? '';

    // Set nama user di DashboardProvider
    context.read<DashboardProvider>().setUserName(name);

    // Fetch history dari Laravel agar dashboard terisi data riil
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
    final dashboard = context.watch<DashboardProvider>();

    return Scaffold(
      body: Stack(
        children: [
          const DecorativeCircles(),
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with greeting & profile
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Halo, ${dashboard.userName}! 👋',
                              style: AppTextStyles.heading2,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Bagaimana perasaanmu hari ini?',
                              style: AppTextStyles.bodySmall.copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push(AppRoutes.profile),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              dashboard.userName[0].toUpperCase(),
                              style: AppTextStyles.subtitle1.copyWith(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms).slideY(
                        begin: -0.1,
                        end: 0,
                        duration: 400.ms,
                      ),

                  const SizedBox(height: 28),

                  // Stats cards
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          icon: Iconsax.chart_2,
                          label: 'Total Prediksi',
                          value: '${dashboard.totalPredictions}',
                          iconColor: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: StatCard(
                          icon: Iconsax.status_up,
                          label: 'Prediksi Terakhir',
                          value: dashboard.lastPredictionLevel,
                          iconColor: dashboard.hasPredictions
                              ? AppColors.stressColor(dashboard.lastPredictionLevel)
                              : AppColors.textHint,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(
                        begin: 0.1,
                        end: 0,
                        delay: 200.ms,
                        duration: 400.ms,
                      ),

                  const SizedBox(height: 20),

                  // CTA Card
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.questionnaire),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mulai Prediksi',
                                  style: AppTextStyles.heading3.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Isi kuesioner untuk mengetahui\ntingkat stres Anda saat ini',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Iconsax.clipboard_tick,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(
                        begin: 0.1,
                        end: 0,
                        delay: 300.ms,
                        duration: 400.ms,
                      ),

                  const SizedBox(height: 20),

                  // Insight Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: dashboard.hasPredictions
                          ? AppColors.stressBgColor(dashboard.lastPredictionLevel)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: dashboard.hasPredictions
                            ? AppColors.stressColor(dashboard.lastPredictionLevel)
                                .withOpacity(0.2)
                            : AppColors.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: (dashboard.hasPredictions
                                    ? AppColors.stressColor(
                                        dashboard.lastPredictionLevel)
                                    : AppColors.primary)
                                .withOpacity(0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Iconsax.lamp_charge,
                            color: dashboard.hasPredictions
                                ? AppColors.stressColor(
                                    dashboard.lastPredictionLevel)
                                : AppColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Insight',
                                style: AppTextStyles.subtitle2.copyWith(
                                  color: dashboard.hasPredictions
                                      ? AppColors.stressColor(
                                          dashboard.lastPredictionLevel)
                                      : AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                dashboard.insightMessage,
                                style: AppTextStyles.bodySmall.copyWith(
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms, duration: 400.ms),

                  const SizedBox(height: 28),

                  // Recent Predictions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Riwayat Terbaru', style: AppTextStyles.subtitle1),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.history),
                        child: Text(
                          'Lihat Semua',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Empty state for recent predictions
                  if (dashboard.recentPredictions.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow,
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Iconsax.document_text,
                            size: 40,
                            color: AppColors.textHint.withOpacity(0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Belum ada riwayat prediksi',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 500.ms, duration: 400.ms),

                  // Prediction list
                  ...dashboard.recentPredictions.asMap().entries.map((entry) {
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
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(18),
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
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  Iconsax.chart_1,
                                  color: color,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Stres ${pred['level']}',
                                      style: AppTextStyles.subtitle2.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
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
                                    ),
                                  ),
                                  Text(
                                    'Conf: ${(pred['confidence'] as num).toDouble().toStringAsFixed(0)}%',
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Iconsax.arrow_right_3,
                                color: AppColors.textHint,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().fadeIn(
                          delay: (500 + index * 100).ms,
                          duration: 400.ms,
                        );
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
