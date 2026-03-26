import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../providers/game_provider.dart';

/// Player name settings dialog
class PlayerNameSettingsDialog extends ConsumerStatefulWidget {
  const PlayerNameSettingsDialog({super.key});

  @override
  ConsumerState<PlayerNameSettingsDialog> createState() =>
      _PlayerNameSettingsDialogState();
}

class _PlayerNameSettingsDialogState
    extends ConsumerState<PlayerNameSettingsDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _player1Controller;
  late TextEditingController _player2Controller;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final playerNames = ref.read(playerNamesProvider);
    _player1Controller = TextEditingController(text: playerNames.player1Name);
    _player2Controller = TextEditingController(text: playerNames.player2Name);
  }

  @override
  void dispose() {
    _player1Controller.dispose();
    _player2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      title: const Row(
        children: [
          Icon(Icons.edit, color: AppColors.primary),
          SizedBox(width: AppSpacing.md),
          Text('Edit Player Names'),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Player 1 name field
            TextFormField(
              controller: _player1Controller,
              decoration: InputDecoration(
                labelText: 'Player 1 Name',
                hintText: 'Enter player 1 name',
                prefixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  borderSide: BorderSide(
                    color: AppColors.primary.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                if (value.trim().length < 2) {
                  return 'Name must be at least 2 characters';
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: AppSpacing.lg),
            // Player 2 name field
            TextFormField(
              controller: _player2Controller,
              decoration: InputDecoration(
                labelText: 'Player 2 Name',
                hintText: 'Enter player 2 name',
                prefixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.accentPink.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: AppColors.accentPink,
                    size: 20,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  borderSide: BorderSide(
                    color: AppColors.accentPink.withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  borderSide: const BorderSide(
                    color: AppColors.accentPink,
                    width: 2,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                if (value.trim().length < 2) {
                  return 'Name must be at least 2 characters';
                }
                return null;
              },
              textCapitalization: TextCapitalization.words,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _saveNames,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
          ),
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              : const Text('Save'),
        ),
      ],
    );
  }

  void _saveNames() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final player1Name = _player1Controller.text.trim();
    final player2Name = _player2Controller.text.trim();

    // Update player names in provider
    ref
        .read(playerNamesProvider.notifier)
        .updatePlayerNames(player1Name, player2Name);

    // Close dialog with delay to show saving state
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _isSaving = false);
        Navigator.pop(context);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Player names updated!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
          ),
        );
      }
    });
  }
}
