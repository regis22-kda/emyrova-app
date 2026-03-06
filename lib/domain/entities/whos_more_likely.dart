import 'package:equatable/equatable.dart';

/// Represents a Who's More Likely question
class WhosMoreLikelyQuestion extends Equatable {
  final String id;
  final String category;
  final String prompt;
  final String? subtext;

  const WhosMoreLikelyQuestion({
    required this.id,
    required this.category,
    required this.prompt,
    this.subtext,
  });

  factory WhosMoreLikelyQuestion.fromJson(Map<String, dynamic> json) {
    return WhosMoreLikelyQuestion(
      id: json['id'] as String,
      category: json['category'] as String,
      prompt: json['prompt'] as String,
      subtext: json['subtext'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'prompt': prompt,
      'subtext': subtext,
    };
  }

  @override
  List<Object?> get props => [id, category, prompt, subtext];
}

/// Represents a vote result in Who's More Likely
class VoteResult extends Equatable {
  final String questionId;
  final Map<String, int> votes; // playerId -> vote count
  final String winnerId;
  final double winnerPercentage;

  const VoteResult({
    required this.questionId,
    required this.votes,
    required this.winnerId,
    required this.winnerPercentage,
  });

  @override
  List<Object?> get props => [questionId, votes, winnerId, winnerPercentage];
}
