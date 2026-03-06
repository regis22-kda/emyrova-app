import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';

/// Roulette results screen showing the winner
class RouletteResultsScreen extends StatelessWidget {
  const RouletteResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  children: [
                    // Celebration header
                    _buildCelebrationHeader(),
                    const SizedBox(height: AppSpacing.xxl),
                    // Winning card
                    _buildWinningCard(),
                    const SizedBox(height: AppSpacing.xxl),
                    // Action buttons
                    _buildActionButtons(context),
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
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.primary,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
          const Expanded(
            child: Text(
              'Spin Result',
              style: TextStyle(
                fontSize: 18,
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
              Icons.more_horiz,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCelebrationHeader() {
    return Column(
      children: [
        // Celebration icon
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.celebration,
            color: AppColors.primary,
            size: 40,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Title
        const Text(
          AppStrings.weHaveWinner,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        // Subtitle
        Text(
          AppStrings.rouletteHasSpoken,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textSecondaryLight,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildWinningCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primaryLight.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        child: Column(
          children: [
            // Image section
            Stack(
              children: [
                Container(
                  height: 256,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryDark.withOpacity(0.8),
                        AppColors.primary.withOpacity(0.6),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.local_pizza,
                      size: 128,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Winning badge
                Positioned(
                  left: AppSpacing.lg,
                  bottom: AppSpacing.lg,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: const Text(
                      'WINNING CHOICE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                // Share button
                Positioned(
                  right: AppSpacing.lg,
                  bottom: AppSpacing.lg,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_pizza,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                // Winner text overlay
                Positioned(
                  left: AppSpacing.lg,
                  bottom: 72,
                  child: const Text(
                    'Pizza Night',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            // Bottom section
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              color: Theme.of(context).cardColor,
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  // Text
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SELECTED FROM',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondaryLight,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'Dinner Options',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Share button
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.share,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Accept result button
        SizedBox(
          height: AppSpacing.buttonLg,
          child: ElevatedButton(
            onPressed: () {
              context.pop();
              context.pop();
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              shadowColor: AppColors.shadowLight,
              elevation: 12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, size: 24),
                const SizedBox(width: AppSpacing.sm),
                const Text(
                  AppStrings.acceptResult,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // Spin again button
        SizedBox(
          height: AppSpacing.buttonLg,
          child: OutlinedButton(
            onPressed: () {
              context.pop();
              context.push('/roulette');
            },
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              foregroundColor: AppColors.primary,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.refresh, size: 24),
                const SizedBox(width: AppSpacing.sm),
                const Text(
                  AppStrings.spinAgain,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
