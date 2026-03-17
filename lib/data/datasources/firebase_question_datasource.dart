import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore_constants.dart';
import '../../../core/error/failure.dart';
import '../../../domain/entities/question.dart';
import '../models/question_model.dart';
import 'question_datasource.dart';

/// Firebase implementation of [QuestionDataSource]
class FirebaseQuestionDataSource implements QuestionDataSource {
  final FirebaseFirestore _firestore;

  FirebaseQuestionDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Question>> getQuestions({String? category}) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirestoreConstants.questionsCollection)
          .where(FirestoreConstants.fieldIsActive, isEqualTo: true)
          .where(
            FirestoreConstants.fieldCategory,
            isEqualTo: category ?? '',
          )
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw const NotFoundFailure('No questions found');
      }

      return querySnapshot.docs
          .map((doc) => QuestionModel.fromFirestore(doc).toEntity())
          .toList();
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        throw const NetworkFailure('Firebase service unavailable');
      }
      throw ServerFailure('Firebase error: ${e.message}');
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure('Unexpected error: $e');
    }
  }

  @override
  Future<Question> getRandomQuestion() async {
    try {
      final querySnapshot = await _firestore
          .collection(FirestoreConstants.questionsCollection)
          .where(FirestoreConstants.fieldIsActive, isEqualTo: true)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw const NotFoundFailure('No questions available');
      }

      final randomIndex = DateTime.now().millisecondsSinceEpoch % querySnapshot.docs.length;
      final randomDoc = querySnapshot.docs[randomIndex];

      return QuestionModel.fromFirestore(randomDoc).toEntity();
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        throw const NetworkFailure('Firebase service unavailable');
      }
      throw ServerFailure('Firebase error: ${e.message}');
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure('Unexpected error: $e');
    }
  }

  @override
  Future<Question?> getQuestionById(String id) async {
    try {
      final docSnapshot = await _firestore
          .collection(FirestoreConstants.questionsCollection)
          .doc(id)
          .get();

      if (!docSnapshot.exists) {
        return null;
      }

      return QuestionModel.fromFirestore(docSnapshot).toEntity();
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        throw const NetworkFailure('Firebase service unavailable');
      }
      throw ServerFailure('Firebase error: ${e.message}');
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure('Unexpected error: $e');
    }
  }
}
