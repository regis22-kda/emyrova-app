import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/constants/firestore_constants.dart';
import '../../../core/error/failure.dart';
import '../../domain/entities/room.dart';
import '../models/room_model.dart';
import 'room_datasource.dart';

/// Firebase implementation of [RoomDataSource]
class FirebaseRoomDataSource implements RoomDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  /// Characters excluded from room codes to avoid confusion
  /// Excludes: 0, O, I, 1
  static const String _allowedChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  FirebaseRoomDataSource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<String> signInAnonymously() async {
    try {
      // Check if already signed in
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        return currentUser.uid;
      }

      // Sign in anonymously
      final credential = await _auth.signInAnonymously();
      final uid = credential.user?.uid;

      if (uid == null) {
        throw const AuthFailure('Failed to sign in anonymously');
      }

      return uid;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure('Unexpected error during sign in: $e');
    }
  }

  @override
  Future<String> createRoom(String partnerAUid) async {
    try {
      // Generate unique room code
      final roomCode = _generateRoomCode();

      // Create room document
      final roomData = {
        'room_code': roomCode,
        'partner_a_uid': partnerAUid,
        'partner_b_uid': null,
        'answers': {
          'partner_a': null,
          'partner_b': null,
        },
        'created_at': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection(FirestoreConstants.roomsCollection)
          .doc(roomCode)
          .set(roomData);

      return roomCode;
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        throw const NetworkFailure('Firebase service unavailable');
      }
      throw ServerFailure('Failed to create room: ${e.message}');
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure('Unexpected error creating room: $e');
    }
  }

  @override
  Future<Room?> joinRoom(String roomCode, String uid) async {
    try {
      final roomRef = _firestore
          .collection(FirestoreConstants.roomsCollection)
          .doc(roomCode);

      final roomDoc = await roomRef.get();

      if (!roomDoc.exists) {
        throw const NotFoundFailure('Room not found');
      }

      // Update partner_b_uid
      await roomRef.update({
        'partner_b_uid': uid,
      });

      final updatedDoc = await roomRef.get();
      return RoomModel.fromFirestore(updatedDoc).toEntity();
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        throw const NetworkFailure('Firebase service unavailable');
      }
      if (e.code == 'not-found') {
        throw const NotFoundFailure('Room not found');
      }
      throw ServerFailure('Failed to join room: ${e.message}');
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure('Unexpected error joining room: $e');
    }
  }

  @override
  Future<Room?> getRoom(String roomCode) async {
    try {
      final docSnapshot = await _firestore
          .collection(FirestoreConstants.roomsCollection)
          .doc(roomCode)
          .get();

      if (!docSnapshot.exists) {
        return null;
      }

      return RoomModel.fromFirestore(docSnapshot).toEntity();
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        throw const NetworkFailure('Firebase service unavailable');
      }
      throw ServerFailure('Failed to get room: ${e.message}');
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure('Unexpected error getting room: $e');
    }
  }

  @override
  Future<void> submitAnswer(
    String roomCode,
    bool isPartnerA,
    String answer,
  ) async {
    try {
      final answerField = isPartnerA
          ? FirestoreConstants.fieldPartnerAAnswer
          : FirestoreConstants.fieldPartnerBAnswer;

      await _firestore
          .collection(FirestoreConstants.roomsCollection)
          .doc(roomCode)
          .update({
        'answers.$answerField': answer,
      });
    } on FirebaseException catch (e) {
      if (e.code == 'unavailable') {
        throw const NetworkFailure('Firebase service unavailable');
      }
      if (e.code == 'not-found') {
        throw const NotFoundFailure('Room not found');
      }
      throw ServerFailure('Failed to submit answer: ${e.message}');
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure('Unexpected error submitting answer: $e');
    }
  }

  @override
  Stream<Room?> watchRoom(String roomCode) {
    try {
      return _firestore
          .collection(FirestoreConstants.roomsCollection)
          .doc(roomCode)
          .snapshots()
          .map((docSnapshot) {
        if (!docSnapshot.exists) {
          return null;
        }
        return RoomModel.fromFirestore(docSnapshot).toEntity();
      });
    } on FirebaseException catch (e) {
      throw ServerFailure('Failed to watch room: ${e.message}');
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure('Unexpected error watching room: $e');
    }
  }

  /// Generates a unique 5-character alphanumeric room code
  /// Excludes confusable characters: 0, O, I, 1
  String _generateRoomCode() {
    final random = Random.secure();
    final codeChars = <String>[];

    for (var i = 0; i < 5; i++) {
      final index = random.nextInt(_allowedChars.length);
      codeChars.add(_allowedChars[index]);
    }

    return codeChars.join();
  }

  /// Handles Firebase authentication exceptions
  Failure _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'operation-not-allowed':
        return const ServerFailure('Anonymous auth is not enabled');
      case 'network-request-failed':
        return const NetworkFailure('Network error during sign in');
      default:
        return ServerFailure('Authentication error: ${e.message}');
    }
  }
}
