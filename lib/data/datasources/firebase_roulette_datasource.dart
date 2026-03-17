import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore_constants.dart';
import '../../../core/error/failure.dart';
import '../../domain/entities/roulette_option.dart';
import '../models/roulette_option_model.dart';
import 'roulette_datasource.dart';

/// Firebase implementation of [RouletteDataSource]
class FirebaseRouletteDataSource implements RouletteDataSource {
  final FirebaseFirestore _firestore;

  FirebaseRouletteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<RouletteOption>> getOptions() async {
    try {
      final querySnapshot = await _firestore
          .collection(FirestoreConstants.rouletteOptionsCollection)
          .where('is_active', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => RouletteOptionModel.fromFirestore(doc).toEntity())
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
  Future<List<RouletteOption>> getOptionsByCategory(String category) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirestoreConstants.rouletteOptionsCollection)
          .where('is_active', isEqualTo: true)
          .where('preset_category', isEqualTo: category)
          .get();

      return querySnapshot.docs
          .map((doc) => RouletteOptionModel.fromFirestore(doc).toEntity())
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
  Future<RouletteOption?> getRandomOption() async {
    try {
      final querySnapshot = await _firestore
          .collection(FirestoreConstants.rouletteOptionsCollection)
          .where('is_active', isEqualTo: true)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      final randomIndex = DateTime.now().millisecondsSinceEpoch % querySnapshot.docs.length;
      final randomDoc = querySnapshot.docs[randomIndex];

      return RouletteOptionModel.fromFirestore(randomDoc).toEntity();
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
  Future<void> saveOption(RouletteOption option) async {
    try {
      final docRef = _firestore
          .collection(FirestoreConstants.rouletteOptionsCollection)
          .doc(option.id);

      final optionData = RouletteOptionModel.fromEntity(option).toFirestore();

      await docRef.set(optionData);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        throw const NetworkFailure('Firebase service unavailable');
      }
      throw ServerFailure('Failed to save option: ${e.message}');
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure('Unexpected error saving option: $e');
    }
  }

  @override
  Future<void> deleteOption(String id) async {
    try {
      // Soft delete - mark as inactive
      await _firestore
          .collection(FirestoreConstants.rouletteOptionsCollection)
          .doc(id)
          .update({'is_active': false});
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        throw const NetworkFailure('Firebase service unavailable');
      }
      if (e.code == 'not-found') {
        throw const NotFoundFailure('Option not found');
      }
      throw ServerFailure('Failed to delete option: ${e.message}');
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure('Unexpected error deleting option: $e');
    }
  }

  @override
  Future<void> updateOption(RouletteOption option) async {
    try {
      final docRef = _firestore
          .collection(FirestoreConstants.rouletteOptionsCollection)
          .doc(option.id);

      final optionData = RouletteOptionModel.fromEntity(option).toFirestore();

      await docRef.update(optionData);
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        throw const NetworkFailure('Firebase service unavailable');
      }
      if (e.code == 'not-found') {
        throw const NotFoundFailure('Option not found');
      }
      throw ServerFailure('Failed to update option: ${e.message}');
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure('Unexpected error updating option: $e');
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final querySnapshot = await _firestore
          .collection(FirestoreConstants.rouletteOptionsCollection)
          .where('is_active', isEqualTo: true)
          .get();

      final categories = querySnapshot.docs
          .map((doc) => doc.data()['preset_category'] as String?)
          .where((category) => category != null && category.isNotEmpty)
          .cast<String>()
          .toSet()
          .toList();

      return categories;
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
