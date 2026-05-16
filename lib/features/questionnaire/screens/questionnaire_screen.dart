import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/gradient_button.dart';
import '../models/question_model.dart';
import '../providers/questionnaire_provider.dart';

class QuestionnaireQuestionsScreen extends StatelessWidget {
  const QuestionnaireQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<QuestionnaireProvider>(
          builder: (context, provider, _) {
            if (provider.isSubmitting) {
              return _buildLoadingState();
            }

            final question = provider.currentQuestion;

            return Column(
              children: [
                // Top bar with back + progress
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 24, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (provider.isFirstQuestion) {
                            context.pop();
                          } else {
                            provider.previousQuestion();
                          }
                        },
                        icon: const Icon(Iconsax.arrow_left, size: 22),
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Pertanyaan ${provider.currentIndex + 1}/${provider.totalQuestions}',
                                  style: AppTextStyles.caption.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${(provider.progress * 100).toInt()}%',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.primary,
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
                                backgroundColor:
                                    AppColors.primary.withValues(alpha: 0.1),
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Label badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    question.label,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Question card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      question.text,
                      style: AppTextStyles.subtitle1.copyWith(
                        height: 1.6,
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ).animate().fadeIn(duration: 300.ms),

                const SizedBox(height: 36),

                // Answer options
                if (question.type == QuestionType.faculty)
                  _FacultyPicker(provider: provider)
                else
                  _LikertScale(provider: provider, question: question),

                const Spacer(),

                // Next / Submit button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                  child: GradientButton(
                    text: provider.isLastQuestion ? 'Submit' : 'Selanjutnya',
                    icon: provider.isLastQuestion
                        ? Iconsax.tick_circle
                        : Iconsax.arrow_right_3,
                    onPressed: provider.canGoNext()
                        ? () async {
                            if (provider.isLastQuestion) {
                              final result = await provider.submitAnswers();
                              if (context.mounted) {
                                context.go(AppRoutes.result, extra: result);
                              }
                            } else {
                              provider.nextQuestion();
                            }
                          }
                        : () {},
                  ),
                ),
              ],
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
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Padding(
              padding: EdgeInsets.all(28),
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 3,
              ),
            ),
          )
              .animate(onPlay: (c) => c.repeat())
              .shimmer(
                  duration: 1500.ms,
                  color: AppColors.primary.withValues(alpha: 0.1)),
          const SizedBox(height: 28),
          Text('Menganalisis jawaban...', style: AppTextStyles.subtitle1),
          const SizedBox(height: 8),
          Text(
            'AI sedang memproses prediksi stres Anda',
            style: AppTextStyles.bodySmall,
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tidak Pernah',
                style: AppTextStyles.caption.copyWith(fontSize: 11),
              ),
              Text(
                'Selalu',
                style: AppTextStyles.caption.copyWith(fontSize: 11),
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
                  width: isSelected ? 60 : 54,
                  height: isSelected ? 60 : 54,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color:
                          isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Center(
                    child: Text(
                      '$value',
                      style: TextStyle(
                        fontSize: isSelected ? 20 : 18,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _FacultyPicker extends StatelessWidget {
  final QuestionnaireProvider provider;

  const _FacultyPicker({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: QuestionModel.faculties.map((faculty) {
          final isSelected = provider.selectedFaculty == faculty;
          return GestureDetector(
            onTap: () => provider.setFaculty(faculty),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Text(
                faculty,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
