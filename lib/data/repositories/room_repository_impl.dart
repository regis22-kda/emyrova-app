import '../../core/error/failure.dart';
import '../../domain/entities/room.dart';
import '../../domain/repositories/room_repository.dart';
import '../datasources/room_datasource.dart';

/// Repository implementation using [RoomDataSource]
class RoomRepositoryImpl implements IRoomRepository {
  final RoomDataSource _dataSource;

  const RoomRepositoryImpl({required RoomDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<String> signInAnonymously() async {
    try {
      return await _dataSource.signInAnonymously();
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure('Failed to sign in: $e');
    }
  }

  @override
  Future<String> createRoom(String partnerAUid) async {
    try {
      return await _dataSource.createRoom(partnerAUid);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure('Failed to create room: $e');
    }
  }

  @override
  Future<Room?> joinRoom(String roomCode, String uid) async {
    try {
      return await _dataSource.joinRoom(roomCode, uid);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure('Failed to join room: $e');
    }
  }

  @override
  Future<Room?> getRoom(String roomCode) async {
    try {
      return await _dataSource.getRoom(roomCode);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure('Failed to get room: $e');
    }
  }

  @override
  Future<void> submitAnswer(
    String roomCode,
    bool isPartnerA,
    String answer,
  ) async {
    try {
      await _dataSource.submitAnswer(roomCode, isPartnerA, answer);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure('Failed to submit answer: $e');
    }
  }

  @override
  Stream<Room> watchRoom(String roomCode) {
    try {
      return _dataSource
          .watchRoom(roomCode)
          .where((room) => room != null)
          .cast<Room>();
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure('Failed to watch room: $e');
    }
  }
}
