import 'package:equatable/equatable.dart';

import 'product.dart';

/// One line in the cart: a product and how many of it.
class CartItem extends Equatable {
  const CartItem({required this.product, this.quantity = 1});

  final Product product;
  final int quantity;

  int get lineTotal => product.price * quantity;

  CartItem copyWith({int? quantity}) =>
      CartItem(product: product, quantity: quantity ?? this.quantity);

  @override
  List<Object?> get props => [product, quantity];
}
