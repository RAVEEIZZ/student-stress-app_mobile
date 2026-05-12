import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class StressCard extends StatelessWidget {
  final String level; // 'Rendah', 'Sedang', 'Tinggi'
  final double score;
  final double confidence;
  final String emoji;
  final String message;
  final VoidCallback? onDetail;
  final VoidCallback? onRetake;

  const StressCard({
    super.key,
    required this.level,
    required this.score,
    required this.confidence,
    required this.emoji,
    required this.message,
    this.onDetail,
    this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.stressColor(level);
    final bgColor = AppColors.stressBgColor(level);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              'Tingkat Stres $level',
              style: AppTextStyles.subtitle1.copyWith(color: color),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${score.toStringAsFixed(1)}%',
            style: AppTextStyles.heading1.copyWith(
              color: color,
              fontSize: 44,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Confidence: ${confidence.toStringAsFixed(1)}%',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              if (onDetail != null)
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDetail,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: color,
                      side: BorderSide(color: color),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Lihat Detail'),
                  ),
                ),
              if (onDetail != null && onRetake != null)
                const SizedBox(width: 12),
              if (onRetake != null)
                Expanded(
                  child: ElevatedButton(
                    onPressed: onRetake,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('Isi Lagi'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
