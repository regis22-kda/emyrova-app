import '../entities/game_session.dart';

/// Use case for comparing player answers
class CompareAnswers {
  const CompareAnswers();

  /// Compares answers and returns the result type
  ResultType call(GameSession session) {
    if (session.answers.length < 2) {
      return ResultType.match; // Default if not enough answers
    }

    final answers = session.answers.values.map((a) => a.answer.toLowerCase()).toList();
    final uniqueAnswers = answers.toSet();

    // If all answers are the same, it's a match
    if (uniqueAnswers.length == 1) {
      return ResultType.match;
    }

    // Otherwise it's a contrast
    return ResultType.contrast;
  }
}

/// Result types for answer comparison
enum ResultType {
  match,
  contrast,
}
