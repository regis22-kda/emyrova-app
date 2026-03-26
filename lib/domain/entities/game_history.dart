import 'package:equatable/equatable.dart';

/// Represents a single round result in a game session
class RoundResult extends Equatable {
  final int roundNumber;
  final String question;
  final String partnerAAnswer;
  final String partnerBAnswer;
  final bool isMatch;

  const RoundResult({
    required this.roundNumber,
    required this.question,
    required this.partnerAAnswer,
    required this.partnerBAnswer,
    required this.isMatch,
  });

  /// Calculate match percentage based on text similarity
  double get matchPercentage {
    if (isMatch) return 1.0;
    
    final a = partnerAAnswer.toLowerCase().trim();
    final b = partnerBAnswer.toLowerCase().trim();
    
    // Simple word overlap calculation
    final wordsA = a.split(RegExp(r'\s+')).toSet();
    final wordsB = b.split(RegExp(r'\s+')).toSet();
    
    if (wordsA.isEmpty || wordsB.isEmpty) return 0.0;
    
    final commonWords = wordsA.intersection(wordsB).length;
    final totalWords = (wordsA.length + wordsB.length) / 2;
    
    return commonWords / totalWords;
  }

  @override
  List<Object?> get props => [
        roundNumber,
        question,
        partnerAAnswer,
        partnerBAnswer,
        isMatch,
      ];
}

/// Represents a completed game session in history
class GameHistory extends Equatable {
  final String id;
  final DateTime date;
  final int totalRounds;
  final double chemistryScore; // 0-100
  final List<RoundResult> rounds;
  final String partnerAName;
  final String partnerBName;

  const GameHistory({
    required this.id,
    required this.date,
    required this.totalRounds,
    required this.chemistryScore,
    required this.rounds,
    required this.partnerAName,
    required this.partnerBName,
  });

  /// Calculate overall chemistry level
  String get chemistryLevel {
    if (chemistryScore >= 80) return 'Soulmates';
    if (chemistryScore >= 60) return 'Great Match';
    if (chemistryScore >= 40) return 'Getting There';
    if (chemistryScore >= 20) return 'Opposites Attract';
    return 'Work in Progress';
  }

  /// Get chemistry color
  String get chemistryColor {
    if (chemistryScore >= 80) return '#10B981'; // Green
    if (chemistryScore >= 60) return '#3B82F6'; // Blue
    if (chemistryScore >= 40) return '#F59E0B'; // Amber
    if (chemistryScore >= 20) return '#EC4899'; // Pink
    return '#EF4444'; // Red
  }

  @override
  List<Object?> get props => [
        id,
        date,
        totalRounds,
        chemistryScore,
        rounds,
        partnerAName,
        partnerBName,
      ];
}
