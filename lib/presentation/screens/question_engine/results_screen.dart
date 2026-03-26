import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../core/widgets/player_avatar.dart';
import '../../../domain/entities/game_history.dart';
import '../../../domain/entities/game_session.dart';
import '../../../domain/usecases/compare_answers.dart';
import '../../providers/game_provider.dart';
import 'final_results_screen.dart';

class QuestionResultsScreen extends ConsumerWidget {
  const QuestionResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(gameSessionProvider);
    final currentQuestion = ref.watch(currentQuestionProvider);
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
                    _buildQuestionCard(context, session, currentQuestion),
                    const SizedBox(height: AppSpacing.xl),
                    _buildAnswersComparison(context, session),
                    const SizedBox(height: AppSpacing.xl),
                    _buildResultBadge(context, resultType),
                    const SizedBox(height: AppSpacing.xxl),
                    _buildActionButtons(context, ref, currentQuestion),
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

  Widget _buildQuestionCard(BuildContext context, GameSession session, dynamic currentQuestion) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Text(
        currentQuestion?.prompt ?? 'No question available',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildAnswersComparison(BuildContext context, GameSession session) {
    final answers = session.answers.values.toList();

    if (answers.isEmpty) {
      return const Center(child: Text('No answers submitted yet'));
    }

    return Column(
      children: [
        _buildPlayerAnswer(
          context,
          session.players[0],
          answers
              .firstWhere(
                (a) => a.playerId == session.players[0].id,
                orElse: () => PlayerAnswer(
                  playerId: '',
                  answer: 'No answer yet',
                  timestamp: DateTime.now(),
                ),
              )
              .answer,
          isLeft: true,
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildPlayerAnswer(
          context,
          session.players[1],
          answers
              .firstWhere(
                (a) => a.playerId == session.players[1].id,
                orElse: () => PlayerAnswer(
                  playerId: '',
                  answer: 'No answer yet',
                  timestamp: DateTime.now(),
                ),
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

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, dynamic currentQuestion) {
    final session = ref.watch(gameSessionProvider);
    final notifier = ref.read(gameSessionProvider.notifier);
    final isGameComplete = notifier.isGameComplete;
    final isLastRound = notifier.isLastRound;

    return Column(
      children: [
        SizedBox(
          height: AppSpacing.buttonLg,
          child: ElevatedButton(
            onPressed: () {
              if (isGameComplete) {
                final history = _createGameHistory(ref, session, currentQuestion);
                context.push('/question-engine/final-results', extra: history);
              } else {
                // Clear answers and start next round
                notifier.clearAnswers();
                ref.read(currentQuestionProvider.notifier).clear();
                notifier.nextRound();
                context.push('/question-engine');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isLastRound || isGameComplete ? AppColors.success : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              shadowColor: AppColors.shadowLight,
              elevation: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isGameComplete ? Icons.celebration : Icons.check,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  isGameComplete 
                      ? 'Finish Game' 
                      : isLastRound 
                          ? 'Complete' 
                          : AppStrings.nextQuestion,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Round info or share buttons
        if (!isGameComplete) ...[
          Text(
            isLastRound 
                ? 'Final Round ${session.currentRound} of ${session.totalRounds}' 
                : 'Round ${session.currentRound} of ${session.totalRounds}',
            style: TextStyle(
              fontSize: 12,
              color: isLastRound ? AppColors.success : AppColors.textSecondaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ] else ...[
          // Game complete - show share buttons
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
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusLg,
                        ),
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
      ],
    );
  }

  GameHistory _createGameHistory(WidgetRef ref, GameSession session, dynamic currentQuestion) {
    // TODO(regis): Track all rounds' questions and answers
    return GameHistory(
      id: 'game_${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now(),
      totalRounds: session.totalRounds,
      chemistryScore: 75.0,
      rounds: [],
      partnerAName: session.players[0].name,
      partnerBName: session.players[1].name,
    );
  }
}
