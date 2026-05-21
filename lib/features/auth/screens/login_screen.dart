import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
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
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          // Darker purple oval top-left
          Positioned(
            left: -30,
            top: -50,
            child: Container(
              width: 160,
              height: 155,
              decoration: const BoxDecoration(
                color: Color(0xFF4F3DD7),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // White oval top-right
          Positioned(
            right: -40,
            top: 15,
            child: Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Small white dots
          Positioned(
            right: 70,
            top: 128,
            child: Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            ),
          ),
          Positioned(
            right: 64,
            top: 117,
            child: Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Purple header ────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 50, 32, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: 'Halo',
                            style: AppTextStyles.heading1.copyWith(
                              color: Colors.white, fontSize: 40, letterSpacing: -0.3,
                            ),
                          ),
                          TextSpan(
                            text: '!',
                            style: AppTextStyles.heading1.copyWith(
                              color: Colors.white, fontSize: 27, letterSpacing: -0.3,
                            ),
                          ),
                        ]),
                      ).animate().fadeIn(duration: 400.ms),
                      const SizedBox(height: 12),
                      Text(
                        'Yuk login untuk memulai...',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white, fontSize: 14, letterSpacing: -0.3,
                        ),
                      ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // ── White card bottom ────────────────────────────
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF6F6F6),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(52),
                        topRight: Radius.circular(52),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(32, 32, 32, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Login title
                          Text(
                            'Login',
                            style: AppTextStyles.heading2.copyWith(
                              color: AppColors.primary, fontSize: 24, letterSpacing: -0.3,
                            ),
                          ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

                          const SizedBox(height: 32),

                          // Email
                          _buildInputField(
                            controller: _emailController,
                            hint: 'Email',
                            icon: Iconsax.sms,
                            keyboardType: TextInputType.emailAddress,
                          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                          const SizedBox(height: 18),

                          // Password
                          _buildInputField(
                            controller: _passwordController,
                            hint: 'Password',
                            icon: Iconsax.lock,
                            obscure: _obscurePassword,
                            suffix: GestureDetector(
                              onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                              child: Icon(
                                _obscurePassword ? Iconsax.eye_slash : Iconsax.eye,
                                color: const Color(0xFFB7B7B7), size: 18,
                              ),
                            ),
                          ).animate().fadeIn(delay: 240.ms, duration: 400.ms),

                          // Lupa password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => context.push(AppRoutes.forgotPassword),
                              style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8)),
                              child: const Text(
                                'Lupa password',
                                style: TextStyle(
                                  color: Color(0xFF4F3DD7), fontSize: 12,
                                  fontWeight: FontWeight.w400, letterSpacing: -0.3,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Error
                          Consumer<AuthProvider>(
                            builder: (context, auth, _) {
                              if (auth.error == null) return const SizedBox.shrink();
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.stressHighBg,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(children: [
                                    const Icon(Iconsax.warning_2, color: AppColors.stressHigh, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(auth.error!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.stressHigh))),
                                  ]),
                                ),
                              );
                            },
                          ),

                          // Login button
                          Consumer<AuthProvider>(
                            builder: (context, auth, _) => GestureDetector(
                              onTap: auth.isLoading ? null : _handleLogin,
                              child: Container(
                                width: double.infinity,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: Center(
                                  child: auth.isLoading
                                      ? const SizedBox(
                                          width: 22, height: 22,
                                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                        )
                                      : const Text(
                                          'Login',
                                          style: TextStyle(
                                            color: Colors.white, fontSize: 18,
                                            fontWeight: FontWeight.w700, letterSpacing: -0.3,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                          const SizedBox(height: 40),

                          // Register link
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Belum punya akun? ',
                                  style: TextStyle(
                                    color: Color(0xFFAAAAAA), fontSize: 12,
                                    fontWeight: FontWeight.w400, letterSpacing: -0.3,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => context.push(AppRoutes.register),
                                  child: const Text(
                                    'Daftar disini',
                                    style: TextStyle(
                                      color: AppColors.primary, fontSize: 12,
                                      fontWeight: FontWeight.w600, letterSpacing: -0.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(delay: 350.ms, duration: 400.ms),
                        ],
                      ),
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.90),
        borderRadius: BorderRadius.circular(13),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: AppTextStyles.body.copyWith(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFFB7B7B7), fontSize: 13,
            fontWeight: FontWeight.w600, letterSpacing: -0.3,
          ),
          prefixIcon: Icon(icon, color: const Color(0xFFB7B7B7), size: 18),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
