import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/decorative_circles.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendReset() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.forgotPassword(_emailController.text.trim());
    if (success && mounted) {
      context.go(AppRoutes.resetSuccess);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const DecorativeCircles(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Iconsax.arrow_left, size: 24),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Icon
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Iconsax.lock_1,
                        color: AppColors.primary,
                        size: 40,
                      ),
                    ),
                  ).animate().fadeIn(duration: 500.ms).scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1, 1),
                        duration: 500.ms,
                      ),

                  const SizedBox(height: 32),

                  Center(
                    child: Text('Lupa Password?', style: AppTextStyles.heading2),
                  ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                  const SizedBox(height: 8),

                  Center(
                    child: Text(
                      'Masukkan email Anda dan kami akan mengirim\nlink untuk reset password',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                  const SizedBox(height: 40),

                  Text('Email', style: AppTextStyles.label),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: 'Masukkan email',
                    prefixIcon: Iconsax.sms,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 32),

                  Consumer<AuthProvider>(
                    builder: (context, auth, _) => GradientButton(
                      text: 'Kirim Email Reset',
                      isLoading: auth.isLoading,
                      onPressed: _handleSendReset,
                      icon: Iconsax.send_1,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Center(
                    child: TextButton(
                      onPressed: () => context.pop(),
                      child: Text(
                        'Kembali ke Login',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
