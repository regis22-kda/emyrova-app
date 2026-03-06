import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local_question_datasource.dart';
import '../../data/repositories/local_content_repository.dart';
import '../../domain/repositories/content_repository.dart';
import '../../domain/usecases/get_next_question.dart';
import '../../domain/usecases/compare_answers.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/player.dart';
import '../../domain/entities/game_session.dart';

/// Repository provider
final contentRepositoryProvider = Provider<IContentRepository>((ref) {
  return const LocalContentRepository(
    dataSource: LocalQuestionDataSource(),
  );
});

/// Use case providers
final getNextQuestionProvider = Provider<GetNextQuestion>((ref) {
  return GetNextQuestion(ref.watch(contentRepositoryProvider));
});

final compareAnswersProvider = Provider<CompareAnswers>((ref) {
  return const CompareAnswers();
});

/// Game session state notifier
class GameSessionNotifier extends StateNotifier<GameSession> {
  GameSessionNotifier()
      : super(const GameSession(
          id: 'session_1',
          players: [
            Player(id: 'player_1', name: 'Alex', avatarColor: '#FF9800'),
            Player(id: 'player_2', name: 'Sarah', avatarColor: '#E91E63'),
          ],
        ));

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

final gameSessionProvider = StateNotifierProvider<GameSessionNotifier, GameSession>((ref) {
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

final currentQuestionProvider = StateNotifierProvider<CurrentQuestionNotifier, Question?>((ref) {
  return CurrentQuestionNotifier();
});

/// Game state enum
enum GameState {
  notStarted,
  playing,
  revealing,
  complete,
}

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

final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((ref) {
  return GameStateNotifier();
});
