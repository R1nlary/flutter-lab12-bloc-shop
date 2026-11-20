import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cart/cart_bloc.dart';
import '../models/money.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text('Cart (${state.count})')),
          body: state.isEmpty
              ? const _EmptyCart()
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: state.items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = state.items[index];
                    return ListTile(
                      leading: Icon(item.product.icon),
                      title: Text(item.product.title),
                      subtitle: Text(
                        '${item.quantity} × ${formatTenge(item.product.price)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            formatTenge(item.lineTotal),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          IconButton(
                            key: Key('remove_${item.product.id}'),
                            tooltip: 'Remove',
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => context.read<CartBloc>().add(
                              RemoveProductEvent(item.product.id),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          formatTenge(state.totalPrice),
                          key: const Key('cartTotal'),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton.icon(
                    key: const Key('clearAllButton'),
                    onPressed: state.isEmpty
                        ? null
                        : () => context.read<CartBloc>().add(
                            const ClearCartEvent(),
                          ),
                    icon: const Icon(Icons.remove_shopping_cart_outlined),
                    label: const Text('Clear All'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 12),
          const Text('Your cart is empty'),
        ],
      ),
    );
  }
}
