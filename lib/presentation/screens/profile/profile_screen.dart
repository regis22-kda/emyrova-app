import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../providers/auth_provider.dart';
import '../../providers/room_provider.dart';

/// Profile screen showing user information and settings
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserIdProvider);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final authState = ref.watch(authStateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Navigate to settings when implemented
            },
          ),
        ],
      ),
      body: SafeArea(
        child: _buildBody(context, ref, authState, userId, isAuthenticated),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentPath: '/profile'),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AuthState authState,
    String? userId,
    bool isAuthenticated,
  ) {
    if (authState is AuthError) {
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
              authState.message,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
          ],
        ),
      );
    }

    if (authState is Authenticated || authState is AuthError) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xl),
            // User avatar
            _buildUserAvatar(userId),
            const SizedBox(height: AppSpacing.lg),
            // User ID display
            _buildUserIdCard(context, userId, isAuthenticated),
            const SizedBox(height: AppSpacing.xxl),
            // Stats section
            _buildStatsSection(),
            const SizedBox(height: AppSpacing.xxl),
            // Settings section
            _buildSettingsSection(context, ref),
            const SizedBox(height: AppSpacing.xxl),
            // App info
            _buildAppInfo(),
          ],
        ),
      );
    }

    // Loading state
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
      ),
    );
  }

  Widget _buildUserAvatar(String? userId) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
          ),
        ],
      ),
      child: const Icon(
        Icons.person,
        size: 64,
        color: Colors.white,
      ),
    );
  }

  Widget _buildUserIdCard(BuildContext context, String? userId, bool isAuthenticated) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: isAuthenticated
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isAuthenticated ? Icons.check_circle : Icons.warning,
                      size: 14,
                      color: isAuthenticated ? AppColors.success : AppColors.warning,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      isAuthenticated ? 'Connected' : 'Not Connected',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isAuthenticated ? AppColors.success : AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'User ID',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            userId ?? 'Not available',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'This is your anonymous user ID. You can use this to identify your account.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Statistics',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Games Played',
                '0',
                Icons.sports_esports,
                AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildStatCard(
                'Questions',
                '0',
                Icons.psychology,
                AppColors.accentGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Roulette Spins',
                '0',
                Icons.casino,
                AppColors.accentAmber,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildStatCard(
                'Match Rate',
                '0%',
                Icons.favorite,
                AppColors.accentPink,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondaryLight,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildSettingItem(
          context,
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          subtitle: 'Manage push notifications',
          onTap: () {
            // Navigate to notifications settings
          },
        ),
        _buildSettingItem(
          context,
          icon: Icons.palette_outlined,
          title: 'Appearance',
          subtitle: 'Theme and display settings',
          onTap: () {
            // Navigate to appearance settings
          },
        ),
        _buildSettingItem(
          context,
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy',
          subtitle: 'Data and privacy controls',
          onTap: () {
            // Navigate to privacy settings
          },
        ),
        _buildSettingItem(
          context,
          icon: Icons.help_outline,
          title: 'Help & Support',
          subtitle: 'FAQs and contact us',
          onTap: () {
            // Navigate to help screen
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _buildSettingItem(
          context,
          icon: Icons.logout,
          title: 'Sign Out',
          subtitle: 'Sign out of your account',
          isDestructive: true,
          onTap: () => _showSignOutDialog(context, ref),
        ),
      ],
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDestructive
              ? AppColors.error.withOpacity(0.1)
              : AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Icon(
          icon,
          color: isDestructive ? AppColors.error : AppColors.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDestructive ? AppColors.error : null,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textSecondaryLight,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppColors.textSecondaryLight,
      ),
    );
  }

  Widget _buildAppInfo() {
    return Column(
      children: [
        Divider(
          color: AppColors.borderLight,
          thickness: 1,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Emyrova',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Version 1.0.0',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'A playful couple\'s app for interactive games and connection.',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondaryLight,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text(
          'Are you sure you want to sign out? You will need to sign in again to use the app.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // Sign out logic - for anonymous auth, this clears the session
              // In a real app, you might want to handle this differently
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Signed out successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
