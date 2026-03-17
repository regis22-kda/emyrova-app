import '../../domain/entities/roulette_option.dart';

/// Abstract interface for roulette data sources
abstract class RouletteDataSource {
  /// Gets all roulette options
  Future<List<RouletteOption>> getOptions();

  /// Gets options by category
  Future<List<RouletteOption>> getOptionsByCategory(String category);

  /// Gets a random option
  Future<RouletteOption?> getRandomOption();

  /// Saves a new option
  Future<void> saveOption(RouletteOption option);

  /// Deletes an option
  Future<void> deleteOption(String id);

  /// Updates an existing option
  Future<void> updateOption(RouletteOption option);

  /// Gets all available categories
  Future<List<String>> getCategories();
}
