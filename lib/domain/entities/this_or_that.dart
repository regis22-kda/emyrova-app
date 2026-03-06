import 'package:equatable/equatable.dart';

/// Represents a This or That option
class ThisOrThatOption extends Equatable {
  final String id;
  final String label;
  final String icon;
  final String? imageUrl;

  const ThisOrThatOption({
    required this.id,
    required this.label,
    required this.icon,
    this.imageUrl,
  });

  factory ThisOrThatOption.fromJson(Map<String, dynamic> json) {
    return ThisOrThatOption(
      id: json['id'] as String,
      label: json['label'] as String,
      icon: json['icon'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'icon': icon,
      'imageUrl': imageUrl,
    };
  }

  @override
  List<Object?> get props => [id, label, icon, imageUrl];
}

/// Represents a This or That question pair
class ThisOrThatQuestion extends Equatable {
  final String id;
  final String category;
  final ThisOrThatOption optionA;
  final ThisOrThatOption optionB;

  const ThisOrThatQuestion({
    required this.id,
    required this.category,
    required this.optionA,
    required this.optionB,
  });

  factory ThisOrThatQuestion.fromJson(Map<String, dynamic> json) {
    return ThisOrThatQuestion(
      id: json['id'] as String,
      category: json['category'] as String,
      optionA: ThisOrThatOption.fromJson(json['option_a'] as Map<String, dynamic>),
      optionB: ThisOrThatOption.fromJson(json['option_b'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'option_a': optionA.toJson(),
      'option_b': optionB.toJson(),
    };
  }

  @override
  List<Object?> get props => [id, category, optionA, optionB];
}
