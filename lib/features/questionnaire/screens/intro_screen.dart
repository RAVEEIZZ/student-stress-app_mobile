import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/decorative_circles.dart';
import '../providers/questionnaire_provider.dart';

class QuestionnaireIntroScreen extends StatelessWidget {
  const QuestionnaireIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Text('Kuesioner Stres', style: AppTextStyles.heading2)
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: -0.1, end: 0, duration: 400.ms),

                  const SizedBox(height: 8),

                  Text(
                    'Isi kuesioner untuk mendapatkan prediksi tingkat stres Anda',
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 14),
                  ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

                  const SizedBox(height: 36),

                  // Info illustration
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.25),
                            blurRadius: 32,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Iconsax.clipboard_text,
                        color: Colors.white,
                        size: 56,
                      ),
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 600.ms).scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1, 1),
                        delay: 200.ms,
                        duration: 600.ms,
                      ),

                  const SizedBox(height: 40),

                  // Info cards
                  _InfoCard(
                    icon: Iconsax.document_text,
                    title: '14 Pertanyaan',
                    subtitle: 'Kuesioner terdiri dari 1 pertanyaan pilihan fakultas dan 13 pertanyaan tentang kondisi stres akademik Anda.',
                    delay: 300,
                  ),

                  const SizedBox(height: 14),

                  _InfoCard(
                    icon: Iconsax.timer_1,
                    title: 'Waktu Pengerjaan ~5 Menit',
                    subtitle: 'Jawab setiap pertanyaan dengan skala 1 (Tidak Pernah) sampai 5 (Selalu).',
                    delay: 400,
                  ),

                  const SizedBox(height: 14),

                  _InfoCard(
                    icon: Iconsax.chart_success,
                    title: 'Hasil Prediksi AI',
                    subtitle: 'Jawaban Anda akan dianalisis untuk memprediksi tingkat stres: Rendah, Sedang, atau Tinggi.',
                    delay: 500,
                  ),

                  const SizedBox(height: 36),

                  GradientButton(
                    text: 'Mulai Sekarang',
                    icon: Iconsax.arrow_right_3,
                    onPressed: () {
                      context.read<QuestionnaireProvider>().reset();
                      context.push(AppRoutes.questionnaireQuestions);
                    },
                  ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int delay;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.subtitle2.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                )),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay.ms, duration: 400.ms).slideX(
          begin: 0.05,
          end: 0,
          delay: delay.ms,
          duration: 400.ms,
        );
  }
}
