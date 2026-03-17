/// Base class for all failures in the application
abstract class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => 'Failure: $message';
}

/// Indicates that a requested resource was not found
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

/// Indicates a network connectivity issue
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network connection failed']);
}

/// Indicates a server-side or general error
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Indicates an authentication failure
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}
