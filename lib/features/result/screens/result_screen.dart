import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/stress_card.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic>? predictionData;

  const ResultScreen({super.key, this.predictionData});

  @override
  Widget build(BuildContext context) {
    final data = predictionData ??
        {
          'level': 'Rendah',
          'score': 0.0,
          'confidence': 0.0,
          'emoji': '🤔',
          'message': 'Data prediksi tidak tersedia.',
        };

    final level = data['level'] as String;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Title
              Text(
                'Hasil Prediksi',
                style: AppTextStyles.heading2,
              ).animate().fadeIn(duration: 400.ms),

              const SizedBox(height: 8),

              Text(
                'Berikut adalah hasil analisis AI',
                style: AppTextStyles.bodySmall.copyWith(fontSize: 14),
              ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

              const SizedBox(height: 32),

              // Main stress card
              StressCard(
                level: level,
                score: (data['score'] as num).toDouble(),
                confidence: (data['confidence'] as num).toDouble(),
                emoji: data['emoji'] ?? '🤔',
                message: data['message'] ?? '',
                onDetail: () => context.push(
                  AppRoutes.detailPrediction,
                  extra: data,
                ),
                onRetake: () {
                  context.go(AppRoutes.questionnaire);
                },
              ).animate().fadeIn(delay: 300.ms, duration: 600.ms).scale(
                    begin: const Offset(0.95, 0.95),
                    end: const Offset(1, 1),
                    delay: 300.ms,
                    duration: 600.ms,
                  ),

              const SizedBox(height: 20),

              // Warning card for high stress
              if (level.toLowerCase() == 'tinggi')
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.stressHighBg,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.stressHigh.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.stressHigh.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.warning_rounded,
                          color: AppColors.stressHigh,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Perhatian!',
                              style: AppTextStyles.subtitle2.copyWith(
                                color: AppColors.stressHigh,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Disarankan untuk segera menghubungi konselor atau layanan kesehatan mental kampus.',
                              style: AppTextStyles.bodySmall.copyWith(
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 400.ms)
                    .shake(delay: 800.ms, duration: 500.ms, hz: 2, offset: const Offset(2, 0)),

              const SizedBox(height: 28),

              // Back to dashboard
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.go(AppRoutes.dashboard),
                  icon: const Icon(Icons.home_outlined),
                  label: const Text('Kembali ke Dashboard'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}
