import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/abhaya_shell.dart';

// Onboarding
import 'screens/onboarding/welcome_screen.dart';
import 'screens/onboarding/signup_screen.dart';
import 'screens/onboarding/login_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/onboarding/name_screen.dart';
import 'screens/onboarding/interests_screen.dart';
import 'screens/onboarding/profile_setup_screen.dart';

// Home & Profile
import 'screens/home/notifications_screen.dart';
import 'screens/home/todays_plan_screen.dart';
import 'screens/home/progress_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/edit_profile_screen.dart';

// Chat
import 'screens/chat/chat_centre_screen.dart';
import 'screens/chat/chat_list_screen.dart';
import 'screens/chat/chat_screen.dart';
import 'screens/chat/ai_ai_chat_screen.dart';
import 'screens/chat/choose_mode_screen.dart';
import 'screens/chat/choose_scenario_screen.dart';
import 'screens/chat/listener_chat_screen.dart';

// Exams
import 'screens/exams/exam_setup_screen.dart';
import 'screens/exams/exam_question_screen.dart';
import 'screens/exams/exam_result_screen.dart';
import 'screens/exams/exam_history_screen.dart';

// Wellbeing
import 'screens/wellbeing/wellbeing_screen.dart';
import 'screens/wellbeing/breathing_screen.dart';
import 'screens/wellbeing/calm_audio_screen.dart';
import 'screens/wellbeing/journal_screen.dart';
import 'screens/wellbeing/motivation_screen.dart';

// Scenarios
import 'screens/scenarios/scenarios_screen.dart';
import 'screens/scenarios/scenario_detail_screen.dart';
import 'screens/scenarios/scenario_step_screen.dart';
import 'screens/scenarios/scenario_complete_screen.dart';

// Diagrams
import 'screens/diagrams/diagram_trainer_screen.dart';
import 'screens/diagrams/diagram_history_screen.dart';
import 'screens/diagrams/diagram_result_screen.dart';
import 'screens/diagrams/generate_diagram_screen.dart';
import 'screens/diagrams/upload_diagram_screen.dart';

// Learn
import 'screens/learn/notes_screen.dart';
import 'screens/learn/notes_buddy_screen.dart';
import 'screens/learn/flashcards_screen.dart';
import 'screens/learn/past_papers_screen.dart';
import 'screens/learn/question_predictor_screen.dart';
import 'screens/learn/subject_notes_screen.dart';
import 'screens/learn/activity_history_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const AbhayaApp());
}

class AbhayaApp extends StatelessWidget {
  const AbhayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Abhaya – Nursing Buddy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: '/welcome',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          // Onboarding & Auth
          case '/welcome':
            return _fadeRoute(const WelcomeScreen(), settings);
          case '/signup':
            return _slideRoute(const SignupScreen(), settings);
          case '/login':
            return _slideRoute(const LoginScreen(), settings);
          case '/onboarding':
            return _fadeRoute(const OnboardingScreen(), settings);
          case '/name-setup':
            return _slideRoute(const NameScreen(), settings);
          case '/interests':
            return _slideRoute(const InterestsScreen(), settings);
          case '/profile-setup':
            return _slideRoute(const ProfileSetupScreen(), settings);

          // Shell / Main Dashboard
          case '/home':
            return _fadeRoute(const AbhayaShell(), settings);

          // Chat routes
          case '/chat':
            final args = settings.arguments as Map<String, dynamic>?;
            return _slideRoute(
              ChatScreen(
                character: args?['character'] ?? 'Dr. Meera Nair',
                mode: args?['mode'] ?? 'Story mode',
                scenario: args?['scenario'] ?? 'Learn a topic',
              ),
              settings,
            );
          case '/chat-centre':
            return _slideRoute(const ChatCentreScreen(), settings);
          case '/chat-list':
            return _slideRoute(const ChatListScreen(), settings);
          case '/ai-chat':
            return _slideRoute(const AiAiChatScreen(), settings);
          case '/choose-mode':
            return _slideRoute(const ChooseModeScreen(), settings);
          case '/choose-scenario':
            return _slideRoute(const ChooseScenarioScreen(), settings);
          case '/listener-chat':
            return _slideRoute(const ListenerChatScreen(), settings);

          // Exam routes
          case '/exam-setup':
            return _slideRoute(const ExamSetupScreen(), settings);
          case '/exam-question':
            return _slideRoute(const ExamQuestionScreen(), settings);
          case '/exam-result':
            return _slideRoute(const ExamResultScreen(), settings);
          case '/exam-history':
            return _slideRoute(const ExamHistoryScreen(), settings);

          // Wellbeing routes
          case '/wellbeing':
            return _slideRoute(const WellbeingScreen(), settings);
          case '/breathing':
            return _slideRoute(const BreathingScreen(), settings);
          case '/calm-audio':
            return _slideRoute(const CalmAudioScreen(), settings);
          case '/journal':
            return _slideRoute(const JournalScreen(), settings);
          case '/motivation':
            return _slideRoute(const MotivationScreen(), settings);

          // Scenarios
          case '/scenarios':
            return _slideRoute(const ScenariosScreen(), settings);
          case '/scenario-detail':
            return _slideRoute(const ScenarioDetailScreen(), settings);
          case '/scenario-step':
            return _slideRoute(const ScenarioStepScreen(), settings);
          case '/scenario-complete':
            return _slideRoute(const ScenarioCompleteScreen(), settings);

          // Diagram Trainer
          case '/diagram-trainer':
            return _slideRoute(const DiagramTrainerScreen(), settings);
          case '/diagram-history':
            return _slideRoute(const DiagramHistoryScreen(), settings);
          case '/diagram-result':
            return _slideRoute(const DiagramResultScreen(), settings);
          case '/generate-diagram':
            return _slideRoute(const GenerateDiagramScreen(), settings);
          case '/upload-diagram':
            return _slideRoute(const UploadDiagramScreen(), settings);

          // Learn Modules
          case '/notes':
            return _slideRoute(const NotesScreen(), settings);
          case '/notes-buddy':
            return _slideRoute(const NotesBuddyScreen(), settings);
          case '/flashcards':
            return _slideRoute(const FlashcardsScreen(), settings);
          case '/past-papers':
            return _slideRoute(const PastPapersScreen(), settings);
          case '/question-predictor':
            return _slideRoute(const QuestionPredictorScreen(), settings);
          case '/subject-notes':
            return _slideRoute(const SubjectNotesScreen(), settings);
          case '/activity-history':
            return _slideRoute(const ActivityHistoryScreen(), settings);

          // Home & Profile Sub-screens
          case '/notifications':
            return _slideRoute(const NotificationsScreen(), settings);
          case '/todays-plan':
            return _slideRoute(const TodaysPlanScreen(), settings);
          case '/progress':
            return _slideRoute(const ProgressScreen(), settings);
          case '/profile':
            return _slideRoute(const ProfileScreen(), settings);
          case '/edit-profile':
            return _slideRoute(const EditProfileScreen(), settings);

          default:
            return _fadeRoute(const AbhayaShell(), settings);
        }
      },
    );
  }

  PageRoute _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  PageRoute _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final slide = Tween<Offset>(
          begin: const Offset(1.0, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
        return SlideTransition(position: slide, child: child);
      },
    );
  }
}
