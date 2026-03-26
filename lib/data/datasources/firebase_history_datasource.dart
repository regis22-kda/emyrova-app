import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore_constants.dart';
import '../../../core/error/failure.dart';
import '../../domain/entities/game_history.dart';
import '../models/game_history_model.dart';
import 'history_datasource.dart';

/// Firebase implementation of [HistoryDataSource]
class FirebaseHistoryDataSource implements HistoryDataSource {
  final FirebaseFirestore _firestore;

  FirebaseHistoryDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get the history collection reference for a user
  CollectionReference _getHistoryCollection(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection(FirestoreConstants.historyCollection);
  }

  @override
  Future<List<GameHistory>> getAllHistory(String uid) async {
    try {
      final querySnapshot = await _getHistoryCollection(uid)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => GameHistoryModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>).toEntity())
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
  Future<GameHistory?> getHistoryById(String uid, String id) async {
    try {
      final docSnapshot = await _getHistoryCollection(uid).doc(id).get();

      if (!docSnapshot.exists) {
        return null;
      }

      return GameHistoryModel.fromFirestore(docSnapshot.id, docSnapshot.data() as Map<String, dynamic>).toEntity();
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
  Future<void> saveHistory(String uid, GameHistory history) async {
    try {
      final model = GameHistoryModel.fromEntity(history);
      
      await _getHistoryCollection(uid).doc(history.id).set(model.toFirestore());
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        throw const NetworkFailure('Firebase service unavailable');
      }
      throw ServerFailure('Failed to save history: ${e.message}');
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure('Unexpected error saving history: $e');
    }
  }

  @override
  Future<void> deleteHistory(String uid, String id) async {
    try {
      await _getHistoryCollection(uid).doc(id).delete();
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        throw const NetworkFailure('Firebase service unavailable');
      }
      if (e.code == 'not-found') {
        throw const NotFoundFailure('History entry not found');
      }
      throw ServerFailure('Failed to delete history: ${e.message}');
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure('Unexpected error deleting history: $e');
    }
  }

  @override
  Future<GameHistory?> getLatestHistory(String uid) async {
    try {
      final querySnapshot = await _getHistoryCollection(uid)
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      final doc = querySnapshot.docs.first;
      return GameHistoryModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>).toEntity();
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
