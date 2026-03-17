import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../domain/entities/room_state.dart';
import '../../providers/game_provider.dart';
import '../../providers/room_provider.dart';

/// Screen for waiting in a multiplayer room
class WaitingRoomScreen extends ConsumerStatefulWidget {
  const WaitingRoomScreen({super.key});

  @override
  ConsumerState<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends ConsumerState<WaitingRoomScreen> {
  @override
  void initState() {
    super.initState();
    // Start watching the room when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final roomCode = ref.read(currentRoomCodeProvider);
      if (roomCode != null) {
        ref.read(roomStateNotifierProvider.notifier).watchRoom(roomCode);
      }
    });
  }

  @override
  void dispose() {
    ref.read(roomStateNotifierProvider.notifier).stopWatching();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final roomState = ref.watch(roomStateNotifierProvider);
    final isPartnerA = ref.watch(isPartnerAProvider);
    final roomCode = ref.watch(currentRoomCodeProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(roomCode),
            // Content
            Expanded(
              child: roomState.when(
                data: (room) => _buildContent(room, isPartnerA),
                loading: () => _buildLoadingState(),
                error: (error, stack) => _buildErrorState(error),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentPath: '/play'),
    );
  }

  Widget _buildHeader(String? roomCode) {
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
              onPressed: () {
                ref.read(roomStateNotifierProvider.notifier).stopWatching();
                context.pop();
              },
              icon: const Icon(
                Icons.close,
                color: AppColors.primary,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
          const Expanded(
            child: Text(
              'Waiting Room',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (roomCode != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: Text(
                roomCode,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(dynamic room, bool isPartnerA) {
    if (room == null) {
      return _buildLoadingState();
    }

    final roomState = room.state;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.lg),
          // Room code display
          _buildRoomCodeCard(room.roomCode),
          const SizedBox(height: AppSpacing.xxl),
          // Player status
          _buildPlayerStatus(room, isPartnerA),
          const SizedBox(height: AppSpacing.xxl),
          // Status indicator based on room state
          _buildStatusIndicator(roomState, isPartnerA),
          const SizedBox(height: AppSpacing.xxl),
          // Action button
          _buildActionButton(roomState, isPartnerA),
        ],
      ),
    );
  }

  Widget _buildRoomCodeCard(String roomCode) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Column(
        children: [
          const Text(
            'Room Code',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            roomCode,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 8,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.share,
                size: 16,
                color: Colors.white.withOpacity(0.8),
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Share this code with your partner',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerStatus(dynamic room, bool isPartnerA) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Players',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildPlayerItem(
          'You${isPartnerA ? ' (Host)' : ''}',
          true,
          isPartnerA ? room.partnerAUid : room.partnerBUid,
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildPlayerItem(
          'Partner${!isPartnerA ? ' (Host)' : ''}',
          isPartnerA ? room.partnerBUid != null : room.partnerAUid != null,
          isPartnerA ? room.partnerBUid : room.partnerAUid,
        ),
      ],
    );
  }

  Widget _buildPlayerItem(String label, bool isPresent, String? uid) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: isPresent ? AppColors.success : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isPresent
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.borderLight.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPresent ? Icons.person : Icons.person_outline,
              color: isPresent ? AppColors.success : AppColors.textSecondaryLight,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isPresent ? 'Ready to play' : 'Waiting...',
                  style: TextStyle(
                    fontSize: 12,
                    color: isPresent ? AppColors.success : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          if (isPresent)
            const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 20,
            )
          else
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(RoomState state, bool isPartnerA) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: _getStatusColor(state).withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(
          color: _getStatusColor(state).withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            _getStatusIcon(state),
            size: 48,
            color: _getStatusColor(state),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            _getStatusTitle(state, isPartnerA),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _getStatusMessage(state, isPartnerA),
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(RoomState state, bool isPartnerA) {
    // If both partners are present and no answers submitted yet
    if (state is WaitingForBoth) {
      return SizedBox(
        height: AppSpacing.buttonLg,
        child: ElevatedButton(
          onPressed: () => context.push('/question-engine'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            shadowColor: AppColors.shadowLight,
            elevation: 8,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.play_arrow, size: 20),
              SizedBox(width: AppSpacing.sm),
              Text('Start Game'),
            ],
          ),
        ),
      );
    }

    // If waiting for partner to answer
    if (state is WaitingForPartner) {
      return Column(
        children: [
          SizedBox(
            height: AppSpacing.buttonLg,
            child: ElevatedButton(
              onPressed: () => context.push('/question-engine'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
                shadowColor: AppColors.shadowLight,
                elevation: 8,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: AppSpacing.sm),
                  Text('Submit Your Answer'),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Your partner has answered. Submit yours to see results!',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondaryLight,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    // If both answered - show reveal button
    if (state is Revealed) {
      return SizedBox(
        height: AppSpacing.buttonLg,
        child: ElevatedButton(
          onPressed: () {
            // Navigate to results with answers
            context.push('/room/results');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            shadowColor: AppColors.shadowLight,
            elevation: 8,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.visibility, size: 20),
              SizedBox(width: AppSpacing.sm),
              Text('Reveal Answers'),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'Loading room...',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
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
            'Failed to load room',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            error.toString(),
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(RoomState state) {
    if (state is WaitingForBoth) return AppColors.primary;
    if (state is WaitingForPartner) return AppColors.warning;
    if (state is Revealed) return AppColors.success;
    return AppColors.textSecondaryLight;
  }

  IconData _getStatusIcon(RoomState state) {
    if (state is WaitingForBoth) return Icons.people_alt;
    if (state is WaitingForPartner) return Icons.hourglass_empty;
    if (state is Revealed) return Icons.celebration;
    return Icons.help_outline;
  }

  String _getStatusTitle(RoomState state, bool isPartnerA) {
    if (state is WaitingForBoth) return 'Waiting for Partner';
    if (state is WaitingForPartner) return 'Partner Answered!';
    if (state is Revealed) return 'Ready to Reveal';
    return 'Unknown State';
  }

  String _getStatusMessage(RoomState state, bool isPartnerA) {
    if (state is WaitingForBoth) {
      return 'Share the room code with your partner to start playing';
    }
    if (state is WaitingForPartner) {
      return 'Your partner has submitted their answer. Submit yours to continue!';
    }
    if (state is Revealed) {
      return 'Both answers are in! Tap below to see what you both wrote.';
    }
    return '';
  }
}
