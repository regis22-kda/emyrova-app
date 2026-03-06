import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../domain/entities/roulette_option.dart';

/// Fill Roulette screen for customizing options
class FillRouletteScreen extends StatefulWidget {
  const FillRouletteScreen({super.key});

  @override
  State<FillRouletteScreen> createState() => _FillRouletteScreenState();
}

class _FillRouletteScreenState extends State<FillRouletteScreen> {
  final _optionController = TextEditingController();
  final List<RouletteOption> _options = [
    const RouletteOption(
      id: '1',
      label: 'Pizza Night',
      icon: 'local_pizza',
      color: '#8A2CE2',
    ),
    const RouletteOption(
      id: '2',
      label: 'Sushi Boat',
      icon: 'ramen_dining',
      color: '#3B82F6',
    ),
    const RouletteOption(
      id: '3',
      label: 'Taco Tuesday',
      icon: 'lunch_dining',
      color: '#EC4899',
    ),
  ];

  final List<Map<String, String>> _presets = [
    {'label': AppStrings.dinner, 'icon': 'restaurant'},
    {'label': AppStrings.movies, 'icon': 'movie'},
    {'label': AppStrings.chores, 'icon': 'cleaning_services'},
    {'label': AppStrings.dates, 'icon': 'travel_explore'},
  ];

  @override
  void dispose() {
    _optionController.dispose();
    super.dispose();
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Quick presets
                    _buildQuickPresets(),
                    const SizedBox(height: AppSpacing.xxl),
                    // Input field
                    _buildInputField(),
                    const SizedBox(height: AppSpacing.xxl),
                    // Current options list
                    _buildCurrentOptions(),
                    // Empty state
                    if (_options.isEmpty) _buildEmptyState(),
                  ],
                ),
              ),
            ),
            // Sticky footer button
            _buildStickyFooter(),
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
              AppStrings.customizeYourSpin,
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

  Widget _buildQuickPresets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.quickPresets,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          children: _presets.map((preset) {
            return Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getIconData(preset['icon'] ?? 'help'),
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    preset['label'] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What are we deciding?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _optionController,
                decoration: InputDecoration(
                  hintText: 'Add a new option...',
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(AppSpacing.radiusLg),
                      right: Radius.zero,
                    ),
                    borderSide: BorderSide(
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(AppSpacing.radiusLg),
                      right: Radius.zero,
                    ),
                    borderSide: BorderSide(
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(AppSpacing.radiusLg),
                      right: Radius.zero,
                    ),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                ),
              ),
            ),
            Container(
              height: 56,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(AppSpacing.radiusLg),
                ),
              ),
              child: IconButton(
                onPressed: _addOption,
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 56,
                  minHeight: 56,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrentOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Current Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: Text(
                '${_options.length} OPTIONS',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        ..._options.map((option) => _buildOptionItem(option)),
      ],
    );
  }

  Widget _buildOptionItem(RouletteOption option) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight.withOpacity(0.05),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          // Color dot
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _getColorFromHex(option.color),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Label
          Expanded(
            child: Text(
              option.label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Delete button
          IconButton(
            onPressed: () => _deleteOption(option.id),
            icon: const Icon(
              Icons.delete_outline,
              color: AppColors.textSecondaryLight,
            ),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xxl),
        Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withOpacity(0.2),
                Colors.transparent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.casino,
            size: 48,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Text(
            'ADD AT LEAST 2 OPTIONS TO START YOUR SPIN',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondaryLight,
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildStickyFooter() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.backgroundLight.withOpacity(0),
            AppColors.backgroundLight.withOpacity(0.9),
            AppColors.backgroundLight,
          ],
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: AppSpacing.buttonLg,
          child: ElevatedButton(
            onPressed: _options.length >= 2
                ? () => context.push('/roulette/spinning')
                : null,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              ),
              shadowColor: AppColors.shadowLight,
              elevation: _options.length >= 2 ? 12 : 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(AppStrings.readyToSpin),
                const SizedBox(width: AppSpacing.sm),
                const Icon(
                  Icons.auto_awesome,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addOption() {
    if (_optionController.text.trim().isEmpty) return;

    setState(() {
      _options.add(RouletteOption(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        label: _optionController.text.trim(),
        icon: 'star',
        color: '#${(DateTime.now().millisecondsSinceEpoch % 16777215).toRadixString(16).padLeft(6, '0')}',
      ));
      _optionController.clear();
    });
  }

  void _deleteOption(String id) {
    setState(() {
      _options.removeWhere((option) => option.id == id);
    });
  }

  IconData _getIconData(String iconName) {
    // Map icon names to IconData
    const icons = {
      'restaurant': Icons.restaurant,
      'movie': Icons.movie,
      'cleaning_services': Icons.cleaning_services,
      'travel_explore': Icons.travel_explore,
      'star': Icons.star,
      'local_pizza': Icons.local_pizza,
      'ramen_dining': Icons.ramen_dining,
      'lunch_dining': Icons.lunch_dining,
    };
    return icons[iconName] ?? Icons.help;
  }

  Color _getColorFromHex(String hexColor) {
    final hex = hexColor.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}
