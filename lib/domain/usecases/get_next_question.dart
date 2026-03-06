import '../entities/question.dart';
import '../repositories/content_repository.dart';

/// Use case for getting the next random question
class GetNextQuestion {
  final IContentRepository repository;

  GetNextQuestion(this.repository);

  Future<Question> call() async {
    try {
      return await repository.getRandomQuestion();
    } catch (e) {
      throw const ContentNotFoundFailure('Failed to get random question');
    }
  }
}

/// Use case for getting questions by category
class GetQuestionsByCategory {
  final IContentRepository repository;

  GetQuestionsByCategory(this.repository);

  Future<List<Question>> call(String category) async {
    try {
      return await repository.getQuestionsByCategory(category);
    } catch (e) {
      throw const ContentNotFoundFailure('Failed to get questions by category');
    }
  }
}
