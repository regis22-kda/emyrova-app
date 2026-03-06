import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// Progress bar widget for game progress
class GameProgressBar extends StatelessWidget {
  final int current;
  final int total;
  final String? label;
  final String? progressText;

  const GameProgressBar({
    super.key,
    required this.current,
    required this.total,
    this.label,
    this.progressText,
  });

  @override
  Widget build(BuildContext context) {
    final progress = current / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row
        if (label != null || progressText != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                if (progressText != null)
                  Text(
                    progressText!,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
              ],
            ),
          ),
        // Progress bar
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            child: FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppSpacing.radiusFull),
                    bottom: Radius.circular(AppSpacing.radiusFull),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Circular progress indicator for rounds
class RoundProgress extends StatelessWidget {
  final int currentRound;
  final int totalRounds;

  const RoundProgress({
    super.key,
    required this.currentRound,
    required this.totalRounds,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalRounds, (index) {
        final isCompleted = index < currentRound;
        final isCurrent = index == currentRound - 1;

        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? AppColors.primary
                : isCurrent
                    ? AppColors.primary.withOpacity(0.5)
                    : AppColors.borderLight,
          ),
        );
      }),
    );
  }
}
