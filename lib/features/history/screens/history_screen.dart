import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
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
      '', 'jan', 'feb', 'mar', 'apr', 'mei', 'jun',
      'jul', 'agu', 'sep', 'okt', 'nov', 'des'
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryProvider>();

    // Calculate dynamic stats
    final totalPredictions = history.predictions.length;
    final lastPredictionLevel = history.predictions.isNotEmpty
        ? history.predictions.first['level'] as String
        : '-';

    String avgScore = '-';
    if (history.predictions.isNotEmpty) {
      final total = history.predictions
          .map((p) => (p['score'] as num?)?.toDouble() ?? 0.0)
          .reduce((a, b) => a + b);
      final avg = total / history.predictions.length;
      avgScore = '${avg.toStringAsFixed(0)}%';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            final nim = context.read<AuthProvider>().user?.nim ?? '';
            if (nim.isNotEmpty) {
              await context.read<HistoryProvider>().refresh(nim);
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                        width: 24,
                        height: 24,
                        decoration: const ShapeDecoration(
                          color: Color(0xFFF2ECFF),
                          shape: CircleBorder(),
                        ),
                        child: const Center(
                          child: Icon(
                            Iconsax.arrow_left_2_copy,
                            size: 12,
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
                  'Riwayat',
                  style: GoogleFonts.openSans(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  'Riwayat Prediksi tingkat stres Anda',
                  style: GoogleFonts.openSans(
                    color: const Color(0xFF828282),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),

                // 3 Horizontal Info Cards (Total Prediksi, Terakhir, Rata-rata)
                Row(
                  children: [
                    _buildStatCard(
                      label: 'Total Prediksi',
                      value: '$totalPredictions',
                      fontSize: 16,
                    ),
                    const SizedBox(width: 10),
                    _buildStatCard(
                      label: 'Terakhir',
                      value: lastPredictionLevel,
                      fontSize: 14,
                    ),
                    const SizedBox(width: 10),
                    _buildStatCard(
                      label: 'Rata - rata',
                      value: avgScore,
                      fontSize: 15,
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 28),

                // Section List Header
                Text(
                  'Semua Prediksi',
                  style: GoogleFonts.openSans(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                // Loading State
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
                // Empty State
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
                  ).animate().fadeIn(duration: 400.ms)
                // Error State
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
                // History List
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: history.predictions.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final pred = history.predictions[index];
                      final level = pred['level'] as String;
                      final dateObj = pred['date'] is DateTime
                          ? pred['date'] as DateTime
                          : DateTime.now();

                      // Custom Dynamic Status Badge Colors
                      Color badgeBgColor;
                      Color badgeTextColor;
                      Color badgeDotColor;
                      String displayLevel;

                      if (level.toLowerCase() == 'rendah' || level.toLowerCase() == 'low') {
                        badgeBgColor = const Color(0xFFDCFCE7); // Light Green
                        badgeTextColor = const Color(0xFF15803D); // Dark Green
                        badgeDotColor = const Color(0xFF22C55E); // Bright Green Dot
                        displayLevel = 'Rendah';
                      } else if (level.toLowerCase() == 'sedang' || level.toLowerCase() == 'moderate') {
                        badgeBgColor = const Color(0xFFFEF9C2); // Light Yellow
                        badgeTextColor = const Color(0xFFB04C00); // Dark Orange
                        badgeDotColor = const Color(0xFFFFC004); // Bright Orange Dot
                        displayLevel = 'Sedang';
                      } else {
                          badgeBgColor = const Color(0xFFFEE2E2); // Light Red
                        badgeTextColor = const Color(0xFF991B1B); // Dark Red
                        badgeDotColor = const Color(0xFFEF4444); // Bright Red Dot
                        displayLevel = 'Tinggi';
                      }

                      // Score percentage (0-100)
                      final scorePercentage = (pred['score'] as num?)?.toDouble() ?? 0.0;

                      final confidenceVal = (pred['confidence'] as num?)?.toDouble() ?? 92.5;

                      return Container(
                        height: 110,
                        width: double.infinity,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              color: Color(0x1E898989),
                            ),
                            borderRadius: BorderRadius.circular(19),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top row: Date, Time & Status Badge
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 9, 16, 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _formatDate(dateObj).toLowerCase(),
                                        style: GoogleFonts.openSans(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _formatTime(dateObj),
                                        style: GoogleFonts.openSans(
                                          color: const Color(0xFF8F8F8F),
                                          fontSize: 8,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Status Badge matching Figma dot style
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: ShapeDecoration(
                                      color: badgeBgColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 5,
                                          height: 5,
                                          decoration: ShapeDecoration(
                                            color: badgeDotColor,
                                            shape: const CircleBorder(),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          displayLevel,
                                          style: GoogleFonts.openSans(
                                            color: badgeTextColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Skor',
                                              style: GoogleFonts.openSans(
                                                color: const Color(0xFFA2A2A2),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${scorePercentage.toStringAsFixed(1)}/100',
                                              style: GoogleFonts.openSans(
                                                color: Colors.black,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Thin Divider
                            Container(
                              height: 1,
                              color: const Color(0xFFEDEDED),
                              margin: const EdgeInsets.symmetric(horizontal: 14),
                            ),

                            // Bottom row: Confidence, Score & Detail button
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 7, 16, 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      // Confidence Column
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Confidence',
                                            style: GoogleFonts.openSans(
                                              color: const Color(0xFFA2A2A2),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${confidenceVal.toStringAsFixed(2)}%',
                                            style: GoogleFonts.openSans(
                                              color: Colors.black,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                  // Detail click button
                                  GestureDetector(
                                    onTap: () => context.push(
                                      AppRoutes.detailPrediction,
                                      extra: pred,
                                    ),
                                    child: Container(
                                      color: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                      child: Text(
                                        'Detail',
                                        style: GoogleFonts.openSans(
                                          color: const Color(0xFF4F39F6),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(
                            delay: (100 + index * 60).ms,
                            duration: 400.ms,
                          );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required double fontSize,
  }) {
    return Expanded(
      child: Container(
        height: 53,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1,
              color: Color(0xFFF1F1F1),
            ),
            borderRadius: BorderRadius.circular(11),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                color: const Color(0xFF82889C),
                fontSize: 8,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.openSans(
                color: Colors.black,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
