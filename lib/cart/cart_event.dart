import 'package:equatable/equatable.dart';

import '../models/product.dart';

/// Everything that can happen to the cart. The UI only dispatches these;
/// it never changes the cart directly.
sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

final class AddProductEvent extends CartEvent {
  const AddProductEvent(this.product);

  final Product product;

  @override
  List<Object?> get props => [product];
}

/// Removes the whole line for this product, whatever its quantity.
final class RemoveProductEvent extends CartEvent {
  const RemoveProductEvent(this.productId);

  final String productId;

  @override
  List<Object?> get props => [productId];
}

final class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}
