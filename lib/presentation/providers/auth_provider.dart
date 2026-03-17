import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Represents the authentication state of the app
sealed class AuthState extends Equatable {
  const AuthState();

  /// User is authenticated with a user ID
  const factory AuthState.authenticated(String uid) = Authenticated;

  /// Authentication failed with an error message
  const factory AuthState.error(String message) = AuthError;

  @override
  List<Object?> get props => [];
}

/// User is authenticated
class Authenticated extends AuthState {
  final String uid;

  const Authenticated(this.uid);

  @override
  List<Object?> get props => [uid];
}

/// Authentication failed
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State notifier for managing auth state
class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(const AuthError('Not initialized'));

  void setAuthenticated(String uid) {
    state = Authenticated(uid);
  }

  void setError(String message) {
    state = AuthError(message);
  }
}

/// Provider for the auth state notifier
final authStateNotifierProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier();
});

/// Provider to get the current user ID
final currentUserIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateNotifierProvider);
  if (authState is Authenticated) {
    return authState.uid;
  }
  return null;
});

/// Provider to check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateNotifierProvider) is Authenticated;
});
