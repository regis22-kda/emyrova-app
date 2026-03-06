import 'package:flutter/material.dart';

import '../../domain/entities/player.dart';
import '../constants/app_colors.dart';
import '../domain/entities/player.dart';

/// Player avatar widget with status indicator
class PlayerAvatar extends StatelessWidget {
  final Player player;
  final double size;
  final bool isActive;
  final bool hasAnswered;
  final Widget? badge;

  const PlayerAvatar({
    super.key,
    required this.player,
    this.size = 48,
    this.isActive = false,
    this.hasAnswered = false,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Glow effect for active player
        if (isActive)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        // Avatar container
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive
                  ? AppColors.primary
                  : AppColors.primary.withOpacity(0.2),
              width: isActive ? 3 : 2,
            ),
            color: _getColorFromHex(player.avatarColor),
            image: player.avatarUrl != null
                ? DecorationImage(
                    image: NetworkImage(player.avatarUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: player.avatarUrl == null
              ? Center(
                  child: Text(
                    player.name.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      fontSize: size * 0.4,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              : null,
        ),
        // Status indicator
        if (hasAnswered || badge != null)
          Positioned(
            right: 0,
            bottom: 0,
            child:
                badge ??
                Container(
                  width: size * 0.35,
                  height: size * 0.35,
                  decoration: const BoxDecoration(
                    color: AppColors.accentGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 12, color: Colors.white),
                ),
          ),
      ],
    );
  }

  Color _getColorFromHex(String hexColor) {
    final hex = hexColor.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}

/// Multiple player avatars with overlap
class PlayerAvatarsGroup extends StatelessWidget {
  final List<Player> players;
  final double size;
  final int? activePlayerIndex;
  final Set<String>? answeredPlayerIds;

  const PlayerAvatarsGroup({
    super.key,
    required this.players,
    this.size = 48,
    this.activePlayerIndex,
    this.answeredPlayerIds,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...players.asMap().entries.map((entry) {
          final index = entry.key;
          final player = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              right: index < players.length - 1 ? -16 : 0,
            ),
            child: PlayerAvatar(
              player: player,
              size: size,
              isActive: index == activePlayerIndex,
              hasAnswered: answeredPlayerIds?.contains(player.id) ?? false,
            ),
          );
        }),
      ],
    );
  }
}
