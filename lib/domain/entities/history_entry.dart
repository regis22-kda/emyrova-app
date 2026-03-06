import 'package:equatable/equatable.dart';

/// Types of games that can be played
enum GameType {
  questionEngine,
  roulette,
  thisOrThat,
  whosMoreLikely,
  actionChallenge,
}

/// Represents a result comparison
enum ResultType {
  match,
  contrast,
  winner,
}

/// Represents a history entry for past games
class HistoryEntry extends Equatable {
  final String id;
  final GameType gameType;
  final String title;
  final String result;
  final DateTime timestamp;
  final ResultType? resultType;
  final String? details;
  final List<String>? participantIds;

  const HistoryEntry({
    required this.id,
    required this.gameType,
    required this.title,
    required this.result,
    required this.timestamp,
    this.resultType,
    this.details,
    this.participantIds,
  });

  /// Creates a HistoryEntry from a JSON map
  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      id: json['id'] as String,
      gameType: GameType.values.firstWhere(
        (e) => e.name == json['game_type'],
        orElse: () => GameType.questionEngine,
      ),
      title: json['title'] as String,
      result: json['result'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      resultType: json['result_type'] != null
          ? ResultType.values.firstWhere((e) => e.name == json['result_type'])
          : null,
      details: json['details'] as String?,
      participantIds: json['participant_ids'] != null
          ? List<String>.from(json['participant_ids'] as List)
          : null,
    );
  }

  /// Converts the HistoryEntry to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game_type': gameType.name,
      'title': title,
      'result': result,
      'timestamp': timestamp.toIso8601String(),
      'result_type': resultType?.name,
      'details': details,
      'participant_ids': participantIds,
    };
  }

  @override
  List<Object?> get props => [id, gameType, title, result, timestamp, resultType, details, participantIds];
}
