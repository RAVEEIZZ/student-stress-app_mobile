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
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // Dosen ID — default dosen pembimbing
  int _selectedDosenId = 2;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nimController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    // Validasi field kosong
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _nimController.text.trim().isEmpty ||
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

    // Validasi password cocok
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

    // Validasi password minimal 6 karakter
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
      dosenId: _selectedDosenId,
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
      // Redirect ke halaman login
      context.go(AppRoutes.login);
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

                  // Back button
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

                  const SizedBox(height: 24),

                  Text('Buat Akun Baru', style: AppTextStyles.heading2)
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.2, end: 0, duration: 400.ms),

                  const SizedBox(height: 8),

                  Text(
                    'Daftar untuk mulai menggunakan aplikasi',
                    style: AppTextStyles.bodySmall.copyWith(fontSize: 14),
                  ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

                  const SizedBox(height: 32),

                  // Name
                  Text('Nama Lengkap', style: AppTextStyles.label),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: 'Masukkan nama lengkap',
                    prefixIcon: Iconsax.user,
                    controller: _nameController,
                  ),

                  const SizedBox(height: 20),

                  // Email
                  Text('Email', style: AppTextStyles.label),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: 'Masukkan email',
                    prefixIcon: Iconsax.sms,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 20),

                  // NIM
                  Text('NIM', style: AppTextStyles.label),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: 'Masukkan NIM',
                    prefixIcon: Iconsax.card,
                    controller: _nimController,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 20),

                  // Dosen Pembimbing
                  Text('Dosen Pembimbing', style: AppTextStyles.label),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.textHint.withOpacity(0.2),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: _selectedDosenId,
                        isExpanded: true,
                        icon: const Icon(Iconsax.arrow_down_1, size: 20),
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textPrimary,
                        ),
                        dropdownColor: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        items: const [
                          DropdownMenuItem(
                            value: 2,
                            child: Text('Dosen Pembimbing 1'),
                          ),
                          DropdownMenuItem(
                            value: 3,
                            child: Text('Dosen Pembimbing 2'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedDosenId = value);
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Password
                  Text('Password', style: AppTextStyles.label),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: 'Masukkan password (min. 6 karakter)',
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

                  const SizedBox(height: 20),

                  // Confirm Password
                  Text('Konfirmasi Password', style: AppTextStyles.label),
                  const SizedBox(height: 8),
                  CustomTextField(
                    hintText: 'Ulangi password',
                    prefixIcon: Iconsax.lock_1,
                    controller: _confirmController,
                    obscureText: _obscureConfirm,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm ? Iconsax.eye_slash : Iconsax.eye,
                        color: AppColors.textHint,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Register button
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) => GradientButton(
                      text: 'Daftar',
                      isLoading: auth.isLoading,
                      onPressed: _handleRegister,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Sudah punya akun? ',
                            style: AppTextStyles.bodySmall),
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Text(
                            'Masuk',
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
