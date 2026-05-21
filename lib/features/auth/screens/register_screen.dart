import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nimController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _nipDosenController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nimController.dispose();
    _nipDosenController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _nimController.text.trim().isEmpty ||
        _nipDosenController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _confirmController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Semua field harus diisi'),
          backgroundColor: AppColors.stressHigh,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Password tidak cocok'),
          backgroundColor: AppColors.stressHigh,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Password minimal 6 karakter'),
          backgroundColor: AppColors.stressHigh,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final success = await auth.register(
      nama: _nameController.text.trim(),
      email: _emailController.text.trim(),
      nim: _nimController.text.trim(),
      password: _passwordController.text.trim(),
      passwordConfirmation: _confirmController.text.trim(),
      nipDosen: _nipDosenController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Registrasi berhasil! Silakan login.'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
        ),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error ?? 'Registrasi gagal'),
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
                // ── Top Bar ────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Iconsax.arrow_left_2,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Kembali ke login',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(duration: 400.ms),

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
                      padding: const EdgeInsets.fromLTRB(32, 40, 32, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Title
                          Text(
                            'Daftar Akun',
                            style: AppTextStyles.heading2.copyWith(
                              color: AppColors.primary, fontSize: 24, letterSpacing: -0.3,
                            ),
                          ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

                          const SizedBox(height: 32),

                          // Fields
                          _buildInputField(
                            controller: _nameController,
                            hint: 'Nama Lengkap',
                            icon: Iconsax.user,
                          ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

                          const SizedBox(height: 16),

                          _buildInputField(
                            controller: _emailController,
                            hint: 'Email',
                            icon: Iconsax.sms,
                            keyboardType: TextInputType.emailAddress,
                          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                          const SizedBox(height: 16),

                          _buildInputField(
                            controller: _nimController,
                            hint: 'NIM',
                            icon: Iconsax.card,
                            keyboardType: TextInputType.number,
                          ).animate().fadeIn(delay: 250.ms, duration: 400.ms),

                          const SizedBox(height: 16),
                          
                          _buildInputField(
                            controller: _nipDosenController,
                            hint: 'NIP Dosen Wali',
                            icon: Iconsax.teacher,
                            keyboardType: TextInputType.number,
                          ).animate().fadeIn(delay: 275.ms, duration: 400.ms),

                          const SizedBox(height: 16),

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
                          ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                          const SizedBox(height: 16),

                          _buildInputField(
                            controller: _confirmController,
                            hint: 'Konfirmasi Password',
                            icon: Iconsax.lock_1,
                            obscure: _obscureConfirm,
                            suffix: GestureDetector(
                              onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
                              child: Icon(
                                _obscureConfirm ? Iconsax.eye_slash : Iconsax.eye,
                                color: const Color(0xFFB7B7B7), size: 18,
                              ),
                            ),
                          ).animate().fadeIn(delay: 350.ms, duration: 400.ms),

                          const SizedBox(height: 32),

                          // Register button
                          Consumer<AuthProvider>(
                            builder: (context, auth, _) => GestureDetector(
                              onTap: auth.isLoading ? null : _handleRegister,
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
                                          'Daftar',
                                          style: TextStyle(
                                            color: Colors.white, fontSize: 18,
                                            fontWeight: FontWeight.w700, letterSpacing: -0.3,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ).animate().fadeIn(delay: 400.ms, duration: 400.ms),

                          const SizedBox(height: 24),

                          // Login link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Sudah punya akun? ',
                                style: TextStyle(
                                  color: AppColors.primary, fontSize: 12,
                                  fontWeight: FontWeight.w400, letterSpacing: -0.3,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => context.pop(),
                                child: const Text(
                                  'Masuk disini',
                                  style: TextStyle(
                                    color: AppColors.primary, fontSize: 12,
                                    fontWeight: FontWeight.w600, letterSpacing: -0.3,
                                  ),
                                ),
                              ),
                            ],
                          ).animate().fadeIn(delay: 450.ms, duration: 400.ms),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: AppTextStyles.body.copyWith(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFFBABABA), fontSize: 13,
            fontWeight: FontWeight.w600, letterSpacing: -0.3,
          ),
          prefixIcon: Icon(icon, color: const Color(0xFFBABABA), size: 18),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
