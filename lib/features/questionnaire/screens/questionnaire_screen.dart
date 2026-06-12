import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/routes.dart';

import '../../auth/providers/auth_provider.dart';
import '../../history/providers/history_provider.dart';
import '../models/question_model.dart';
import '../providers/questionnaire_provider.dart';

class QuestionnaireQuestionsScreen extends StatelessWidget {
  const QuestionnaireQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Consumer<QuestionnaireProvider>(
          builder: (context, provider, _) {
            if (provider.isSubmitting) {
              return _buildLoadingState();
            }

            final question = provider.currentQuestion;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom Back Button matching Figma style
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (provider.isFirstQuestion) {
                            context.pop();
                          } else {
                            provider.previousQuestion();
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
                    'Jawab dengan kondisi Anda saat ini',
                    style: GoogleFonts.openSans(
                      color: const Color(0xFF828282),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Progress bar and info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pertanyaan ${provider.currentIndex + 1}/${provider.totalQuestions}',
                            style: GoogleFonts.openSans(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${(provider.progress * 100).toInt()}%',
                            style: GoogleFonts.openSans(
                              color: const Color(0xFF4F39F6),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: provider.progress,
                          minHeight: 8,
                          backgroundColor: const Color(0xFFE2DEFF),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF4F39F6),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Question Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0x1E898989),
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x15000000),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        )
                      ],
                    ),
                    child: Text(
                      question.text,
                      style: GoogleFonts.openSans(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ).animate().fadeIn(duration: 300.ms),
                  const SizedBox(height: 28),

                  // Answer Options
                  if (question.type == QuestionType.faculty)
                    _FacultyPicker(provider: provider)
                  else
                    _LikertScale(provider: provider, question: question),
                  const SizedBox(height: 40),

                  // Next / Submit Button (Premium Gradient)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Container(
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: provider.canGoNext()
                              ? [const Color(0xFF4F3DD7), const Color(0xFF8074D4)]
                              : [Colors.grey.shade400, Colors.grey.shade500],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: provider.canGoNext()
                            ? () async {
                                if (provider.isLastQuestion) {
                                  // Ambil NIM dari AuthProvider
                                  final authProvider = context.read<AuthProvider>();
                                  final nim = authProvider.user?.nim ?? '';

                                  // Guard: pastikan user sudah login
                                  if (nim.isEmpty) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Sesi login tidak valid. Silakan login ulang.'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                    return;
                                  }

                                  // Double Post: Railway → Laravel
                                  final result = await provider.submitAnswers(nim: nim);

                                  if (context.mounted) {
                                    // Update history
                                    context.read<HistoryProvider>().addPrediction(result);
                                    context.go(AppRoutes.result, extra: result);
                                    // Reset form kuesioner setelah navigasi
                                    // Agar history di halaman input kosong kembali
                                    provider.reset();
                                  }
                                } else {
                                  provider.nextQuestion();
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              provider.isLastQuestion ? 'Submit' : 'Selanjutnya',
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              provider.isLastQuestion ? Iconsax.tick_circle_copy : Iconsax.arrow_right_1_copy,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF4F39F6).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Padding(
              padding: EdgeInsets.all(28),
              child: CircularProgressIndicator(
                color: Color(0xFF4F39F6),
                strokeWidth: 3,
              ),
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .shimmer(
                  duration: 1500.ms,
                  color: const Color(0xFF4F39F6).withValues(alpha: 0.1)),
          const SizedBox(height: 28),
          Text(
            'Menganalisis jawaban...',
            style: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'AI sedang memproses prediksi stres Anda',
            style: GoogleFonts.openSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF828282),
            ),
          ),
        ],
      ),
    );
  }
}

class _LikertScale extends StatelessWidget {
  final QuestionnaireProvider provider;
  final QuestionModel question;

  const _LikertScale({required this.provider, required this.question});

  @override
  Widget build(BuildContext context) {
    final selectedAnswer = provider.getLikertAnswer(question.id);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tidak Pernah',
              style: GoogleFonts.openSans(
                color: const Color(0xFF767885),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Selalu',
              style: GoogleFonts.openSans(
                color: const Color(0xFF767885),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(5, (index) {
            final value = index + 1;
            final isSelected = selectedAnswer == value;

            return GestureDetector(
              onTap: () => provider.setLikertAnswer(question.id, value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isSelected ? 56 : 48,
                height: isSelected ? 56 : 48,
                decoration: ShapeDecoration(
                  color: isSelected ? const Color(0xFF4F3DD7) : Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: isSelected ? 2 : 1,
                      color: isSelected ? const Color(0xFF4F3DD7) : const Color(0xFFDFDFDF),
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadows: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF4F3DD7).withValues(alpha: 0.24),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : [
                          const BoxShadow(
                            color: Color(0x05000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          )
                        ],
                ),
                child: Center(
                  child: Text(
                    '$value',
                    style: GoogleFonts.openSans(
                      fontSize: isSelected ? 18 : 16,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : const Color(0xFF7B7B7B),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _FacultyPicker extends StatelessWidget {
  final QuestionnaireProvider provider;

  const _FacultyPicker({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: QuestionModel.faculties.map((faculty) {
        final isSelected = provider.selectedFaculty == faculty;
        return GestureDetector(
          onTap: () => provider.setFaculty(faculty),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: ShapeDecoration(
              color: isSelected ? const Color(0xFF4F3DD7) : Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: isSelected ? 2 : 1,
                  color: isSelected ? const Color(0xFF4F3DD7) : const Color(0xFFDFDFDF),
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              shadows: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF4F3DD7).withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : [
                      const BoxShadow(
                        color: Color(0x05000000),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      )
                    ],
            ),
            child: Text(
              faculty,
              style: GoogleFonts.openSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : const Color(0xFF7B7B7B),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
