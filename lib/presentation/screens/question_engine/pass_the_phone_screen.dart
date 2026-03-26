import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/player_avatar.dart';
import '../../../domain/entities/game_session.dart';
import '../../../domain/entities/player.dart';
import '../../providers/game_provider.dart';

/// Pass the phone transition screen
class PassThePhoneScreen extends ConsumerWidget {
  const PassThePhoneScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(gameSessionProvider);
    final currentPlayer = session.currentPlayer;
    final nextPlayerIndex =
        (session.players.indexOf(currentPlayer) + 1) % session.players.length;
    final nextPlayer = session.players[nextPlayerIndex];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.close, color: AppColors.primary),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const Text(
                    AppStrings.appName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.settings_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.smartphone,
                        color: AppColors.primary,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Text(
                      'Pass to ${nextPlayer.name}',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      "It's their turn to dominate the round!",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondaryLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    // Player avatars
                    _buildPlayerTransition(currentPlayer, nextPlayer),
                    const SizedBox(height: AppSpacing.xxl),
                    _buildGameInfoCard(context, session),
                    const SizedBox(height: AppSpacing.xl),
                    SizedBox(
                      width: double.infinity,
                      height: AppSpacing.buttonLg,
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(gameSessionProvider.notifier).nextPlayer();
                          context.push('/question-engine');
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusLg,
                            ),
                          ),
                          shadowColor: AppColors.shadowLight,
                          elevation: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(AppStrings.imReady),
                            const SizedBox(width: AppSpacing.sm),
                            const Icon(Icons.arrow_forward_ios, size: 18),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Next turn hint
                    Text(
                      '${AppStrings.nextTurn}: ${currentPlayer.name}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondaryLight,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerTransition(Player currentPlayer, Player nextPlayer) {
    return SizedBox(
      width: 200,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Previous player (faded)
          Positioned(
            left: 0,
            child: Opacity(
              opacity: 0.4,
              child: Transform.scale(
                scale: 0.9,
                child: PlayerAvatar(player: currentPlayer, size: 96),
              ),
            ),
          ),
          // Next player (highlighted)
          Positioned(
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: PlayerAvatar(
                player: nextPlayer,
                size: 120,
                isActive: true,
                badge: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.accentGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 18),
                ),
              ),
            ),
          ),
          // Arrow
          Positioned(
            right: 100,
            child: Icon(
              Icons.chevron_right,
              size: 48,
              color: AppColors.primary.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameInfoCard(BuildContext context, GameSession session) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.borderLight.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: const Icon(
              Icons.quiz_outlined,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.currentRound,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: 0.5,
                  ),
                ),
                const Text(
                  'Quickfire Trivia',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Round number
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppStrings.round,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondaryLight,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                '${session.currentRound.toString().padLeft(2, '0')}/${session.totalRounds}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
