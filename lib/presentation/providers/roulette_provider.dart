import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/firebase_roulette_datasource.dart';
import '../../data/repositories/roulette_repository_impl.dart';
import '../../domain/entities/roulette_option.dart';
import '../../domain/repositories/roulette_repository.dart';

/// Roulette data source provider (Firebase)
final rouletteDataSourceProvider = Provider<FirebaseRouletteDataSource>((ref) {
  return FirebaseRouletteDataSource();
});

/// Roulette repository provider
final rouletteRepositoryProvider = Provider<IRouletteRepository>((ref) {
  return RouletteRepositoryImpl(
    dataSource: ref.watch(rouletteDataSourceProvider),
  );
});

/// Provider for loading all roulette options
final loadRouletteOptionsProvider = FutureProvider<List<RouletteOption>>((
  ref,
) async {
  final repository = ref.watch(rouletteRepositoryProvider);
  return repository.getOptions();
});

/// Provider for loading roulette categories
final loadRouletteCategoriesProvider = FutureProvider<List<String>>((
  ref,
) async {
  final repository = ref.watch(rouletteRepositoryProvider);
  return repository.getCategories();
});

/// State notifier for managing local roulette options
class RouletteOptionsNotifier extends StateNotifier<List<RouletteOption>> {
  RouletteOptionsNotifier() : super([]);

  void setOptions(List<RouletteOption> options) {
    state = options;
  }

  void addOption(RouletteOption option) {
    state = [...state, option];
  }

  void removeOption(String id) {
    state = state.where((option) => option.id != id).toList();
  }

  void updateOption(RouletteOption option) {
    state = state.map((o) => o.id == option.id ? option : o).toList();
  }

  void clearOptions() {
    state = [];
  }
}

/// Provider for roulette options state
final rouletteOptionsStateProvider =
    StateNotifierProvider<RouletteOptionsNotifier, List<RouletteOption>>((ref) {
      return RouletteOptionsNotifier();
    });
