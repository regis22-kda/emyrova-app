import '../entities/question.dart';

/// Failure types for error handling
abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ContentNotFoundFailure extends Failure {
  const ContentNotFoundFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}

/// Abstract repository for content operations
abstract class IContentRepository {
  /// Gets a random question from the repository
  Future<Question> getRandomQuestion();

  /// Gets questions by category
  Future<List<Question>> getQuestionsByCategory(String category);

  /// Gets all available categories
  Future<List<String>> getCategories();

  /// Gets a specific question by ID
  Future<Question?> getQuestionById(String id);
}
