import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/roulette_option.dart';

/// Data model for RouletteOption - used for Firestore serialization
class RouletteOptionModel extends Equatable {
  final String id;
  final String label;
  final String icon;
  final String color;
  final String? presetCategory;
  final bool isActive;

  const RouletteOptionModel({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    this.presetCategory,
    this.isActive = true,
  });

  /// Creates a RouletteOptionModel from a Firestore document snapshot
  factory RouletteOptionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return RouletteOptionModel(
      id: doc.id,
      label: data['label'] as String,
      icon: (data['emoji'] ?? data['icon']) as String,
      color: data['color'] as String,
      presetCategory: data['preset_category'] as String?,
      isActive: data['is_active'] as bool? ?? true,
    );
  }

  /// Creates a RouletteOptionModel from a domain entity
  factory RouletteOptionModel.fromEntity(RouletteOption entity) {
    return RouletteOptionModel(
      id: entity.id,
      label: entity.label,
      icon: entity.icon,
      color: entity.color,
      presetCategory: entity.presetCategory,
      isActive: true,
    );
  }

  /// Converts to domain RouletteOption entity
  RouletteOption toEntity() {
    return RouletteOption(
      id: id,
      label: label,
      icon: icon,
      color: color,
      presetCategory: presetCategory,
    );
  }

  /// Converts to Firestore map for writing
  Map<String, dynamic> toFirestore() {
    return {
      'label': label,
      'emoji': icon,
      'color': color,
      'preset_category': presetCategory,
      'is_active': isActive,
    };
  }

  /// Creates a copy with updated fields
  RouletteOptionModel copyWith({
    String? id,
    String? label,
    String? icon,
    String? color,
    String? presetCategory,
    bool? isActive,
  }) {
    return RouletteOptionModel(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      presetCategory: presetCategory ?? this.presetCategory,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [id, label, icon, color, presetCategory, isActive];
}
