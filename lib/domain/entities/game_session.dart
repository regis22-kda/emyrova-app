import 'package:equatable/equatable.dart';
import 'player.dart';
import 'question.dart';

/// Represents the current state of a game session
class GameSession extends Equatable {
  final String id;
  final List<Player> players;
  final int currentPlayerIndex;
  final int currentRound;
  final int totalRounds;
  final Map<String, PlayerAnswer> answers;
  final bool isComplete;

  const GameSession({
    required this.id,
    required this.players,
    this.currentPlayerIndex = 0,
    this.currentRound = 1,
    this.totalRounds = 5,
    this.answers = const {},
    this.isComplete = false,
  });

  /// Gets the current player
  Player get currentPlayer => players[currentPlayerIndex];

  /// Checks if all players have answered for the current question
  bool get allPlayersAnswered => answers.length >= players.length;

  /// Creates a new session for the next round
  GameSession nextRound() {
    return GameSession(
      id: id,
      players: players,
      currentPlayerIndex: 0,
      currentRound: currentRound + 1,
      totalRounds: totalRounds,
      answers: {},
      isComplete: currentRound >= totalRounds,
    );
  }

  /// Adds an answer from a player
  GameSession addAnswer(String playerId, String answer) {
    final updatedAnswers = Map<String, PlayerAnswer>.from(answers)
      ..putIfAbsent(
        playerId,
        () => PlayerAnswer(playerId: playerId, answer: answer, timestamp: DateTime.now()),
      );
    return copyWith(answers: updatedAnswers);
  }

  /// Moves to the next player
  GameSession nextPlayer() {
    final nextIndex = (currentPlayerIndex + 1) % players.length;
    return copyWith(
      currentPlayerIndex: nextIndex,
      currentRound: nextIndex == 0 ? currentRound + 1 : currentRound,
    );
  }

  GameSession copyWith({
    String? id,
    List<Player>? players,
    int? currentPlayerIndex,
    int? currentRound,
    int? totalRounds,
    Map<String, PlayerAnswer>? answers,
    bool? isComplete,
  }) {
    return GameSession(
      id: id ?? this.id,
      players: players ?? this.players,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      currentRound: currentRound ?? this.currentRound,
      totalRounds: totalRounds ?? this.totalRounds,
      answers: answers ?? this.answers,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  @override
  List<Object?> get props => [id, players, currentPlayerIndex, currentRound, totalRounds, answers, isComplete];
}

/// Represents a player's answer
class PlayerAnswer extends Equatable {
  final String playerId;
  final String answer;
  final DateTime timestamp;

  const PlayerAnswer({
    required this.playerId,
    required this.answer,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [playerId, answer, timestamp];
}
