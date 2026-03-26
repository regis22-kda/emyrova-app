import '../../core/error/failure.dart';
import '../../domain/entities/game_history.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_datasource.dart';

/// Repository implementation using [HistoryDataSource]
class HistoryRepositoryImpl implements IHistoryRepository {
  final HistoryDataSource _dataSource;
  final String _uid;

  const HistoryRepositoryImpl({
    required HistoryDataSource dataSource,
    required String uid,
  })  : _dataSource = dataSource,
        _uid = uid;

  @override
  Future<List<GameHistory>> getAllHistory() async {
    try {
      return await _dataSource.getAllHistory(_uid);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure('Failed to get history: $e');
    }
  }

  @override
  Future<GameHistory?> getHistoryById(String id) async {
    try {
      return await _dataSource.getHistoryById(_uid, id);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure('Failed to get history by id: $e');
    }
  }

  @override
  Future<void> saveHistory(GameHistory history) async {
    try {
      await _dataSource.saveHistory(_uid, history);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure('Failed to save history: $e');
    }
  }

  @override
  Future<void> deleteHistory(String id) async {
    try {
      await _dataSource.deleteHistory(_uid, id);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure('Failed to delete history: $e');
    }
  }

  @override
  Future<GameHistory?> getLatestHistory() async {
    try {
      return await _dataSource.getLatestHistory(_uid);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure('Failed to get latest history: $e');
    }
  }

  @override
  Future<List<GameHistory>> getHistoryPage({int limit = 10, int offset = 0}) async {
    // For now, just return all history - pagination can be added later
    try {
      final all = await _dataSource.getAllHistory(_uid);
      final start = offset.clamp(0, all.length);
      final end = (offset + limit).clamp(0, all.length);
      return all.sublist(start, end);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure('Failed to get history page: $e');
    }
  }
}
