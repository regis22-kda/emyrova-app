import 'package:equatable/equatable.dart';

/// Represents a player in the game
class Player extends Equatable {
  final String id;
  final String name;
  final String? avatarUrl;
  final String avatarColor;

  const Player({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.avatarColor = '#8a2ce2',
  });

  /// Creates a Player from a JSON map
  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      avatarColor: json['avatar_color'] as String? ?? '#8a2ce2',
    );
  }

  /// Converts the Player to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar_url': avatarUrl,
      'avatar_color': avatarColor,
    };
  }

  @override
  List<Object?> get props => [id, name, avatarUrl, avatarColor];

  /// Creates a copy of this Player with updated fields
  Player copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    String? avatarColor,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarColor: avatarColor ?? this.avatarColor,
    );
  }
}
