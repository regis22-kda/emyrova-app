import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../core/widgets/player_avatar.dart';
import '../../../domain/entities/game_session.dart';
import '../../../domain/usecases/compare_answers.dart';
import '../../providers/game_provider.dart';

/// Results reveal screen for Question Engine
class QuestionResultsScreen extends ConsumerWidget {
  const QuestionResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(gameSessionProvider);
    final compareAnswers = ref.watch(compareAnswersProvider);
    final resultType = compareAnswers(session);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Question number badge
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusFull,
                          ),
                        ),
                        child: Text(
                          'Question #${session.currentRound}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Question card
                    _buildQuestionCard(context, session),
                    const SizedBox(height: AppSpacing.xl),
                    // Answers comparison
                    _buildAnswersComparison(context, session),
                    const SizedBox(height: AppSpacing.xl),
                    // Result badge
                    _buildResultBadge(context, resultType),
                    const SizedBox(height: AppSpacing.xxl),
                    // Action buttons
                    _buildActionButtons(context, ref),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentPath: '/play'),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
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
          const Expanded(
            child: Text(
              AppStrings.resultsReveal,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context, GameSession session) {
    // In a real app, this would come from the current question provider
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: const Text(
        '"If we won the lottery tomorrow, what is the first \'useless\' thing you\'d buy?"',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildAnswersComparison(BuildContext context, GameSession session) {
    final answers = session.answers.values.toList();

    return Column(
      children: [
        // Player 1 answer
        _buildPlayerAnswer(
          context,
          session.players[0],
          answers
              .firstWhere(
                (a) => a.playerId == session.players[0].id,
                orElse: () => answers.first,
              )
              .answer,
          isLeft: true,
        ),
        const SizedBox(height: AppSpacing.lg),
        // Player 2 answer
        _buildPlayerAnswer(
          context,
          session.players[1],
          answers
              .firstWhere(
                (a) => a.playerId == session.players[1].id,
                orElse: () => answers.last,
              )
              .answer,
          isLeft: false,
        ),
      ],
    );
  }

  Widget _buildPlayerAnswer(
    BuildContext context,
    dynamic player,
    String answer, {
    required bool isLeft,
  }) {
    return Align(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      child: Column(
        crossAxisAlignment: isLeft
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          // Player info
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isLeft) ...[
                Text(
                  player.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              PlayerAvatar(player: player, size: 40),
              if (isLeft) ...[
                const SizedBox(width: AppSpacing.sm),
                Text(
                  player.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          // Answer bubble
          Container(
            constraints: const BoxConstraints(maxWidth: 280),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: isLeft ? AppColors.primary : Theme.of(context).cardColor,
              borderRadius: BorderRadius.only(
                topLeft: isLeft
                    ? const Radius.circular(AppSpacing.radiusLg)
                    : const Radius.circular(AppSpacing.radiusLg),
                topRight: isLeft
                    ? const Radius.circular(AppSpacing.radiusLg)
                    : Radius.zero,
                bottomLeft: isLeft
                    ? Radius.zero
                    : const Radius.circular(AppSpacing.radiusLg),
                bottomRight: const Radius.circular(AppSpacing.radiusLg),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              '"$answer"',
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: isLeft ? Colors.white : null,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultBadge(BuildContext context, ResultType resultType) {
    final isMatch = resultType == ResultType.match;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: isMatch
                ? AppColors.accentGreen.withOpacity(0.1)
                : AppColors.accentAmber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            border: Border.all(
              color: isMatch
                  ? AppColors.accentGreen.withOpacity(0.3)
                  : AppColors.accentAmber.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isMatch ? Icons.check_circle : Icons.theater_comedy,
                color: isMatch ? AppColors.accentGreen : AppColors.accentAmber,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                isMatch ? AppStrings.perfectMatch : AppStrings.funContrast,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isMatch
                      ? AppColors.accentGreen
                      : AppColors.accentAmber,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Text(
            isMatch
                ? 'You both think alike! Great minds think alike!'
                : 'You both have very different ideas of \'useless\' luxury!',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondaryLight,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Next question button
        SizedBox(
          height: AppSpacing.buttonLg,
          child: ElevatedButton(
            onPressed: () {
              // Navigate to next question or end game
              final notifier = ref.read(gameSessionProvider.notifier);
              notifier.nextRound();
              context.push('/question-engine');
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              shadowColor: AppColors.shadowLight,
              elevation: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(AppStrings.nextQuestion),
                const SizedBox(width: AppSpacing.sm),
                const Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Share and favorite buttons
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: AppSpacing.buttonMd,
                child: OutlinedButton(
                  onPressed: () {
                    // Share functionality
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.share, size: 20),
                      const SizedBox(width: AppSpacing.sm),
                      const Text(AppStrings.shareResult),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            SizedBox(
              width: AppSpacing.buttonMd,
              height: AppSpacing.buttonMd,
              child: OutlinedButton(
                onPressed: () {
                  // Favorite/save functionality
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                ),
                child: const Icon(Icons.favorite_border, size: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
