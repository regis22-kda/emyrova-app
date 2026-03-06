import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../core/widgets/player_avatar.dart';
import '../../../domain/entities/player.dart';

/// Placeholder screen for Who's More Likely game
class WhosMoreLikelyScreen extends StatelessWidget {
  const WhosMoreLikelyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final players = const [
      Player(id: 'player_1', name: 'Alex', avatarColor: '#FF9800'),
      Player(id: 'player_2', name: 'Sarah', avatarColor: '#E91E63'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text(
              AppStrings.whosMoreLikely,
              style: TextStyle(fontSize: 14),
            ),
            Text(
              AppStrings.passAndPlay,
              style: TextStyle(fontSize: 10),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              // Progress
              LinearProgressIndicator(
                value: 0.3,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.gameProgress,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Round 3/10',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              // Question
              const Text(
                'Who is more likely to stay up all night?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                AppStrings.tapToVote,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              // Player cards
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildPlayerCard(
                        context,
                        players[0],
                        isSelected: true,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _buildPlayerCard(
                        context,
                        players[1],
                        isSelected: false,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentPath: '/play'),
    );
  }

  Widget _buildPlayerCard(
    BuildContext context,
    Player player, {
    required bool isSelected,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.borderLight,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PlayerAvatar(
            player: player,
            size: 96,
            isActive: isSelected,
            badge: isSelected
                ? Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            player.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
