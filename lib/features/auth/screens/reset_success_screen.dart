import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/routes.dart';
import '../../../core/theme/app_colors.dart';

class ResetSuccessScreen extends StatelessWidget {
  const ResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          // --- Background UI (Lupa Password) ---
          // Darker purple oval top-left
          Positioned(
            left: -30,
            top: -50,
            child: Container(
              width: 160,
              height: 155,
              decoration: const BoxDecoration(color: Color(0xFF4F3DD7), shape: BoxShape.circle),
            ),
          ),
          // White oval top-right
          Positioned(
            right: -40,
            top: 15,
            child: Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            ),
          ),
          Positioned(
            right: 70,
            top: 128,
            child: Container(
              width: 9, height: 9,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            ),
          ),
          Positioned(
            right: 64,
            top: 117,
            child: Container(
              width: 9, height: 9,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 52), // space for back button in real screen
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
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(32, 50, 32, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Lupa Password?',
                            style: TextStyle(
                              color: AppColors.primary, fontSize: 24, 
                              fontWeight: FontWeight.w700, letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Masukkan alamat email yang terdaftar. Kami akan mengirimkan instruksi untuk mengatur ulang password kamu.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black, fontSize: 12, 
                              fontWeight: FontWeight.w400, height: 1.5, letterSpacing: -0.3,
                            ),
                          ),
                          // (Input field & button omitted visually as they'd be behind the overlay anyway)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- Dark Overlay ---
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.16),
          ),

          // --- Popup Card ---
          Center(
            child: Container(
              width: 320,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(39),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon box
                  Container(
                    width: 105,
                    height: 108,
                    decoration: BoxDecoration(
                      color: const Color(0xFFBAB1FF),
                      borderRadius: BorderRadius.circular(27),
                      border: Border.all(
                        color: const Color(0xFF5243C5),
                        width: 7,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Iconsax.send_2,
                        color: Colors.white,
                        size: 44,
                      ),
                    ),
                  ).animate().scale(delay: 100.ms, duration: 400.ms, curve: Curves.easeOutBack),

                  const SizedBox(height: 32),

                  Text(
                    'Email Terkirim!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF595BD4),
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

                  const SizedBox(height: 12),

                  Text(
                    'Silakan cek kotak masuk email kamu untuk\ninstruksi pengaturan ulang kata sandi',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF7D7D7D),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      letterSpacing: -0.3,
                    ),
                  ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

                  const SizedBox(height: 32),

                  // Oke Button
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.login),
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4F39F6),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Center(
                        child: Text(
                          'Oke',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
