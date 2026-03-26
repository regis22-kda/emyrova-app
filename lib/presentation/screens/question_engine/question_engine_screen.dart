import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../core/widgets/question_card.dart';
import '../../../core/widgets/progress_bar.dart';
import '../../../core/widgets/player_avatar.dart';
import '../../../domain/entities/game_session.dart';
import '../../providers/game_provider.dart';

/// Question Engine screen for player turns
class QuestionEngineScreen extends ConsumerStatefulWidget {
  const QuestionEngineScreen({super.key});

  @override
  ConsumerState<QuestionEngineScreen> createState() => _QuestionEngineScreenState();
}

class _QuestionEngineScreenState extends ConsumerState<QuestionEngineScreen> {
  final _answerController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Reset _isSubmitting to false when screen initializes
    _isSubmitting = false;

    // Load a random question and handle game flow when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final notifier = ref.read(gameSessionProvider.notifier);
        final currentQuestion = ref.read(currentQuestionProvider);

        // Check if game is complete - navigate to results
        if (notifier.isGameComplete) {
          context.push('/question-engine/results');
          return;
        }

        // Only load a new question if:
        // 1. No question is loaded yet, OR
        // 2. The round number changed (new round started)
        if (currentQuestion == null) {
          _loadRandomQuestion();
        }
        // If question exists, keep it for both players to answer
      }
    });
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  void _loadRandomQuestion() {
    // Force refresh by invalidating the provider cache first
    ref.invalidate(loadRandomQuestionProvider);
    
    ref.read(loadRandomQuestionProvider.future).then((question) {
      if (mounted) {
        ref.read(currentQuestionProvider.notifier).setQuestion(question);
      }
    }).catchError((error) {
      if (mounted) {
        _showErrorSnackbar('Failed to load question: $error');
      }
    });
  }

  void _clearAnswerField() {
    _answerController.clear();
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(gameSessionProvider);
    final currentQuestion = ref.watch(currentQuestionProvider);
    final questionState = ref.watch(loadRandomQuestionProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(session),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Progress
                    GameProgressBar(
                      current: session.currentRound,
                      total: session.totalRounds,
                      label: 'Question ${session.currentRound} of ${session.totalRounds}',
                      progressText: '${((session.currentRound / session.totalRounds) * 100).toInt()}% Completed',
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    // Question card or loading state
                    if (questionState is AsyncLoading)
                      _buildLoadingState()
                    else if (questionState is AsyncError)
                      _buildErrorState(questionState.error)
                    else if (currentQuestion != null)
                      QuestionCard(
                        question: currentQuestion,
                        categoryLabel: currentQuestion.category,
                      )
                    else
                      _buildErrorState('No question loaded'),
                    const SizedBox(height: AppSpacing.xl),
                    // Answer input
                    _buildAnswerInput(session),
                    const SizedBox(height: AppSpacing.lg),
                    // Submit button
                    _buildSubmitButton(session),
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

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: const Column(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'Loading question...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object? error) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(
          color: AppColors.error.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.error,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Failed to load question',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            error?.toString() ?? 'Unknown error',
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
              onPressed: _loadRandomQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
              ),
              child: const Text('Retry'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(GameSession session) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          // Close button
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
          // Title
          Expanded(
            child: Column(
              children: [
                Text(
                  'Current Player',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary.withOpacity(0.6),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${session.currentPlayer.name}'s Turn",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Help button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => _showHelpDialog(),
              icon: const Icon(
                Icons.help_outline,
                color: AppColors.primary,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerInput(GameSession session) {
    final hasPlayerAnswered = session.answers.containsKey(session.currentPlayer.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.yourSecretAnswer,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _answerController,
          enabled: !hasPlayerAnswered && !_isSubmitting,
          maxLines: 4,
          minLines: 4,
          decoration: InputDecoration(
            hintText: hasPlayerAnswered
                ? 'Answer locked in!'
                : 'Type your answer here...',
            filled: true,
            fillColor: hasPlayerAnswered
                ? AppColors.backgroundLight
                : Theme.of(context).cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              borderSide: BorderSide(
                color: hasPlayerAnswered
                    ? AppColors.borderLight
                    : AppColors.primary.withOpacity(0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              borderSide: BorderSide(
                color: AppColors.primary.withOpacity(0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(GameSession session) {
    final hasPlayerAnswered = session.answers.containsKey(session.currentPlayer.id);
    final isLastPlayer = session.answers.length == session.players.length - 1;

    return Column(
      children: [
        SizedBox(
          height: AppSpacing.buttonLg,
          child: ElevatedButton(
            onPressed: hasPlayerAnswered ? null : _submitAnswer,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              shadowColor: AppColors.shadowLight,
              elevation: 8,
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(AppStrings.submitAndPass),
                      const SizedBox(width: AppSpacing.sm),
                      const Icon(Icons.arrow_forward, size: 20),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          AppStrings.hideYourScreen,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondaryLight,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  void _submitAnswer() {
    if (_answerController.text.trim().isEmpty) return;

    setState(() => _isSubmitting = true);

    // Simulate submission delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      final notifier = ref.read(gameSessionProvider.notifier);
      notifier.addAnswer(_answerController.text.trim());

      // Clear the answer field for next player
      _clearAnswerField();
      setState(() => _isSubmitting = false);

      // Check if all players have answered
      final session = ref.read(gameSessionProvider);
      if (session.allPlayersAnswered) {
        // Check if game is complete (all rounds done)
        if (notifier.isGameComplete) {
          // Navigate to final results
          context.push('/question-engine/results');
        } else {
          // Navigate to round results to show answers
          context.push('/question-engine/results');
        }
      } else {
        // Show pass to next player screen
        context.push('/question-engine/pass-turn');
      }
    });
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Play'),
        content: const Text(
          '1. Read the question carefully\n'
          '2. Type your honest answer\n'
          '3. Submit and pass the device to the next player\n'
          '4. Don\'t let others see your answer!\n'
          '5. After everyone answers, compare results!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }
}
