import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';

/// Play hub screen showing all available games
class PlayHubScreen extends StatelessWidget {
  const PlayHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Game'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _buildGameCard(
              context,
              title: 'Question Engine',
              subtitle: 'Deep dive into fun questions',
              icon: Icons.auto_awesome,
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFF6B6B)],
              ),
              onTap: () => context.push('/question-engine'),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildGameCard(
              context,
              title: 'Decision Roulette',
              subtitle: 'Let fate decide your next move',
              icon: Icons.casino,
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
              ),
              onTap: () => context.push('/roulette'),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildGameCard(
              context,
              title: 'This or That',
              subtitle: 'Choose between two options',
              icon: Icons.compare_arrows,
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF3B82F6)],
              ),
              onTap: () => context.push('/this-or-that'),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildGameCard(
              context,
              title: "Who's More Likely",
              subtitle: 'Vote on who fits the description',
              icon: Icons.people,
              gradient: const LinearGradient(
                colors: [Color(0xFFEC4899), Color(0xFFF59E0B)],
              ),
              onTap: () => context.push('/whos-more-likely'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentPath: '/play'),
    );
  }

  Widget _buildGameCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: Border.all(
            color: AppColors.borderLight.withOpacity(0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight.withOpacity(0.1),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icon section
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.radiusXl),
              ),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: gradient,
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: AppSpacing.buttonMd,
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                      ),
                      child: const Text('Play Now'),
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
}
