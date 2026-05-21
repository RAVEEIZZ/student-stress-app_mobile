import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

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

    // Determine card background and light text colors dynamically
    Color cardBgColor;
    Color cardTextColor;
    if (level.toLowerCase() == 'rendah') {
      cardBgColor = const Color(0xFF83C400); // Green
      cardTextColor = const Color(0xFFE2F5C5); // Light Green Accent
    } else if (level.toLowerCase() == 'sedang') {
      cardBgColor = const Color(0xFFEEA929); // Orange
      cardTextColor = const Color(0xFFFDE6B9); // Light Orange Accent
    } else {
      cardBgColor = const Color(0xFFF14E4E); // Red
      cardTextColor = const Color(0xFFFFD1D1); // Light Red Accent
    }

    // Calculate sum of Likert answers out of 65 (13 questions * 5 max)
    final payload = data['payload'] as Map<String, dynamic>?;
    int sumScore = 0;
    if (payload != null) {
      for (int i = 1; i <= 13; i++) {
        sumScore += (payload['p$i'] as int? ?? 0);
      }
    } else {
      final scorePercentage = (data['score'] as num?)?.toDouble() ?? 0.0;
      sumScore = ((scorePercentage / 100) * 65).round();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Back Button (Navigates to Dashboard)
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.dashboard),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFF2ECFF),
                        shape: CircleBorder(),
                      ),
                      child: const Center(
                        child: Icon(
                          Iconsax.arrow_left_2_copy,
                          size: 18,
                          color: Color(0xFF3A3747),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Title Section
              Text(
                'Kuesioner',
                style: GoogleFonts.openSans(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Berdasarkan jawaban kuesioner Anda',
                style: GoogleFonts.openSans(
                  color: const Color(0xFF828282),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 28),

              // Main Colored Result Card (Dynamic color matching stress level)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                decoration: ShapeDecoration(
                  color: cardBgColor,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 1,
                      color: Color(0x1E898989),
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x15000000),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    // Level Emoji
                    Text(
                      data['emoji'] ?? '🤔',
                      style: const TextStyle(fontSize: 56),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tingkat Stres',
                      style: GoogleFonts.openSans(
                        color: cardTextColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      level,
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        data['message'] ?? '',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          color: cardTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Score Badge (Sum / 65)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.24),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Skor:  $sumScore/65',
                        style: GoogleFonts.openSans(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms).scale(
                    begin: const Offset(0.95, 0.95),
                    end: const Offset(1, 1),
                  ),
              const SizedBox(height: 24),

              // Detail Prediction Link Button
              GestureDetector(
                onTap: () => context.push(AppRoutes.detailPrediction, extra: data),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1,
                        color: Color(0xFFDFDFDF),
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ketuk untuk lihat detail',
                        style: GoogleFonts.openSans(
                          color: const Color(0xFF7B7B7B),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Iconsax.arrow_right_1_copy,
                        size: 18,
                        color: Color(0xFF7B7B7B),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
              const SizedBox(height: 24),

              // Warning Card for High Stress
              if (level.toLowerCase() == 'tinggi')
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
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
                    .fadeIn(delay: 150.ms, duration: 400.ms)
                    .shake(delay: 300.ms, duration: 500.ms, hz: 2, offset: const Offset(2, 0)),

              // Retake Questionnaire Button (Gradient Matching Figma)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Container(
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF4F3DD7), Color(0xFF8074D4)],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      context.go(AppRoutes.questionnaire);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      'Isi kuesioner lagi',
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}
