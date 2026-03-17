import '../../domain/entities/room.dart';

/// Abstract interface for room data sources
abstract class RoomDataSource {
  /// Signs in anonymously and returns the user ID
  Future<String> signInAnonymously();

  /// Creates a new room and returns the room code
  Future<String> createRoom(String partnerAUid);

  /// Joins an existing room
  Future<Room?> joinRoom(String roomCode, String uid);

  /// Gets a room by its code
  Future<Room?> getRoom(String roomCode);

  /// Submits an answer for a partner
  Future<void> submitAnswer(String roomCode, bool isPartnerA, String answer);

  /// Watches a room for real-time updates
  Stream<Room?> watchRoom(String roomCode);
}
