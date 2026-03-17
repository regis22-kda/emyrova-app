import '../../domain/entities/question.dart';

/// Abstract interface for question data sources
abstract class QuestionDataSource {
  /// Gets all active questions, optionally filtered by category
  Future<List<Question>> getQuestions({String? category});

  /// Gets a random active question
  Future<Question> getRandomQuestion();

  /// Gets a question by its ID
  Future<Question?> getQuestionById(String id);
}
