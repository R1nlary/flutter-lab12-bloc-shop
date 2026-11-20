import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth/auth_cubit.dart';
import '../cart/cart_bloc.dart';
import '../data/catalog.dart';
import '../models/money.dart';
import '../models/product.dart';
import '../widgets/cart_badge_button.dart';
import 'login_screen.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  void _logout(BuildContext context) {
    context.read<CartBloc>().add(const ClearCartEvent());
    context.read<AuthCubit>().logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthCubit>().state;
    final username = auth is AuthSuccess ? auth.username : 'Guest';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Catalog'),
            Text('Hi, $username', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        actions: [
          const CartBadgeButton(),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: catalogProducts.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) =>
            _ProductTile(product: catalogProducts[index]),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: colors.primaryContainer,
        foregroundColor: colors.onPrimaryContainer,
        child: Icon(product.icon),
      ),
      title: Text(product.title),
      subtitle: BlocBuilder<CartBloc, CartState>(
        // Rebuild only when this product's quantity changes.
        buildWhen: (previous, current) =>
            previous.quantityOf(product.id) != current.quantityOf(product.id),
        builder: (context, state) {
          final inCart = state.quantityOf(product.id);
          return Text(
            inCart == 0
                ? formatTenge(product.price)
                : '${formatTenge(product.price)} · in cart: $inCart',
          );
        },
      ),
      trailing: FilledButton.tonalIcon(
        key: Key('add_${product.id}'),
        onPressed: () => context.read<CartBloc>().add(AddProductEvent(product)),
        icon: const Icon(Icons.add_shopping_cart, size: 18),
        label: const Text('Add'),
      ),
    );
  }
}
