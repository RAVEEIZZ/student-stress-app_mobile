import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/providers/auth_provider.dart';
import '../../history/providers/history_provider.dart';
import '../providers/dashboard_provider.dart';

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
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  String _formatTime(DateTime date) {
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  Color _levelColor(String level) {
    switch (level.toLowerCase()) {
      case 'rendah': case 'low': return AppColors.stressLow;
      case 'sedang': case 'moderate': return AppColors.stressMedium;
      case 'tinggi': case 'high': return AppColors.stressHigh;
      default: return AppColors.primary;
    }
  }

  Color _levelBgColor(String level) {
    switch (level.toLowerCase()) {
      case 'rendah': case 'low': return AppColors.stressLowBg;
      case 'sedang': case 'moderate': return AppColors.stressMediumBg;
      case 'tinggi': case 'high': return AppColors.stressHighBg;
      default: return AppColors.primary.withOpacity(0.1);
    }
  }

  Color _levelTextColor(String level) {
    switch (level.toLowerCase()) {
      case 'rendah': case 'low': return const Color(0xFF3A6B00);
      case 'sedang': case 'moderate': return const Color(0xFFB04C00);
      case 'tinggi': case 'high': return const Color(0xFF9B1B1B);
      default: return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final history = context.watch<HistoryProvider>();
    final dashboard = context.watch<DashboardProvider>();

    final recentPredictions = history.predictions.take(3).toList();
    final totalPredictions = history.totalPredictions;
    final lastLevel = history.predictions.isNotEmpty
        ? history.predictions.first['level'] as String
        : '-';

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Stack(
        children: [
          // Large purple oval top-right
          Positioned(
            top: 45,
            right: -50,
            child: Container(
              width: 200,
              height: 180,
              decoration: const BoxDecoration(
                color: Color(0xFF5243C5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 77,
            right: 105,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Color(0xFF5243C5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 92,
            right: 124,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Color(0xFF5243C5),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Purple oval bottom-left
          Positioned(
            bottom: 160,
            left: -50,
            child: Container(
              width: 143,
              height: 134,
              decoration: const BoxDecoration(
                color: Color(0xFF806FFF),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Small dots bottom-left
          Positioned(
            bottom: 115,
            left: 55,
            child: Container(
              width: 21,
              height: 20,
              decoration: const BoxDecoration(
                color: Color(0xFF5243C5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: 94,
            left: 72,
            child: Container(
              width: 10,
              height: 9,
              decoration: const BoxDecoration(
                color: Color(0xFF5243C5),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile icon
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.profile),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2ECFF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Iconsax.user,
                        size: 16,
                        color: Color(0xFF3A3747),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Stat Cards ──────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 141,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0x1E898989)),
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0E7FF),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Iconsax.document_text,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                'Total Prediksi',
                                style: TextStyle(
                                  color: Color(0xFF676767),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$totalPredictions',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Container(
                          height: 141,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0x1E898989)),
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 38,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDBFCE7),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Iconsax.tick_circle,
                                  size: 18,
                                  color: Color(0xFF22C55E),
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                'Prediksi Terakhir',
                                style: TextStyle(
                                  color: Color(0xFF676767),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (lastLevel == '-')
                                Text(
                                  'Belum ada',
                                  style: AppTextStyles.caption,
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _levelBgColor(lastLevel),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    lastLevel,
                                    style: TextStyle(
                                      color: _levelTextColor(lastLevel),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 120.ms, duration: 350.ms),

                  const SizedBox(height: 14),

                  // ── CTA Card ────────────────────────────────────────
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.questionnaire),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0x21737373)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 30,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0E7FF),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Iconsax.add_circle,
                              size: 16,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Isi Kuesioner Baru',
                                  style: TextStyle(
                                    color: Color(0xFF242424),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Prediksi tingkat stres Anda',
                                  style: TextStyle(
                                    color: Color(0xFF9896A8),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Iconsax.arrow_right_3,
                            size: 16,
                            color: Color(0xFF9896A8),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 160.ms, duration: 350.ms),

                  const SizedBox(height: 14),

                  // ── Insight Card ────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: lastLevel != '-'
                          ? _levelBgColor(lastLevel)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: lastLevel != '-'
                            ? _levelColor(lastLevel).withOpacity(0.2)
                            : const Color(0x21737373),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: (lastLevel != '-'
                                    ? _levelColor(lastLevel)
                                    : AppColors.primary)
                                .withOpacity(0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Iconsax.lamp_charge,
                            color: lastLevel != '-'
                                ? _levelColor(lastLevel)
                                : AppColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Insight',
                                style: TextStyle(
                                  color: lastLevel != '-'
                                      ? _levelColor(lastLevel)
                                      : AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              _buildInsightRichText(lastLevel, dashboard),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 350.ms),

                  const SizedBox(height: 20),

                  // ── Prediksi Terbaru ────────────────────────────────
                  const Text(
                    'Prediksi Terbaru',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Empty state
                  if (recentPredictions.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: const Color(0x216D6D6D)),
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
                    ).animate().fadeIn(delay: 250.ms, duration: 350.ms),

                  // Prediction list
                  ...recentPredictions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final pred = entry.value;
                    final level = pred['level'] as String;
                    final date = pred['date'] is DateTime
                        ? pred['date'] as DateTime
                        : DateTime.now();
                    final confidence = (pred['confidence'] as num?)?.toDouble() ?? 0.0;
                    final badgeBg = _levelBgColor(level);
                    final badgeText = _levelTextColor(level);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () => context.push(
                          AppRoutes.detailPrediction,
                          extra: pred,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                color: const Color(0x216D6D6D)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Tanggal',
                                        style: TextStyle(
                                          color: Color(0xFF6A6A6A),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${_formatDate(date)}   ${_formatTime(date)}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: badgeBg,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      level,
                                      style: TextStyle(
                                        color: badgeText,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Confidence: ${confidence.toStringAsFixed(1)}%',
                                    style: const TextStyle(
                                      color: Color(0xFF9896A8),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Iconsax.arrow_right_3,
                                    size: 14,
                                    color: AppColors.textHint,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().fadeIn(
                          delay: (250 + index * 80).ms,
                          duration: 350.ms,
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

  Widget _buildInsightRichText(String level, DashboardProvider dashboard) {
    if (level == '-') {
      return const Text(
        'Lakukan prediksi pertama Anda untuk mendapatkan insight.',
        style: TextStyle(
          color: Color(0xFF979696),
          fontSize: 8,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      );
    }

    final levelColor = _levelColor(level);

    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(
            text: 'Berdasarkan data terakhir, tingkat stres Anda berada di kategori ',
            style: TextStyle(
              color: Color(0xFF979696),
              fontSize: 8,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: level,
            style: TextStyle(
              color: levelColor,
              fontSize: 8,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: '. ${_insightSuffix(level)}',
            style: const TextStyle(
              color: Color(0xFF979696),
              fontSize: 8,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _insightSuffix(String level) {
    switch (level.toLowerCase()) {
      case 'rendah':
      case 'low':
        return 'Tetap jaga keseimbangan aktivitas dan istirahat. 🌟';
      case 'sedang':
      case 'moderate':
        return 'Cobalah untuk mengatur jadwal belajar dan luangkan waktu untuk istirahat.';
      case 'tinggi':
      case 'high':
        return 'Sangat disarankan untuk berkonsultasi dengan konselor profesional. ⚠️';
      default:
        return '';
    }
  }
}
