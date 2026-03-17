import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../domain/entities/room_state.dart';
import '../../providers/room_provider.dart';

/// Screen for revealing multiplayer answers
class MultiplayerResultsScreen extends ConsumerWidget {
  const MultiplayerResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomState = ref.watch(roomStateNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: roomState.when(
          data: (room) {
            if (room == null) {
              return _buildNoRoomState(context);
            }

            final state = room.state;
            if (state is! Revealed) {
              return _buildNotReadyState(context, state);
            }

            return _buildContent(context, state.partnerAAnswer, state.partnerBAnswer);
          },
          loading: () => _buildLoadingState(),
          error: (error, stack) => _buildErrorState(error),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentPath: '/play'),
    );
  }

  Widget _buildContent(BuildContext context, String partnerAAnswer, String partnerBAnswer) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.lg),
          // Header
          _buildHeader(context),
          const SizedBox(height: AppSpacing.xxl),
          // Celebration icon
          _buildCelebrationIcon(),
          const SizedBox(height: AppSpacing.xxl),
          // Title
          _buildTitle(),
          const SizedBox(height: AppSpacing.xl),
          // Answers comparison
          _buildAnswersComparison(partnerAAnswer, partnerBAnswer),
          const SizedBox(height: AppSpacing.xxl),
          // Match indicator
          _buildMatchIndicator(partnerAAnswer, partnerBAnswer),
          const SizedBox(height: AppSpacing.xxl),
          // Action buttons
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
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
            icon: const Icon(
              Icons.close,
              color: AppColors.primary,
            ),
            padding: EdgeInsets.zero,
          ),
        ),
        const Expanded(
          child: Text(
            'Answers Revealed!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 40),
      ],
    );
  }

  Widget _buildCelebrationIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.accentAmber, AppColors.accentPink],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.accentAmber.withOpacity(0.4),
            blurRadius: 20,
          ),
        ],
      ),
      child: const Icon(
        Icons.celebration,
        size: 64,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTitle() {
    return const Column(
      children: [
        Text(
          'Time to Compare!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          'See how your answers match up',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondaryLight,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAnswersComparison(String partnerAAnswer, String partnerBAnswer) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildAnswerCard(
                'Partner A',
                partnerAAnswer,
                AppColors.primary,
                isLeft: true,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildAnswerCard(
                'Partner B',
                partnerBAnswer,
                AppColors.accentPink,
                isLeft: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnswerCard(String label, String answer, Color color, {required bool isLeft}) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            answer,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchIndicator(String partnerAAnswer, String partnerBAnswer) {
    final isMatch = partnerAAnswer.toLowerCase().trim() == partnerBAnswer.toLowerCase().trim();
    final matchPercentage = _calculateMatchPercentage(partnerAAnswer, partnerBAnswer);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isMatch
              ? [AppColors.success.withOpacity(0.2), AppColors.success.withOpacity(0.1)]
              : [AppColors.warning.withOpacity(0.2), AppColors.warning.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(
          color: isMatch ? AppColors.success : AppColors.warning,
        ),
      ),
      child: Column(
        children: [
          Icon(
            isMatch ? Icons.favorite : Icons.compare_arrows,
            size: 48,
            color: isMatch ? AppColors.success : AppColors.warning,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            isMatch ? 'Perfect Match!' : 'Different Perspectives',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isMatch ? AppColors.success : AppColors.warning,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            isMatch
                ? 'You both gave the exact same answer!'
                : 'You have different views - great for conversation!',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          if (!isMatch) ...[
            const SizedBox(height: AppSpacing.md),
            LinearProgressIndicator(
              value: matchPercentage / 100,
              backgroundColor: AppColors.borderLight,
              valueColor: AlwaysStoppedAnimation<Color>(
                matchPercentage > 50 ? AppColors.success : AppColors.warning,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${(matchPercentage * 10).toInt()}% Similar',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: AppSpacing.buttonLg,
          child: ElevatedButton(
            onPressed: () {
              // Start a new round
              context.go('/question-engine');
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              shadowColor: AppColors.shadowLight,
              elevation: 8,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, size: 20),
                SizedBox(width: AppSpacing.sm),
                Text('Next Question'),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: AppSpacing.buttonMd,
          child: OutlinedButton(
            onPressed: () => context.pop(),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
            ),
            child: const Text('Back to Waiting Room'),
          ),
        ),
      ],
    );
  }

  Widget _buildNoRoomState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.meeting_room,
            size: 64,
            color: AppColors.textSecondaryLight,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'No room found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            height: AppSpacing.buttonMd,
            child: ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotReadyState(BuildContext context, dynamic state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hourglass_empty,
            size: 64,
            color: AppColors.warning,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Answers not ready',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Both partners need to submit answers first',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: AppSpacing.buttonMd,
            child: ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Back to Waiting Room'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'Loading answers...',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.error,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Failed to load answers',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            error.toString(),
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  double _calculateMatchPercentage(String answer1, String answer2) {
    // Simple similarity calculation based on common words
    final words1 = answer1.toLowerCase().split(RegExp(r'\s+')).toSet();
    final words2 = answer2.toLowerCase().split(RegExp(r'\s+')).toSet();

    if (words1.isEmpty || words2.isEmpty) return 0;

    final commonWords = words1.intersection(words2).length;
    final totalWords = (words1.length + words2.length) / 2;

    return commonWords / totalWords;
  }
}
