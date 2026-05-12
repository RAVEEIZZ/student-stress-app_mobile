import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'routes.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/auth/screens/reset_success_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/questionnaire/screens/intro_screen.dart';
import '../features/questionnaire/screens/questionnaire_screen.dart';
import '../features/result/screens/result_screen.dart';
import '../features/result/screens/detail_prediction_screen.dart';
import '../features/history/screens/history_screen.dart';
import '../features/notification/screens/notification_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../navigation/bottom_nav_shell.dart';
import '../core/theme/app_theme.dart';

class StressApp extends StatelessWidget {
  const StressApp({super.key});

  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
      // Auth routes (no bottom nav)
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetSuccess,
        builder: (context, state) => const ResetSuccessScreen(),
      ),

      // Main app with bottom nav shell
      ShellRoute(
        builder: (context, state, child) => BottomNavShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.questionnaire,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: QuestionnaireIntroScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.history,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HistoryScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.notification,
            pageBuilder: (context, state) => NoTransitionPage(
              child: NotificationScreen(),
            ),
          ),
        ],
      ),

      // Full-screen routes (no bottom nav)
      GoRoute(
        path: AppRoutes.questionnaireQuestions,
        builder: (context, state) => const QuestionnaireQuestionsScreen(),
      ),
      GoRoute(
        path: AppRoutes.result,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ResultScreen(predictionData: extra);
        },
      ),
      GoRoute(
        path: AppRoutes.detailPrediction,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return DetailPredictionScreen(predictionData: extra);
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Student Stress Predictor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}
