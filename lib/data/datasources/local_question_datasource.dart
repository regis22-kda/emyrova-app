import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/entities/question.dart';

/// Local data source for reading questions from bundled JSON
class LocalQuestionDataSource {
  final String assetPath;

  const LocalQuestionDataSource({this.assetPath = 'assets/content.json'});

  /// Loads all questions from the JSON asset
  Future<List<Question>> loadQuestions() async {
    try {
      final jsonString = await rootBundle.loadString(assetPath);
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final questionsJson = jsonData['questions'] as List<dynamic>;

      return questionsJson
          .map((q) => Question.fromJson(q as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load questions from $assetPath: $e');
    }
  }

  /// Gets a random question
  Future<Question> getRandomQuestion() async {
    final questions = await loadQuestions();
    if (questions.isEmpty) {
      throw Exception('No questions available');
    }

    final index = DateTime.now().millisecondsSinceEpoch % questions.length;
    return questions[index];
  }

  /// Gets questions by category
  Future<List<Question>> getQuestionsByCategory(String category) async {
    final questions = await loadQuestions();
    return questions
        .where((q) => q.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  /// Gets all categories
  Future<List<String>> getCategories() async {
    final questions = await loadQuestions();
    return questions.map((q) => q.category).toSet().toList();
  }
}
