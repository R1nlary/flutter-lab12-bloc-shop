import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// A catalog item. Prices are whole tenge (int), so totals never pick up
/// floating point noise like 0.1 + 0.2.
class Product extends Equatable {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.icon,
  });

  final String id;
  final String title;
  final int price;
  final IconData icon;

  @override
  List<Object?> get props => [id, title, price, icon];
}
