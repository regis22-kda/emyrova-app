import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/auth_service.dart';
import '../../data/datasources/firebase_question_datasource.dart';
import '../../data/datasources/firebase_room_datasource.dart';
import '../../data/repositories/question_repository_impl.dart';
import '../../data/repositories/room_repository_impl.dart';
import '../../domain/entities/game_session.dart';
import '../../domain/entities/player.dart';
import '../../domain/entities/question.dart';
import '../../domain/repositories/content_repository.dart';
import '../../domain/repositories/room_repository.dart';
import '../../domain/usecases/compare_answers.dart';
import '../../domain/usecases/get_next_question.dart';

/// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Question data source provider (Firebase)
final questionDataSourceProvider = Provider<FirebaseQuestionDataSource>((ref) {
  return FirebaseQuestionDataSource();
});

/// Room data source provider (Firebase)
final roomDataSourceProvider = Provider<FirebaseRoomDataSource>((ref) {
  return FirebaseRoomDataSource();
});

/// Repository provider (using Firebase data source)
final contentRepositoryProvider = Provider<IContentRepository>((ref) {
  return QuestionRepositoryImpl(
    dataSource: ref.watch(questionDataSourceProvider),
  );
});

/// Room repository provider
final roomRepositoryProvider = Provider<IRoomRepository>((ref) {
  return RoomRepositoryImpl(dataSource: ref.watch(roomDataSourceProvider));
});

/// Use case providers
final getNextQuestionProvider = Provider<GetNextQuestion>((ref) {
  return GetNextQuestion(ref.watch(contentRepositoryProvider));
});

final compareAnswersProvider = Provider<CompareAnswers>((ref) {
  return const CompareAnswers();
});

/// Provider for loading questions with state management
final loadQuestionsProvider = FutureProvider<List<Question>>((ref) async {
  final repository = ref.watch(contentRepositoryProvider);
  return repository.getQuestionsByCategory('');
});

/// Provider for loading a random question
final loadRandomQuestionProvider = FutureProvider<Question>((ref) async {
  final repository = ref.watch(contentRepositoryProvider);
  return repository.getRandomQuestion();
});

/// Provider for loading questions by category
final loadQuestionsByCategoryProvider =
    FutureProvider.family<List<Question>, String>((ref, category) async {
  final repository = ref.watch(contentRepositoryProvider);
  return repository.getQuestionsByCategory(category);
});

/// Game session state notifier
class GameSessionNotifier extends StateNotifier<GameSession> {
  GameSessionNotifier()
    : super(
        const GameSession(
          id: 'session_1',
          players: [
            Player(id: 'player_1', name: 'Alex', avatarColor: '#FF9800'),
            Player(id: 'player_2', name: 'Sarah', avatarColor: '#E91E63'),
          ],
        ),
      );

  void nextPlayer() {
    state = state.nextPlayer();
  }

  void addAnswer(String answer) {
    state = state.addAnswer(state.currentPlayer.id, answer);
  }

  void nextRound() {
    state = state.nextRound();
  }

  void resetSession() {
    state = const GameSession(
      id: 'session_1',
      players: [
        Player(id: 'player_1', name: 'Alex', avatarColor: '#FF9800'),
        Player(id: 'player_2', name: 'Sarah', avatarColor: '#E91E63'),
      ],
    );
  }
}

final gameSessionProvider =
    StateNotifierProvider<GameSessionNotifier, GameSession>((ref) {
      return GameSessionNotifier();
    });

/// Current question provider
class CurrentQuestionNotifier extends StateNotifier<Question?> {
  CurrentQuestionNotifier() : super(null);

  void setQuestion(Question question) {
    state = question;
  }

  void clear() {
    state = null;
  }
}

final currentQuestionProvider =
    StateNotifierProvider<CurrentQuestionNotifier, Question?>((ref) {
      return CurrentQuestionNotifier();
    });

/// Game state enum
enum GameState { notStarted, playing, revealing, complete }

/// Game state notifier
class GameStateNotifier extends StateNotifier<GameState> {
  GameStateNotifier() : super(GameState.notStarted);

  void start() {
    state = GameState.playing;
  }

  void reveal() {
    state = GameState.revealing;
  }

  void complete() {
    state = GameState.complete;
  }

  void reset() {
    state = GameState.notStarted;
  }
}

final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((
  ref,
) {
  return GameStateNotifier();
});
