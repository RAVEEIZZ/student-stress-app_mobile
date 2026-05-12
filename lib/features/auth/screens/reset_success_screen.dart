import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/gradient_button.dart';

class ResetSuccessScreen extends StatelessWidget {
  const ResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Email icon with animated circle
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.stressLowBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Iconsax.sms_tracking,
                    color: AppColors.stressLow,
                    size: 48,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1, 1),
                      duration: 600.ms,
                      curve: Curves.elasticOut,
                    ),

                const SizedBox(height: 32),

                Text(
                  'Email Terkirim! ✉️',
                  style: AppTextStyles.heading2,
                ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                const SizedBox(height: 12),

                Text(
                  'Kami telah mengirim link reset password\nke email Anda. Silakan cek inbox.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 14,
                    height: 1.6,
                  ),
                ).animate().fadeIn(delay: 400.ms, duration: 400.ms),

                const SizedBox(height: 36),

                GradientButton(
                  text: 'Kembali ke Login',
                  onPressed: () => context.go(AppRoutes.login),
                ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
