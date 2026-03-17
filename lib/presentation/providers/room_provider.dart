import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/room.dart';
import '../../domain/repositories/room_repository.dart';
import '../providers/game_provider.dart';
import 'auth_provider.dart';

/// Room action states
sealed class RoomActionState {
  const RoomActionState();
}

class RoomActionIdle extends RoomActionState {
  const RoomActionIdle();
}

class RoomActionLoading extends RoomActionState {
  const RoomActionLoading();
}

class RoomActionSuccess extends RoomActionState {
  final Room? room;
  final String? roomCode;

  const RoomActionSuccess({this.room, this.roomCode});
}

class RoomActionError extends RoomActionState {
  final String message;

  const RoomActionError(this.message);
}

/// Notifier for room actions (create, join, submit answer)
class RoomActionsNotifier extends StateNotifier<RoomActionState> {
  final IRoomRepository _repository;

  RoomActionsNotifier(this._repository) : super(const RoomActionIdle());

  /// Create a new room
  Future<void> createRoom(String partnerAUid) async {
    state = const RoomActionLoading();
    try {
      final roomCode = await _repository.createRoom(partnerAUid);
      state = RoomActionSuccess(roomCode: roomCode);
    } catch (e) {
      state = RoomActionError('Failed to create room: $e');
    }
  }

  /// Join an existing room
  Future<void> joinRoom(String roomCode, String uid) async {
    state = const RoomActionLoading();
    try {
      final room = await _repository.joinRoom(roomCode, uid);
      state = RoomActionSuccess(room: room);
    } catch (e) {
      state = RoomActionError('Failed to join room: $e');
    }
  }

  /// Submit an answer
  Future<void> submitAnswer(
    String roomCode,
    bool isPartnerA,
    String answer,
  ) async {
    state = const RoomActionLoading();
    try {
      await _repository.submitAnswer(roomCode, isPartnerA, answer);
      state = const RoomActionIdle();
    } catch (e) {
      state = RoomActionError('Failed to submit answer: $e');
    }
  }

  /// Reset to idle state
  void reset() {
    state = const RoomActionIdle();
  }
}

/// Provider for room actions notifier
final roomActionsProvider =
    StateNotifierProvider<RoomActionsNotifier, RoomActionState>((ref) {
      final repository = ref.watch(roomRepositoryProvider);
      return RoomActionsNotifier(repository);
    });

/// Room state notifier for real-time room updates
class RoomStateNotifier extends StateNotifier<AsyncValue<Room?>> {
  final IRoomRepository _repository;
  StreamSubscription<Room>? _subscription;

  RoomStateNotifier(this._repository) : super(const AsyncValue.data(null));

  /// Start watching a room for real-time updates
  void watchRoom(String roomCode) {
    // Cancel existing subscription
    _subscription?.cancel();

    // Set loading state
    state = const AsyncValue.loading();

    // Subscribe to room updates
    _subscription = _repository
        .watchRoom(roomCode)
        .listen(
          (room) {
            state = AsyncValue.data(room);
          },
          onError: (error, stackTrace) {
            state = AsyncValue.error(error, stackTrace);
          },
        );
  }

  /// Stop watching the current room
  void stopWatching() {
    _subscription?.cancel();
    _subscription = null;
    state = const AsyncValue.data(null);
  }

  @override
  Future<void> dispose() async {
    await _subscription?.cancel();
    super.dispose();
  }
}

/// Provider for room state notifier
final roomStateNotifierProvider =
    StateNotifierProvider<RoomStateNotifier, AsyncValue<Room?>>((ref) {
      final repository = ref.watch(roomRepositoryProvider);
      return RoomStateNotifier(repository);
    });

/// Provider for current room code
final currentRoomCodeProvider = StateProvider<String?>((ref) => null);

/// Provider for checking if current user is partner A
final isPartnerAProvider = Provider<bool>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  final room = ref.watch(roomStateNotifierProvider).value;

  if (userId == null || room == null) {
    return false;
  }

  return room.partnerAUid == userId;
});
