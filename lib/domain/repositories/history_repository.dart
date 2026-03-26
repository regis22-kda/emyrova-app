import '../entities/game_history.dart';

/// Abstract repository for game history operations
abstract class IHistoryRepository {
  /// Get all history entries for the current user
  Future<List<GameHistory>> getAllHistory();

  /// Get a specific history entry by ID
  Future<GameHistory?> getHistoryById(String id);

  /// Save a new history entry
  Future<void> saveHistory(GameHistory history);

  /// Delete a history entry
  Future<void> deleteHistory(String id);

  /// Get the latest history entry
  Future<GameHistory?> getLatestHistory();

  /// Get history entries with pagination
  Future<List<GameHistory>> getHistoryPage({int limit = 10, int offset = 0});
}
