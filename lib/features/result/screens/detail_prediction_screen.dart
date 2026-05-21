import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../models/prediction_model.dart';

class DetailPredictionScreen extends StatelessWidget {
  final Map<String, dynamic>? predictionData;

  const DetailPredictionScreen({super.key, this.predictionData});

  String _formatDate(DateTime date) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  Color _levelColor(String level) {
    switch (level.toLowerCase()) {
      case 'rendah':
      case 'low':
        return AppColors.stressLow;
      case 'sedang':
      case 'moderate':
        return AppColors.stressMedium;
      case 'tinggi':
      case 'high':
        return AppColors.stressHigh;
      default:
        return AppColors.primary;
    }
  }

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'Akademik':
        return const Color(0xFF3B82F6);
      case 'Fisik':
        return const Color(0xFFF43F5E);
      case 'Psikologis':
        return const Color(0xFF8B5CF6);
      case 'Sosial':
        return const Color(0xFFF59E0B);
      default:
        return AppColors.primary;
    }
  }

  Color _categoryBgColor(String cat) {
    switch (cat) {
      case 'Akademik':
        return const Color(0xFFEFF6FF);
      case 'Fisik':
        return const Color(0xFFFFF1F2);
      case 'Psikologis':
        return const Color(0xFFF5F3FF);
      case 'Sosial':
        return const Color(0xFFFFFBEB);
      default:
        return AppColors.primary.withOpacity(0.1);
    }
  }

  IconData _categoryIcon(String cat) {
    switch (cat) {
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

  @override
  Widget build(BuildContext context) {
    final data = predictionData ?? {};
    final level = data['level'] as String? ?? 'Rendah';
    final score = (data['score'] as num?)?.toDouble() ?? 0;
    final confidence = (data['confidence'] as num?)?.toDouble() ?? 0;
    final Map<String, double> categories = {};
    final rawCategories = data['categories'];
    if (rawCategories is Map) {
      rawCategories.forEach((key, value) {
        categories[key.toString()] = (value as num).toDouble();
      });
    } else {
      categories.addAll({'Akademik': 0, 'Fisik': 0, 'Psikologis': 0, 'Sosial': 0});
    }
    final date = data['date'] is DateTime ? data['date'] as DateTime : DateTime.now();
    final recommendation = data['recommendation'] as String? ??
        PredictionModel.getRecommendations(level).join(' ');
    final levelColor = _levelColor(level);

    // score bar: map score (0-100) to 0.0-1.0
    final scoreRatio = (score / 100).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Purple blob top-right (from Figma)
          Positioned(
            top: 45,
            right: -60,
            child: Container(
              width: 200,
              height: 180,
              decoration: const BoxDecoration(
                color: Color(0xFF6856BA),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 75,
            right: 65,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Color(0xFF5243C5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 98,
            right: 85,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Color(0xFF5243C5),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE7E7E7)),
                          ),
                          child: const Icon(
                            Iconsax.arrow_left,
                            size: 18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detail Prediksi',
                        style: AppTextStyles.heading3.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Detail Prediksi tingkat stres Anda',
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    child: Column(
                      children: [
                        // ── Stress Level Card ──────────────────────────
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: levelColor,
                            borderRadius: BorderRadius.circular(19),
                            border: Border.all(
                              color: const Color(0xFFE9E9E9),
                              width: 1,
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Decorative circle inside card
                              Positioned(
                                right: -20,
                                top: -25,
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.12),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tingkat Stres',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.86),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'OpenSans',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    level,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'OpenSans',
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // Score bar
                                  Stack(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: const Color(0xAAE9E9E9),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      FractionallySizedBox(
                                        widthFactor: scoreRatio,
                                        child: Container(
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Skor:  ${score.toStringAsFixed(1)}/100',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.78),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        'Confidence: ${confidence.toStringAsFixed(1)}%',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.78),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 400.ms),

                        const SizedBox(height: 16),

                        // ── Category Card ──────────────────────────────
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(19),
                            border: Border.all(
                              color: const Color(0x1E898989),
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Iconsax.chart_2,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Kategori',
                                    style: AppTextStyles.subtitle2.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ...categories.entries.toList().asMap().entries.map((entry) {
                                final index = entry.key;
                                final cat = entry.value;
                                final catColor = _categoryColor(cat.key);
                                final catBg = _categoryBgColor(cat.key);
                                final catIcon = _categoryIcon(cat.key);
                                final ratio = (cat.value / 100).clamp(0.0, 1.0);
                                // Convert ratio to x/10 display
                                final score10 = (cat.value / 10).round();

                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: index < categories.length - 1 ? 16 : 0,
                                  ),
                                  child: Row(
                                    children: [
                                      // Icon box
                                      Container(
                                        width: 31,
                                        height: 31,
                                        decoration: BoxDecoration(
                                          color: catBg,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Icon(catIcon, color: catColor, size: 16),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cat.key,
                                              style: const TextStyle(
                                                color: Color(0xFF686A80),
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Stack(
                                              children: [
                                                Container(
                                                  height: 7,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFE9E9E9),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                ),
                                                FractionallySizedBox(
                                                  widthFactor: ratio,
                                                  child: Container(
                                                    height: 7,
                                                    decoration: BoxDecoration(
                                                      color: catColor,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '$score10/10',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                        const SizedBox(height: 16),

                        // ── Recommendation Card ───────────────────────
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: const Color(0xFFDFDFDF)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.lamp_charge,
                                    size: 18,
                                    color: levelColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Rekomendasi',
                                    style: AppTextStyles.subtitle2.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                recommendation.isNotEmpty
                                    ? recommendation
                                    : PredictionModel.getRecommendations(level).join(' '),
                                style: const TextStyle(
                                  color: Color(0xFF595959),
                                  fontSize: 12,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: 350.ms, duration: 400.ms),

                        const SizedBox(height: 16),

                        // ── Date info card ────────────────────────────
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: const Color(0xFFDFDFDF)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Iconsax.calendar_1, size: 18, color: AppColors.textSecondary),
                              const SizedBox(width: 10),
                              Text(
                                _formatDate(date),
                                style: AppTextStyles.subtitle2.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: 450.ms, duration: 400.ms),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
