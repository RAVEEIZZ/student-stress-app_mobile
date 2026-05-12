import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/prediction_model.dart';

class DetailPredictionScreen extends StatelessWidget {
  final Map<String, dynamic>? predictionData;

  const DetailPredictionScreen({super.key, this.predictionData});

  String _formatDate(DateTime date) {
    const months = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final data = predictionData ?? {};
    final level = data['level'] as String? ?? 'Rendah';
    final score = (data['score'] as num?)?.toDouble() ?? 0;
    final confidence = (data['confidence'] as num?)?.toDouble() ?? 0;
    final color = AppColors.stressColor(level);
    final bgColor = AppColors.stressBgColor(level);
    final categories = data['categories'] as Map<String, double>? ??
        {'Akademik': 45, 'Fisik': 35, 'Psikologis': 55, 'Sosial': 30};
    final date = data['date'] is DateTime ? data['date'] as DateTime : DateTime.now();
    final recommendations = PredictionModel.getRecommendations(level);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 24, 0),
              child: Row(
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
                  Expanded(
                    child: Text(
                      'Detail Prediksi',
                      style: AppTextStyles.subtitle1.copyWith(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: color.withOpacity(0.2)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            PredictionModel(
                              level: level,
                              score: score,
                              confidence: confidence,
                              categories: categories,
                              date: date,
                            ).emoji,
                            style: const TextStyle(fontSize: 48),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              'Stres $level',
                              style: AppTextStyles.subtitle1.copyWith(
                                color: color,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatDate(date),
                            style: AppTextStyles.bodySmall,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _ScoreItem(
                                label: 'Score',
                                value: '${score.toStringAsFixed(1)}%',
                                color: color,
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                margin: const EdgeInsets.symmetric(horizontal: 32),
                                color: color.withOpacity(0.2),
                              ),
                              _ScoreItem(
                                label: 'Confidence',
                                value: '${confidence.toStringAsFixed(1)}%',
                                color: color,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms),

                    const SizedBox(height: 24),

                    // Category breakdown
                    Text('Breakdown Kategori', style: AppTextStyles.subtitle1)
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 400.ms),

                    const SizedBox(height: 16),

                    ...categories.entries.toList().asMap().entries.map((entry) {
                      final index = entry.key;
                      final cat = entry.value;
                      final catColor = _getCategoryColor(cat.key);
                      final catIcon = _getCategoryIcon(cat.key);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadow,
                                blurRadius: 12,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: catColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(catIcon, color: catColor, size: 20),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          cat.key,
                                          style: AppTextStyles.subtitle2
                                              .copyWith(
                                                  color:
                                                      AppColors.textPrimary),
                                        ),
                                        Text(
                                          '${cat.value.toStringAsFixed(0)}%',
                                          style:
                                              AppTextStyles.subtitle2.copyWith(
                                            color: catColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    LinearPercentIndicator(
                                      padding: EdgeInsets.zero,
                                      lineHeight: 8,
                                      percent: (cat.value / 100).clamp(0, 1),
                                      backgroundColor:
                                          catColor.withOpacity(0.1),
                                      progressColor: catColor,
                                      barRadius: const Radius.circular(10),
                                      animation: true,
                                      animationDuration: 800,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(
                            delay: (300 + index * 100).ms,
                            duration: 400.ms,
                          );
                    }),

                    const SizedBox(height: 24),

                    // Recommendations
                    Text('Rekomendasi', style: AppTextStyles.subtitle1)
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 400.ms),

                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
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
                      child: Column(
                        children: recommendations
                            .asMap()
                            .entries
                            .map((entry) => Padding(
                                  padding: EdgeInsets.only(
                                    bottom: entry.key < recommendations.length - 1
                                        ? 14
                                        : 0,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: color.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${entry.key + 1}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: color,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          entry.value,
                                          style: AppTextStyles.body.copyWith(
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ).animate().fadeIn(delay: 700.ms, duration: 400.ms),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Akademik':
        return AppColors.primary;
      case 'Fisik':
        return AppColors.stressLow;
      case 'Psikologis':
        return AppColors.stressMedium;
      case 'Sosial':
        return const Color(0xFF5BA0F6);
      default:
        return AppColors.primary;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Akademik':
        return Iconsax.book_1;
      case 'Fisik':
        return Iconsax.heart;
      case 'Psikologis':
        return Iconsax.emoji_happy;
      case 'Sosial':
        return Iconsax.people;
      default:
        return Iconsax.chart_2;
    }
  }
}

class _ScoreItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ScoreItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.heading3.copyWith(color: color)),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
