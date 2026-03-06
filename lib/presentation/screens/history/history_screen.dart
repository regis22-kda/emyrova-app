import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';

/// History/Memories screen
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      AppStrings.all,
      AppStrings.questions,
      AppStrings.roulette,
      AppStrings.miniGames,
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            // Categories
            _buildCategories(categories),
            // History list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  // Today section
                  _buildSectionHeader(AppStrings.today),
                  const SizedBox(height: AppSpacing.sm),
                  _buildHistoryCard(
                    gameType: AppStrings.roulette,
                    title: 'Winner: Pizza Night',
                    timestamp: '2h ago',
                    icon: Icons.casino,
                    hasImage: true,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildHistoryCard(
                    gameType: AppStrings.thisOrThat,
                    title: '"70% Match with Sarah"',
                    subtitle: 'Beach vs Mountains',
                    timestamp: '3h ago',
                    icon: Icons.compare_arrows,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  // Yesterday section
                  _buildSectionHeader(AppStrings.yesterday),
                  const SizedBox(height: AppSpacing.sm),
                  _buildHistoryCard(
                    gameType: 'Daily Question',
                    title: 'What\'s your dream travel destination?',
                    timestamp: '1d ago',
                    icon: Icons.psychology,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildHistoryCard(
                    gameType: AppStrings.miniGames,
                    title: 'Word Blitz Mastery',
                    subtitle: 'Score: 2,450 pts (New High!)',
                    timestamp: '1d ago',
                    icon: Icons.sports_esports,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentPath: '/history'),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
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
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.primary,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
          const Expanded(
            child: Text(
              AppStrings.memories,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(List<String> categories) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final isSelected = index == 0;
          return Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.borderLight,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.shadowLight,
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  categories[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : null,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondaryLight,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildHistoryCard({
    required String gameType,
    required String title,
    String? subtitle,
    required String timestamp,
    required IconData icon,
    bool hasImage = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: AppColors.borderLight.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      gameType,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                timestamp,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
          if (hasImage) ...[
            const SizedBox(height: AppSpacing.md),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: const Icon(
                  Icons.local_pizza,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
