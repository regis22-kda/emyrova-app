import 'package:firebase_auth/firebase_auth.dart';

import '../error/failure.dart';

/// Service for handling user authentication
class AuthService {
  final FirebaseAuth _auth;

  AuthService({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  /// Returns the current user ID if already signed in,
  /// otherwise signs in anonymously and returns the new user ID.
  Future<String> getOrCreateUser() async {
    try {
      // Check if user is already signed in
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
      throw ServerFailure('Unexpected error during authentication: $e');
    }
  }

  /// Gets the current user ID without signing in
  /// Returns null if not signed in
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  /// Signs out the current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure('Unexpected error during sign out: $e');
    }
  }

  /// Handles Firebase authentication exceptions
  Failure _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'operation-not-allowed':
        return const ServerFailure('Anonymous auth is not enabled');
      case 'network-request-failed':
        return const NetworkFailure('Network error during authentication');
      default:
        return ServerFailure('Authentication error: ${e.message}');
    }
  }
}
