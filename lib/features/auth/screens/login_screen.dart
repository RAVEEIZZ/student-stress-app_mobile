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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final auth = context.read<AuthProvider>();
    final success = await auth.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login berhasil! Selamat datang, ${auth.user?.nama ?? ''}'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
      context.go(AppRoutes.dashboard);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error ?? 'Login gagal'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
        ),
      );
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
                  const SizedBox(height: 60),

                  // Logo / Icon
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Iconsax.health,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ).animate().fadeIn(duration: 500.ms).scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1, 1),
                        duration: 500.ms,
                      ),

                  const SizedBox(height: 32),

                  // Title
                  Center(
                    child: Text(
                      'Selamat Datang',
                      style: AppTextStyles.heading1,
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(
                        begin: 0.2,
                        end: 0,
                        delay: 200.ms,
                        duration: 400.ms,
                      ),

                  const SizedBox(height: 8),

                  Center(
                    child: Text(
                      'Masuk untuk memulai prediksi stres',
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 14),
                    ),
                  ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                  const SizedBox(height: 48),

                  // Email field
                  Text('Email', style: AppTextStyles.label),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: 'Masukkan email',
                    prefixIcon: Iconsax.sms,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 20),

                  // Password field
                  Text('Password', style: AppTextStyles.label),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: 'Masukkan password',
                    prefixIcon: Iconsax.lock,
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Iconsax.eye_slash : Iconsax.eye,
                        color: AppColors.textHint,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Forgot password link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push(AppRoutes.forgotPassword),
                      child: Text(
                        'Lupa Password?',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Error message
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) {
                      if (auth.error != null) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.stressHighBg,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Iconsax.warning_2,
                                    color: AppColors.stressHigh, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    auth.error!,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.stressHigh,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  // Login button
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) => GradientButton(
                      text: 'Masuk',
                      isLoading: auth.isLoading,
                      onPressed: _handleLogin,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Register link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum punya akun? ',
                          style: AppTextStyles.bodySmall,
                        ),
                        GestureDetector(
                          onTap: () => context.push(AppRoutes.register),
                          child: Text(
                            'Daftar Sekarang',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
