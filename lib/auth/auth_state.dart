import 'package:equatable/equatable.dart';

/// Every auth state is immutable and compared by value (Equatable),
/// so emitting an equal state twice does not rebuild the UI.
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Nobody is logged in yet (also the state after logout).
final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// A login request is in flight.
final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthSuccess extends AuthState {
  const AuthSuccess({required this.username, required this.email});

  final String username;
  final String email;

  @override
  List<Object?> get props => [username, email];
}

final class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
