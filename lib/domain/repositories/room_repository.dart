import '../entities/room.dart';
import '../entities/room_state.dart';

/// Abstract repository for room and authentication operations
abstract class IRoomRepository {
  /// Signs in anonymously and returns the user ID
  /// Persists across app sessions
  Future<String> signInAnonymously();

  /// Creates a new room for the given partner A UID
  /// Returns a 5-character alphanumeric room code
  Future<String> createRoom(String partnerAUid);

  /// Joins an existing room with the given room code
  /// Updates the partner_b_uid field
  Future<Room?> joinRoom(String roomCode, String uid);

  /// Gets a room by its code
  Future<Room?> getRoom(String roomCode);

  /// Submits an answer for the current room
  /// [isPartnerA] determines which answer field to update
  Future<void> submitAnswer(String roomCode, bool isPartnerA, String answer);

  /// Watches a room for real-time updates
  /// Emits [Room] state changes based on answer submissions
  Stream<Room> watchRoom(String roomCode);
}
