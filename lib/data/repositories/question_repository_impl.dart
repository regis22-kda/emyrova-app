import '../../domain/entities/question.dart';
import '../../domain/repositories/content_repository.dart';
import '../datasources/question_datasource.dart';

/// Repository implementation using [QuestionDataSource]
class QuestionRepositoryImpl implements IContentRepository {
  final QuestionDataSource _dataSource;

  const QuestionRepositoryImpl({required QuestionDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<Question> getRandomQuestion() async {
    try {
      return await _dataSource.getRandomQuestion();
    } on Failure {
      rethrow;
    } catch (e) {
      throw const UnknownFailure('Failed to get random question');
    }
  }

  @override
  Future<List<Question>> getQuestionsByCategory(String category) async {
    try {
      return await _dataSource.getQuestions(category: category);
    } on Failure {
      rethrow;
    } catch (e) {
      throw UnknownFailure('Failed to get questions for category: $category');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final questions = await _dataSource.getQuestions();
      return questions.map((q) => q.category).toSet().toList();
    } on Failure {
      rethrow;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Question?> getQuestionById(String id) async {
    try {
      return await _dataSource.getQuestionById(id);
    } on Failure {
      rethrow;
    } catch (e) {
      return null;
    }
  }
}
