import '../../core/error/failure.dart';
import '../../domain/entities/roulette_option.dart';
import '../../domain/repositories/roulette_repository.dart';
import '../datasources/roulette_datasource.dart';

/// Repository implementation using [RouletteDataSource]
class RouletteRepositoryImpl implements IRouletteRepository {
  final RouletteDataSource _dataSource;

  const RouletteRepositoryImpl({required RouletteDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<List<RouletteOption>> getOptions() async {
    try {
      return await _dataSource.getOptions();
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure('Failed to get options: $e');
    }
  }

  @override
  Future<List<RouletteOption>> getOptionsByCategory(String category) async {
    try {
      return await _dataSource.getOptionsByCategory(category);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure('Failed to get options by category: $e');
    }
  }

  @override
  Future<RouletteOption?> getRandomOption() async {
    try {
      return await _dataSource.getRandomOption();
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure('Failed to get random option: $e');
    }
  }

  @override
  Future<void> saveOption(RouletteOption option) async {
    try {
      await _dataSource.saveOption(option);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure('Failed to save option: $e');
    }
  }

  @override
  Future<void> deleteOption(String id) async {
    try {
      await _dataSource.deleteOption(id);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure('Failed to delete option: $e');
    }
  }

  @override
  Future<void> updateOption(RouletteOption option) async {
    try {
      await _dataSource.updateOption(option);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ServerFailure('Failed to update option: $e');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      return await _dataSource.getCategories();
    } on Failure {
      rethrow;
    } catch (e) {
      return [];
    }
  }
}
