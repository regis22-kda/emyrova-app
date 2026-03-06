import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';

/// Spinning Roulette screen with animation
class SpinningRouletteScreen extends StatefulWidget {
  const SpinningRouletteScreen({super.key});

  @override
  State<SpinningRouletteScreen> createState() => _SpinningRouletteScreenState();
}

class _SpinningRouletteScreenState extends State<SpinningRouletteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  bool _isSpinning = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1440, // 4 full rotations
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward().then((_) {
      setState(() => _isSpinning = false);
      // Navigate to results after spinning stops
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) context.push('/roulette/results');
      });
    });

    // Trigger haptic feedback during spin
    _triggerHapticFeedback();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _triggerHapticFeedback() async {
    // Simulate haptic feedback during spin
    for (int i = 0; i < 8; i++) {
      await Future.delayed(Duration(milliseconds: i * 500));
      if (mounted && _isSpinning) {
        HapticFeedback.lightImpact();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            // Content
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  const Text(
                    AppStrings.spinningForAnswer,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    AppStrings.magicWheelDeciding,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  // Roulette wheel
                  _buildRouletteWheel(),
                  const SizedBox(height: AppSpacing.xl),
                  // Whoosh indicator
                  if (_isSpinning) _buildWhooshIndicator(),
                  const SizedBox(height: AppSpacing.lg),
                  // Haptic hint
                  if (_isSpinning)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 16,
                          color: AppColors.textSecondaryLight,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Feeling the rhythm...',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentPath: '/play'),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
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
              AppStrings.appName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildRouletteWheel() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow effect
        Container(
          width: 320,
          height: 320,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 40,
                spreadRadius: 8,
              ),
            ],
          ),
        ),
        // Ticker pointer
        Positioned(
          top: 0,
          child: Container(
            width: 32,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: const Center(
              child: VerticalDivider(
                width: 4,
                color: Colors.white,
                thickness: 2,
              ),
            ),
          ),
        ),
        // Animated wheel
        AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value * (math.pi / 180),
              child: _buildWheel(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWheel() {
    return Container(
      width: 320,
      height: 320,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const ConicGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryLight,
            AppColors.primaryDark,
            AppColors.primary,
            Color(0xFF6B21A8),
            AppColors.primary,
          ],
        ),
        border: Border.all(
          color: Colors.white,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight.withOpacity(0.3),
            blurRadius: 20,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Motion blur lines
          ...List.generate(4, (index) {
            return Transform.rotate(
              angle: (index * 45) * (math.pi / 180),
              child: Container(
                width: 320,
                height: 2,
                color: Colors.white.withOpacity(0.2),
              ),
            );
          }),
          // Center cap
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight.withOpacity(0.3),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const Icon(
              Icons.star,
              color: AppColors.primary,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhooshIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.vibration,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '*Whoosh*',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontStyle: FontStyle.italic,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
