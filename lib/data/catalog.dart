import 'package:flutter/material.dart';

import '../models/product.dart';

/// Static catalog: the lab is about state management, not networking.
const List<Product> catalogProducts = [
  Product(
    id: 'p1',
    title: 'Wireless Headphones',
    price: 24990,
    icon: Icons.headphones,
  ),
  Product(
    id: 'p2',
    title: 'Mechanical Keyboard',
    price: 32500,
    icon: Icons.keyboard,
  ),
  Product(id: 'p3', title: 'Gaming Mouse', price: 12900, icon: Icons.mouse),
  Product(id: 'p4', title: 'USB-C Hub', price: 9990, icon: Icons.usb),
  Product(id: 'p5', title: 'Smart Watch', price: 45000, icon: Icons.watch),
  Product(
    id: 'p6',
    title: 'Bluetooth Speaker',
    price: 18750,
    icon: Icons.speaker,
  ),
  Product(
    id: 'p7',
    title: 'Webcam Full HD',
    price: 15400,
    icon: Icons.videocam,
  ),
  Product(
    id: 'p8',
    title: 'Power Bank 20000 mAh',
    price: 11200,
    icon: Icons.battery_charging_full,
  ),
];
