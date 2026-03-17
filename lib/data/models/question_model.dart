import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/question.dart';

/// Data model for Question - used for JSON serialization
class QuestionModel extends Equatable {
  final String id;
  final String category;
  final String prompt;
  final String type;
  final String? subtext;
  final String? imageUrl;
  final FollowupLogicModel? followupLogic;

  const QuestionModel({
    required this.id,
    required this.category,
    required this.prompt,
    required this.type,
    this.subtext,
    this.imageUrl,
    this.followupLogic,
  });

  /// Creates a QuestionModel from a Firestore document snapshot
  /// Firestore structure: id, category, prompt, type, subtext?, imageUrl?, followup (flat string)
  factory QuestionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final followup = data['followup'] as String?;

    return QuestionModel(
      id: doc.id,
      category: data['category'] as String,
      prompt: data['prompt'] as String,
      type: data['type'] as String,
      subtext: data['subtext'] as String?,
      imageUrl: data['imageUrl'] as String?,
      followupLogic: followup != null && followup.isNotEmpty
          ? FollowupLogicModel(onComplete: followup)
          : null,
    );
  }

  /// Creates a QuestionModel from a domain Question entity
  factory QuestionModel.fromEntity(Question question) {
    return QuestionModel(
      id: question.id,
      category: question.category,
      prompt: question.prompt,
      type: question.type.name,
      subtext: question.subtext,
      imageUrl: question.imageUrl,
      followupLogic: question.followupLogic != null
          ? FollowupLogicModel.fromEntity(question.followupLogic!)
          : null,
    );
  }

  /// Converts to domain Question entity
  Question toEntity() {
    return Question(
      id: id,
      category: category,
      prompt: prompt,
      type: QuestionType.values.firstWhere(
        (e) => e.name == type,
        orElse: () => QuestionType.freeResponse,
      ),
      subtext: subtext,
      imageUrl: imageUrl,
      followupLogic: followupLogic?.toEntity(),
    );
  }

  /// Creates from JSON
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] as String,
      category: json['category'] as String,
      prompt: json['prompt'] as String,
      type: json['type'] as String,
      subtext: json['subtext'] as String?,
      imageUrl: json['imageUrl'] as String?,
      followupLogic: json['followup_logic'] != null
          ? FollowupLogicModel.fromJson(json['followup_logic'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'prompt': prompt,
      'type': type,
      'subtext': subtext,
      'imageUrl': imageUrl,
      'followup_logic': followupLogic?.toJson(),
    };
  }

  @override
  List<Object?> get props => [id, category, prompt, type, subtext, imageUrl, followupLogic];
}

/// Data model for FollowupLogic
class FollowupLogicModel extends Equatable {
  final String onComplete;

  const FollowupLogicModel({required this.onComplete});

  factory FollowupLogicModel.fromEntity(FollowupLogic logic) {
    return FollowupLogicModel(onComplete: logic.onComplete);
  }

  FollowupLogic toEntity() {
    return FollowupLogic(onComplete: onComplete);
  }

  factory FollowupLogicModel.fromJson(Map<String, dynamic> json) {
    return FollowupLogicModel(
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
