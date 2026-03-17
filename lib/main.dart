import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/services/auth_service.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/screens/history/history_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/play/play_hub_screen.dart';
import 'presentation/screens/profile/profile_screen.dart';
import 'presentation/screens/question_engine/pass_the_phone_screen.dart';
import 'presentation/screens/question_engine/question_engine_screen.dart';
import 'presentation/screens/question_engine/results_screen.dart';
import 'presentation/screens/roulette/fill_roulette_screen.dart';
import 'presentation/screens/roulette/results_screen.dart';
import 'presentation/screens/roulette/spinning_roulette_screen.dart';
import 'presentation/screens/this_or_that/this_or_that_screen.dart';
import 'presentation/screens/whos_more_likely/whos_more_likely_screen.dart';
import 'presentation/screens/room/create_room_screen.dart';
import 'presentation/screens/room/join_room_screen.dart';
import 'presentation/screens/room/waiting_room_screen.dart';
import 'presentation/screens/room/multiplayer_results_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize authentication
  final authService = AuthService();
  final authResult = await _initializeAuth(authService);

  runApp(
    ProviderScope(
      overrides: [
        authStateNotifierProvider.overrideWith((ref) {
          final notifier = AuthStateNotifier();
          notifier.state = authResult;
          return notifier;
        }),
      ],
      child: const EmyrovaApp(),
    ),
  );
}

/// Initializes authentication and returns the auth state
Future<AuthState> _initializeAuth(AuthService authService) async {
  try {
    final uid = await authService.getOrCreateUser();
    return AuthState.authenticated(uid);
  } catch (_) {
    return const AuthState.error('Failed to initialize authentication');
  }
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
    // Room routes - Multiplayer
    GoRoute(
      path: '/room/create',
      name: 'room-create',
      builder: (context, state) => const CreateRoomScreen(),
    ),
    GoRoute(
      path: '/room/join',
      name: 'room-join',
      builder: (context, state) => const JoinRoomScreen(),
    ),
    GoRoute(
      path: '/room/waiting',
      name: 'room-waiting',
      builder: (context, state) => const WaitingRoomScreen(),
    ),
    GoRoute(
      path: '/room/results',
      name: 'room-results',
      builder: (context, state) => const MultiplayerResultsScreen(),
    ),
  ],
);
