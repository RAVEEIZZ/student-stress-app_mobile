import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes.dart';
import '../providers/questionnaire_provider.dart';

class QuestionnaireIntroScreen extends StatelessWidget {
  const QuestionnaireIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Back Button matching Figma style
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(AppRoutes.dashboard);
                      }
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const ShapeDecoration(
                        color: Color(0xFFF2ECFF),
                        shape: CircleBorder(),
                      ),
                      child: const Center(
                        child: Icon(
                          Iconsax.arrow_left_2_copy,
                          size: 18,
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
                'Kuesioner',
                style: GoogleFonts.openSans(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Prediksi tingkat stres Anda',
                style: GoogleFonts.openSans(
                  color: const Color(0xFF828282),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 28),

              // Main Questionnaire Card (Gradient matching Figma)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                decoration: ShapeDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF5355DE), Color(0xFF2D2E78)],
                  ),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 1,
                      color: Color(0x1E898989),
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x1F000000),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    // Visual/Icon Container
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const ShapeDecoration(
                        color: Color(0x15FFFFFF),
                        shape: CircleBorder(),
                      ),
                      child: const Icon(
                        Iconsax.document_text_copy,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Mulai Kuesioner',
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Jawab 13 pertanyaan untuk mengetahui tingkat stres Anda',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Mulai Sekarang Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<QuestionnaireProvider>().reset();
                          context.push(AppRoutes.questionnaireQuestions);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFDFCFF),
                          foregroundColor: const Color(0xFF4F39F6),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Mulai Sekarang',
                          style: GoogleFonts.openSans(
                            color: const Color(0xFF4F39F6),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Information Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: ShapeDecoration(
                  color: const Color(0xFFF7F7F7),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 1,
                      color: Color(0x1E898989),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informasi',
                      style: GoogleFonts.openSans(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoItem(
                      number: '1',
                      text: 'Kuesioner ini terdiri dari 13 pertanyaan tentang kondisi Anda',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoItem(
                      number: '2',
                      text: 'Pilih jawaban yang paling sesuai dengan kondisi Anda saat ini',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoItem(
                      number: '3',
                      text: 'Hasil prediksi akan ditampilkan setelah semua pertanyaan dijawab',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({required String number, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(top: 2),
          decoration: const ShapeDecoration(
            color: Color(0xFFE2DEFF),
            shape: CircleBorder(),
          ),
          child: Center(
            child: Text(
              number,
              style: GoogleFonts.openSans(
                color: const Color(0xFF5F4FD8),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.openSans(
              color: const Color(0xFF767885),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
