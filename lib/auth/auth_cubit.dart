import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

export 'auth_state.dart';

/// Demo accounts: email -> (password, display name).
const Map<String, ({String password, String username})> demoAccounts = {
  'student@narxoz.kz': (password: '123456', username: 'Narxoz Student'),
};

/// Async auth state machine:
/// AuthInitial -> AuthLoading -> AuthSuccess | AuthError.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({this.delay = const Duration(seconds: 2)})
    : super(const AuthInitial());

  /// Simulated network latency. Tests pass a shorter one.
  final Duration delay;

  Future<void> login(String email, String password) async {
    // A second tap while a request is running is ignored.
    if (state is AuthLoading) return;

    emit(const AuthLoading());
    await Future<void>.delayed(delay);
    // The screen may have been closed while we were "waiting for the server".
    if (isClosed) return;

    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.isEmpty || password.isEmpty) {
      emit(const AuthError('Please enter both email and password.'));
      return;
    }

    final account = demoAccounts[normalizedEmail];
    if (account == null || account.password != password) {
      emit(const AuthError('Invalid email or password.'));
      return;
    }

    emit(AuthSuccess(username: account.username, email: normalizedEmail));
  }

  void logout() => emit(const AuthInitial());
}
