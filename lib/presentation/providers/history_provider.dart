import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/firebase_history_datasource.dart';
import '../../data/repositories/history_repository_impl.dart';
import '../../domain/entities/game_history.dart';
import '../../domain/repositories/history_repository.dart';
import '../providers/auth_provider.dart';

/// History data source provider (Firebase)
final historyDataSourceProvider = Provider<FirebaseHistoryDataSource>((ref) {
  return FirebaseHistoryDataSource();
});

/// History repository provider - requires user ID
final historyRepositoryProvider = Provider<HistoryRepositoryImpl>((ref) {
  final dataSource = ref.watch(historyDataSourceProvider);
  final uid = ref.watch(currentUserIdProvider);

  if (uid == null) {
    throw Exception('User not authenticated');
  }

  return HistoryRepositoryImpl(dataSource: dataSource, uid: uid);
});

/// Provider for loading all history entries
final loadHistoryProvider = FutureProvider<List<GameHistory>>((ref) async {
  final repository = ref.watch(historyRepositoryProvider);
  return repository.getAllHistory();
});

/// State notifier for managing history state
class HistoryNotifier extends StateNotifier<AsyncValue<List<GameHistory>>> {
  final IHistoryRepository _repository;

  HistoryNotifier(this._repository) : super(const AsyncValue.loading());

  /// Load all history entries
  Future<void> loadHistory() async {
    state = const AsyncValue.loading();
    try {
      final history = await _repository.getAllHistory();
      state = AsyncValue.data(history);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Save a history entry
  Future<void> saveHistory(GameHistory history) async {
    try {
      await _repository.saveHistory(history);
      // Reload history after saving
      await loadHistory();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Delete a history entry
  Future<void> deleteHistoryEntry(String id) async {
    try {
      await _repository.deleteHistory(id);
      // Reload history after deletion
      await loadHistory();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Refresh history
  Future<void> refresh() async {
    await loadHistory();
  }
}

/// Provider for history notifier
final historyNotifierProvider =
    StateNotifierProvider<HistoryNotifier, AsyncValue<List<GameHistory>>>((
      ref,
    ) {
      final repository = ref.watch(historyRepositoryProvider);
      final notifier = HistoryNotifier(repository);
      notifier.loadHistory();
      return notifier;
    });
