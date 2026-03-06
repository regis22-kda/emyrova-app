import 'package:flutter/material.dart';

import '../../domain/entities/question.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// Question card widget for displaying questions
class QuestionCard extends StatelessWidget {
  final Question question;
  final String? categoryLabel;

  const QuestionCard({super.key, required this.question, this.categoryLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image section
          if (question.imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.radiusXl),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: AppColors.primary.withOpacity(0.1),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Placeholder for image - in real app would use CachedNetworkImage
                      Icon(
                        _getIconForCategory(question.category),
                        size: 64,
                        color: AppColors.primary.withOpacity(0.5),
                      ),
                      // Gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Content section
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category badge
                if (categoryLabel != null || question.category.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.radiusFull,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.casino, size: 14, color: Colors.white),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          categoryLabel ?? question.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: AppSpacing.md),
                // Question prompt
                Text(
                  question.prompt,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Subtext
                if (question.subtext != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    question.subtext!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'hypothetical':
        return Icons.lightbulb_outline;
      case 'memories':
        return Icons.photo_library_outlined;
      case 'future dreams':
        return Icons.auto_awesome;
      case 'fun':
        return Icons.celebration_outlined;
      case 'deep':
        return Icons.psychology_outlined;
      case 'travel':
        return Icons.flight_takeoff;
      case 'childhood':
        return Icons.toys_outlined;
      case 'love language':
        return Icons.favorite_outline;
      case 'adventure':
        return Icons.explore_outlined;
      case 'food':
        return Icons.restaurant;
      case 'entertainment':
        return Icons.movie_outlined;
      case 'gratitude':
        return Icons.self_improvement;
      case 'relationship':
        return Icons.favorite_border;
      case 'daily life':
        return Icons.today;
      default:
        return Icons.help_outline;
    }
  }
}
