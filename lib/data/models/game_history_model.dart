import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/game_history.dart';

/// Data model for RoundResult - used for Firestore serialization
class RoundResultModel extends Equatable {
  final int roundNumber;
  final String question;
  final String partnerAAnswer;
  final String partnerBAnswer;
  final bool isMatch;

  const RoundResultModel({
    required this.roundNumber,
    required this.question,
    required this.partnerAAnswer,
    required this.partnerBAnswer,
    required this.isMatch,
  });

  factory RoundResultModel.fromEntity(RoundResult entity) {
    return RoundResultModel(
      roundNumber: entity.roundNumber,
      question: entity.question,
      partnerAAnswer: entity.partnerAAnswer,
      partnerBAnswer: entity.partnerBAnswer,
      isMatch: entity.isMatch,
    );
  }

  factory RoundResultModel.fromFirestore(Map<String, dynamic> data) {
    return RoundResultModel(
      roundNumber: data['round'] as int,
      question: data['question'] as String,
      partnerAAnswer: data['partner_a_answer'] as String,
      partnerBAnswer: data['partner_b_answer'] as String,
      isMatch: data['is_match'] as bool,
    );
  }

  RoundResult toEntity() {
    return RoundResult(
      roundNumber: roundNumber,
      question: question,
      partnerAAnswer: partnerAAnswer,
      partnerBAnswer: partnerBAnswer,
      isMatch: isMatch,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'round': roundNumber,
      'question': question,
      'partner_a_answer': partnerAAnswer,
      'partner_b_answer': partnerBAnswer,
      'is_match': isMatch,
    };
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

/// Data model for GameHistory - used for Firestore serialization
class GameHistoryModel extends Equatable {
  final String id;
  final DateTime date;
  final int totalRounds;
  final double chemistryScore;
  final List<RoundResultModel> rounds;
  final String partnerAName;
  final String partnerBName;

  const GameHistoryModel({
    required this.id,
    required this.date,
    required this.totalRounds,
    required this.chemistryScore,
    required this.rounds,
    required this.partnerAName,
    required this.partnerBName,
  });

  factory GameHistoryModel.fromEntity(GameHistory entity) {
    return GameHistoryModel(
      id: entity.id,
      date: entity.date,
      totalRounds: entity.totalRounds,
      chemistryScore: entity.chemistryScore,
      rounds: entity.rounds.map((r) => RoundResultModel.fromEntity(r)).toList(),
      partnerAName: entity.partnerAName,
      partnerBName: entity.partnerBName,
    );
  }

  factory GameHistoryModel.fromFirestore(String id, Map<String, dynamic> data) {
    final roundsData = data['rounds'] as List<dynamic>? ?? [];
    
    return GameHistoryModel(
      id: id,
      date: (data['date'] as Timestamp).toDate(),
      totalRounds: data['total_rounds'] as int,
      chemistryScore: (data['chemistry_score'] as num).toDouble(),
      rounds: roundsData
          .map((r) => RoundResultModel.fromFirestore(r as Map<String, dynamic>))
          .toList(),
      partnerAName: data['partner_a_name'] as String? ?? 'Player A',
      partnerBName: data['partner_b_name'] as String? ?? 'Player B',
    );
  }

  GameHistory toEntity() {
    return GameHistory(
      id: id,
      date: date,
      totalRounds: totalRounds,
      chemistryScore: chemistryScore,
      rounds: rounds.map((r) => r.toEntity()).toList(),
      partnerAName: partnerAName,
      partnerBName: partnerBName,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'date': Timestamp.fromDate(date),
      'total_rounds': totalRounds,
      'chemistry_score': chemistryScore,
      'rounds': rounds.map((r) => r.toFirestore()).toList(),
      'partner_a_name': partnerAName,
      'partner_b_name': partnerBName,
    };
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
