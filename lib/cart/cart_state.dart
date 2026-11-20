import 'package:equatable/equatable.dart';

import '../models/cart_item.dart';

/// Immutable cart snapshot. totalPrice and count are computed once from
/// items when the state is built, so they can never disagree with the list.
class CartState extends Equatable {
  CartState({List<CartItem> items = const []})
    : items = List.unmodifiable(items),
      totalPrice = items.fold(0, (sum, item) => sum + item.lineTotal),
      count = items.fold(0, (sum, item) => sum + item.quantity);

  final List<CartItem> items;

  /// Sum of all lines, in tenge.
  final int totalPrice;

  /// Number of units (two of the same product count as 2).
  final int count;

  bool get isEmpty => items.isEmpty;

  /// How many units of [productId] are in the cart (0 if none).
  int quantityOf(String productId) {
    for (final item in items) {
      if (item.product.id == productId) return item.quantity;
    }
    return 0;
  }

  @override
  List<Object?> get props => [items, totalPrice, count];
}
