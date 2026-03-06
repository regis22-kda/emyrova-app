import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';

/// Placeholder Profile screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Coming soon!',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentPath: '/profile'),
    );
  }
}
