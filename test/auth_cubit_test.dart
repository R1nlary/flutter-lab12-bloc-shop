import 'package:flutter_lab12_bloc_shop/auth/auth_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AuthCubit cubit;

  setUp(() => cubit = AuthCubit(delay: const Duration(milliseconds: 10)));
  tearDown(() => cubit.close());

  test('starts in AuthInitial', () {
    expect(cubit.state, const AuthInitial());
  });

  test('valid credentials: Loading then Success', () async {
    final future = expectLater(
      cubit.stream,
      emitsInOrder([
        const AuthLoading(),
        const AuthSuccess(
          username: 'Narxoz Student',
          email: 'student@narxoz.kz',
        ),
      ]),
    );
    await cubit.login('student@narxoz.kz', '123456');
    await future;
  });

  test('email is trimmed and case-insensitive', () async {
    await cubit.login('  Student@Narxoz.KZ ', '123456');
    expect(
      cubit.state,
      const AuthSuccess(username: 'Narxoz Student', email: 'student@narxoz.kz'),
    );
  });

  test('wrong password: Loading then Error', () async {
    final future = expectLater(
      cubit.stream,
      emitsInOrder([
        const AuthLoading(),
        const AuthError('Invalid email or password.'),
      ]),
    );
    await cubit.login('student@narxoz.kz', 'wrong');
    await future;
  });

  test('unknown email gives an error', () async {
    await cubit.login('nobody@narxoz.kz', '123456');
    expect(cubit.state, const AuthError('Invalid email or password.'));
  });

  test('empty fields give a separate message', () async {
    await cubit.login('', '');
    expect(
      cubit.state,
      const AuthError('Please enter both email and password.'),
    );
  });

  test('second login while loading is ignored', () async {
    final states = <AuthState>[];
    final sub = cubit.stream.listen(states.add);
    final first = cubit.login('student@narxoz.kz', '123456');
    final second = cubit.login('student@narxoz.kz', 'wrong');
    await Future.wait([first, second]);
    await Future<void>.delayed(Duration.zero); // let the stream deliver
    await sub.cancel();
    expect(states, [
      const AuthLoading(),
      const AuthSuccess(username: 'Narxoz Student', email: 'student@narxoz.kz'),
    ]);
  });

  test('retry after an error emits Loading again', () async {
    await cubit.login('student@narxoz.kz', 'wrong');
    final future = expectLater(
      cubit.stream,
      emitsInOrder([const AuthLoading(), isA<AuthSuccess>()]),
    );
    await cubit.login('student@narxoz.kz', '123456');
    await future;
  });

  test('closing during the delay does not throw', () async {
    final pending = cubit.login('student@narxoz.kz', '123456');
    await cubit.close();
    await expectLater(pending, completes);
  });

  test('logout returns to AuthInitial', () async {
    await cubit.login('student@narxoz.kz', '123456');
    cubit.logout();
    expect(cubit.state, const AuthInitial());
  });

  test('Equatable: states with the same fields are equal', () {
    expect(const AuthError('x'), const AuthError('x'));
    expect(const AuthError('x'), isNot(const AuthError('y')));
    expect(
      const AuthSuccess(username: 'a', email: 'b'),
      const AuthSuccess(username: 'a', email: 'b'),
    );
    expect(
      const AuthSuccess(username: 'a', email: 'b'),
      isNot(const AuthSuccess(username: 'a', email: 'c')),
    );
    expect(
      const AuthSuccess(username: 'a', email: 'b'),
      isNot(const AuthSuccess(username: 'x', email: 'b')),
    );
    expect(const AuthLoading(), isNot(const AuthInitial()));
  });
}
