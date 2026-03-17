import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../providers/auth_provider.dart';
import '../../providers/room_provider.dart';

/// Screen for joining an existing multiplayer room
class JoinRoomScreen extends ConsumerStatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  ConsumerState<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends ConsumerState<JoinRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _roomCodeController = TextEditingController();

  @override
  void dispose() {
    _roomCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roomActionState = ref.watch(roomActionsProvider);
    final userId = ref.watch(currentUserIdProvider);

    // Handle room join success
    if (roomActionState is RoomActionSuccess && roomActionState.room != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(currentRoomCodeProvider.notifier).state = roomActionState.room!.roomCode;
        context.push('/room/waiting?roomCode=${roomActionState.room!.roomCode}');
      });
    }

    // Handle errors
    if (roomActionState is RoomActionError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showErrorSnackbar(roomActionState.message);
          ref.read(roomActionsProvider.notifier).reset();
        }
      });
    }

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
                    const SizedBox(height: AppSpacing.xxl),
                    // Icon
                    _buildIcon(),
                    const SizedBox(height: AppSpacing.xxl),
                    // Title
                    _buildTitle(),
                    const SizedBox(height: AppSpacing.xxl),
                    // Room code input
                    _buildRoomCodeInput(userId),
                    const SizedBox(height: AppSpacing.xl),
                    // Join button
                    _buildJoinButton(userId),
                    const SizedBox(height: AppSpacing.xl),
                    // Divider
                    _buildDivider(),
                    const SizedBox(height: AppSpacing.lg),
                    // How to get code
                    _buildHowToGetCode(),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
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
              'Join Room',
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

  Widget _buildIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.meeting_room,
        size: 56,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildTitle() {
    return const Column(
      children: [
        Text(
          'Enter Room Code',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          'Join your partner\'s room to play together',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondaryLight,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRoomCodeInput(String? userId) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Room Code',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: _roomCodeController,
            enabled: ref.watch(roomActionsProvider) is! RoomActionLoading,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.done,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
            ),
            textAlign: TextAlign.center,
            maxLength: 5,
            decoration: InputDecoration(
              hintText: 'ABCDE',
              counterText: '',
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                borderSide: BorderSide(
                  color: AppColors.primary.withOpacity(0.2),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                borderSide: BorderSide(
                  color: AppColors.primary.withOpacity(0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                borderSide: const BorderSide(
                  color: AppColors.error,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.lg,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a room code';
              }
              if (value.length != 5) {
                return 'Room code must be 5 characters';
              }
              return null;
            },
            onFieldSubmitted: (_) => _joinRoom(userId),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinButton(String? userId) {
    final isLoading = ref.watch(roomActionsProvider) is RoomActionLoading;

    return SizedBox(
      height: AppSpacing.buttonLg,
      child: ElevatedButton(
        onPressed: (isLoading || userId == null) ? null : () => _joinRoom(userId),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          shadowColor: AppColors.shadowLight,
          elevation: 8,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login, size: 20),
                  SizedBox(width: AppSpacing.sm),
                  Text('Join Room'),
                ],
              ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.borderLight,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            'OR',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.borderLight,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildHowToGetCode() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: AppColors.primary,
                size: 20,
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                'How to get a room code',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'Ask your partner to create a room first. '
            'They will receive a 5-character code to share with you.',
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  void _joinRoom(String? userId) {
    if (!_formKey.currentState!.validate()) return;
    if (userId == null) return;

    final roomCode = _roomCodeController.text.trim().toUpperCase();
    ref.read(roomActionsProvider.notifier).joinRoom(roomCode, userId);
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }
}
