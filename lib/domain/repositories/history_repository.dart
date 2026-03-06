import '../entities/history_entry.dart';

/// Abstract repository for history operations
abstract class IHistoryRepository {
  /// Gets all history entries
  Future<List<HistoryEntry>> getHistory();

  /// Gets history entries by game type
  Future<List<HistoryEntry>> getHistoryByType(GameType type);

  /// Gets history entries from today
  Future<List<HistoryEntry>> getTodayHistory();

  /// Saves a new history entry
  Future<void> saveEntry(HistoryEntry entry);

  /// Deletes a history entry
  Future<void> deleteEntry(String id);

  /// Clears all history
  Future<void> clearHistory();
}
