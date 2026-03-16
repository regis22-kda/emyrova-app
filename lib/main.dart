import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/play/play_hub_screen.dart';
import 'presentation/screens/history/history_screen.dart';
import 'presentation/screens/profile/profile_screen.dart';
import 'presentation/screens/question_engine/question_engine_screen.dart';
import 'presentation/screens/question_engine/pass_the_phone_screen.dart';
import 'presentation/screens/question_engine/results_screen.dart';
import 'presentation/screens/roulette/fill_roulette_screen.dart';
import 'presentation/screens/roulette/spinning_roulette_screen.dart';
import 'presentation/screens/roulette/results_screen.dart';
import 'presentation/screens/this_or_that/this_or_that_screen.dart';
import 'presentation/screens/whos_more_likely/whos_more_likely_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  
  runApp(
    const ProviderScope(
      child: EmyrovaApp(),
    ),
  );
}

/// Main application widget
class EmyrovaApp extends StatelessWidget {
  const EmyrovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Emyrova',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: _router,
    );
  }
}

/// GoRouter configuration for app navigation
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    // Home route
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    // Play hub route
    GoRoute(
      path: '/play',
      name: 'play',
      builder: (context, state) => const PlayHubScreen(),
    ),
    // History route
    GoRoute(
      path: '/history',
      name: 'history',
      builder: (context, state) => const HistoryScreen(),
    ),
    // Profile route
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    // Question Engine routes
    GoRoute(
      path: '/question-engine',
      name: 'question-engine',
      builder: (context, state) => const QuestionEngineScreen(),
    ),
    GoRoute(
      path: '/question-engine/pass-turn',
      name: 'question-engine-pass',
      builder: (context, state) => const PassThePhoneScreen(),
    ),
    GoRoute(
      path: '/question-engine/results',
      name: 'question-engine-results',
      builder: (context, state) => const QuestionResultsScreen(),
    ),
    // Roulette routes
    GoRoute(
      path: '/roulette',
      name: 'roulette',
      builder: (context, state) => const FillRouletteScreen(),
    ),
    GoRoute(
      path: '/roulette/spinning',
      name: 'roulette-spinning',
      builder: (context, state) => const SpinningRouletteScreen(),
    ),
    GoRoute(
      path: '/roulette/results',
      name: 'roulette-results',
      builder: (context, state) => const RouletteResultsScreen(),
    ),
    // This or That route
    GoRoute(
      path: '/this-or-that',
      name: 'this-or-that',
      builder: (context, state) => const ThisOrThatScreen(),
    ),
    // Who's More Likely route
    GoRoute(
      path: '/whos-more-likely',
      name: 'whos-more-likely',
      builder: (context, state) => const WhosMoreLikelyScreen(),
    ),
  ],
);