import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../core/widgets/player_avatar.dart';
import '../../../domain/entities/player.dart';
import '../../providers/game_provider.dart';
import '../settings/player_name_settings_screen.dart';

/// Home screen widget
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final playerNames = ref.watch(playerNamesProvider);
    
    final players = [
      Player(id: 'player_1', name: playerNames.player1Name, avatarColor: '#FF9800'),
      Player(id: 'player_2', name: playerNames.player2Name, avatarColor: '#E91E63'),
    ];
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              // Mode indicator
              _buildModeIndicator(),
              // Hero section
              _buildHeroSection(),
              // Game cards
              _buildGameCards(),
              // Bottom spacer for nav
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentPath: '/'),
    );
  }

  Widget _buildHeader() {
    final playerNames = ref.watch(playerNamesProvider);
    
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          // Player avatars with edit on tap
          GestureDetector(
            onTap: _showEditNamesDialog,
            child: Tooltip(
              message: 'Tap to edit names',
              child: PlayerAvatarsGroup(players: [
                Player(id: 'player_1', name: playerNames.player1Name, avatarColor: '#FF9800'),
                Player(id: 'player_2', name: playerNames.player2Name, avatarColor: '#E91E63'),
              ], size: 48),
            ),
          ),
          // App name
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                AppStrings.appName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          // Settings button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.settings_outlined,
                color: AppColors.primary,
                size: 24,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.phonelink_setup,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            // Text
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.passAndPlay,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AppStrings.singleDevice,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
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

  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Container(
        height: 192,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: AppColors.primaryGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        child: Stack(
          children: [
            // Decorative gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
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
            // Content
            Positioned(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: AppSpacing.lg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppStrings.playTogether,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Challenge your friend sitting right next to you',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
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

  Widget _buildGameCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.chooseAGame,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Question Engine Card
          _buildGameCard(
            title: AppStrings.questionEngine,
            subtitle: AppStrings.deepDiveQuestions,
            imageUrl: 'sparkler',
            buttonText: AppStrings.startGame,
            isPopular: true,
            onTap: () => context.push('/question-engine'),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Decision Roulette Card
          _buildGameCard(
            title: AppStrings.decisionRoulette,
            subtitle: AppStrings.letFateDecide,
            imageUrl: 'roulette',
            buttonText: AppStrings.spinToPlay,
            onTap: () => context.push('/roulette'),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Mini-Games Hub Card
          _buildGameCard(
            title: AppStrings.miniGamesHub,
            subtitle: AppStrings.quickChallenges,
            imageUrl: 'controller',
            buttonText: AppStrings.enterHub,
            onTap: () => context.push('/play'),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard({
    required String title,
    required String subtitle,
    required String imageUrl,
    required String buttonText,
    VoidCallback? onTap,
    bool isPopular = false,
  }) {
    return Container(
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
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusXl),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 7,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.3),
                      AppColors.primaryDark.withOpacity(0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(
                    _getIconForImage(imageUrl),
                    size: 64,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isPopular)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                        child: const Text(
                          AppStrings.popular,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                  ],
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
                      shadowColor: AppColors.shadowLight,
                      elevation: 4,
                    ),
                    child: Text(buttonText),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForImage(String imageUrl) {
    switch (imageUrl) {
      case 'sparkler':
        return Icons.auto_awesome;
      case 'roulette':
        return Icons.casino;
      case 'controller':
        return Icons.sports_esports;
      default:
        return Icons.help_outline;
    }
  }

  void _showEditNamesDialog() {
    showDialog(
      context: context,
      builder: (context) => const PlayerNameSettingsDialog(),
    );
  }
}
