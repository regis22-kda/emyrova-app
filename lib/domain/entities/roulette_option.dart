import 'package:equatable/equatable.dart';

/// Represents an option in the Decision Roulette
class RouletteOption extends Equatable {
  final String id;
  final String label;
  final String icon;
  final String color;
  final String? presetCategory;

  const RouletteOption({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    this.presetCategory,
  });

  /// Creates a RouletteOption from a JSON map
  factory RouletteOption.fromJson(Map<String, dynamic> json) {
    return RouletteOption(
      id: json['id'] as String,
      label: json['label'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      presetCategory: json['preset_category'] as String?,
    );
  }

  /// Converts the RouletteOption to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'icon': icon,
      'color': color,
      'preset_category': presetCategory,
    };
  }

  @override
  List<Object?> get props => [id, label, icon, color, presetCategory];
}
