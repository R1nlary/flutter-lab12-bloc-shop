import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth/auth_cubit.dart';
import 'cart/cart_bloc.dart';
import 'screens/login_screen.dart';

void main() => runApp(const ShopApp());

class ShopApp extends StatelessWidget {
  const ShopApp({super.key, this.authDelay = const Duration(seconds: 2)});

  /// Simulated login latency (tests shorten it).
  final Duration authDelay;

  @override
  Widget build(BuildContext context) {
    // Both blocs live above MaterialApp, so every route (Login, Catalog,
    // Cart) reads the same instances. BlocProvider closes them on dispose.
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(delay: authDelay)),
        BlocProvider(create: (_) => CartBloc()),
      ],
      child: MaterialApp(
        title: 'BLoC Shop',
        debugShowCheckedModeBanner: false,
        theme: _theme(Brightness.light),
        darkTheme: _theme(Brightness.dark),
        home: const LoginScreen(),
      ),
    );
  }

  ThemeData _theme(Brightness brightness) => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF3949AB),
      brightness: brightness,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
  );
}
