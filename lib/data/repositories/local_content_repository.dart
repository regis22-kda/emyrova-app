import '../../domain/entities/question.dart';
import '../../domain/repositories/content_repository.dart';
import '../datasources/local_question_datasource.dart';

/// Local implementation of the content repository
class LocalContentRepository implements IContentRepository {
  final LocalQuestionDataSource dataSource;

  const LocalContentRepository({required this.dataSource});

  @override
  Future<Question> getRandomQuestion() async {
    try {
      return await dataSource.getRandomQuestion();
    } catch (e) {
      throw const ContentNotFoundFailure(
        'No questions available in local storage',
      );
    }
  }

  @override
  Future<List<Question>> getQuestionsByCategory(String category) async {
    try {
      return await dataSource.getQuestionsByCategory(category);
    } catch (e) {
      throw ContentNotFoundFailure(
        'No questions found for category: $category',
      );
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      return await dataSource.getCategories();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Question?> getQuestionById(String id) async {
    try {
      final questions = await dataSource.loadQuestions();
      return questions.firstWhere((q) => q.id == id);
    } catch (e) {
      return null;
    }
  }
}
