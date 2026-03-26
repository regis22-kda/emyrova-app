import '../../domain/entities/game_history.dart';

/// Abstract interface for history data sources
abstract class HistoryDataSource {
  /// Get all history entries for the current user
  Future<List<GameHistory>> getAllHistory(String uid);

  /// Get a specific history entry by ID
  Future<GameHistory?> getHistoryById(String uid, String id);

  /// Save a new history entry
  Future<void> saveHistory(String uid, GameHistory history);

  /// Delete a history entry
  Future<void> deleteHistory(String uid, String id);

  /// Get the latest history entry
  Future<GameHistory?> getLatestHistory(String uid);
}
