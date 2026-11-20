import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cart/cart_bloc.dart';
import '../screens/cart_screen.dart';

/// AppBar cart icon with a live counter. Only this small widget rebuilds
/// when the cart changes, not the whole catalog.
class CartBadgeButton extends StatelessWidget {
  const CartBadgeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (previous, current) => previous.count != current.count,
      builder: (context, state) {
        return IconButton(
          key: const Key('cartButton'),
          tooltip: 'Cart (${state.count})',
          onPressed: () =>
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const CartScreen())),
          icon: Badge(
            key: const Key('cartBadge'),
            isLabelVisible: state.count > 0,
            label: Text('${state.count}'),
            child: const Icon(Icons.shopping_cart_outlined),
          ),
        );
      },
    );
  }
}
