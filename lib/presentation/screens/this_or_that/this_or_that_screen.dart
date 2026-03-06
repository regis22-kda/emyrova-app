import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';

/// Placeholder screen for This or That game
class ThisOrThatScreen extends StatelessWidget {
  const ThisOrThatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.thisOrThat),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.compare_arrows,
                      size: 64,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Text(
                      AppStrings.thisOrThat,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      AppStrings.tapYourChoice,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    // Choice A
                    SizedBox(
                      width: double.infinity,
                      height: 120,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle choice A
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.movie, size: 32),
                            SizedBox(height: AppSpacing.sm),
                            Text(
                              'Cozy Movie Night',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    // Choice B
                    SizedBox(
                      width: double.infinity,
                      height: 120,
                      child: OutlinedButton(
                        onPressed: () {
                          // Handle choice B
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary, width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.explore, size: 32, color: AppColors.primary),
                            SizedBox(height: AppSpacing.sm),
                            Text(
                              'Adventurous Night Out',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
}
