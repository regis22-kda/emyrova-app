import 'package:equatable/equatable.dart';

/// Represents the type of question
enum QuestionType {
  freeResponse,
  thisOrThat,
  whosMoreLikely,
  actionChallenge,
}

/// Represents a question in the Question Engine
class Question extends Equatable {
  final String id;
  final String category;
  final String prompt;
  final QuestionType type;
  final String? subtext;
  final String? imageUrl;
  final FollowupLogic? followupLogic;

  const Question({
    required this.id,
    required this.category,
    required this.prompt,
    required this.type,
    this.subtext,
    this.imageUrl,
    this.followupLogic,
  });

  /// Creates a Question from a JSON map
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      category: json['category'] as String,
      prompt: json['prompt'] as String,
      type: QuestionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => QuestionType.freeResponse,
      ),
      subtext: json['subtext'] as String?,
      imageUrl: json['imageUrl'] as String?,
      followupLogic: json['followup_logic'] != null
          ? FollowupLogic.fromJson(json['followup_logic'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Converts the Question to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'prompt': prompt,
      'type': type.name,
      'subtext': subtext,
      'imageUrl': imageUrl,
      'followup_logic': followupLogic?.toJson(),
    };
  }

  @override
  List<Object?> get props => [id, category, prompt, type, subtext, imageUrl, followupLogic];
}

/// Follow-up logic to display after answering
class FollowupLogic extends Equatable {
  final String onComplete;

  const FollowupLogic({required this.onComplete});

  factory FollowupLogic.fromJson(Map<String, dynamic> json) {
    return FollowupLogic(
      onComplete: json['on_complete'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'on_complete': onComplete,
    };
  }

  @override
  List<Object?> get props => [onComplete];
}
