import '../entities/roulette_option.dart';
import '../entities/history_entry.dart';

/// Abstract repository for roulette operations
abstract class IRouletteRepository {
  /// Gets all available roulette options
  Future<List<RouletteOption>> getOptions();

  /// Gets options by preset category
  Future<List<RouletteOption>> getOptionsByPreset(String preset);

  /// Saves a custom option
  Future<void> saveOption(RouletteOption option);

  /// Deletes an option
  Future<void> deleteOption(String id);

  /// Saves the roulette result to history
  Future<void> saveResult(HistoryEntry result);

  /// Gets the winning option (random selection)
  Future<RouletteOption> selectWinner(List<RouletteOption> options);
}
