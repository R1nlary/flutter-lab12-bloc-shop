import 'package:flutter/material.dart';
import 'package:flutter_lab12_bloc_shop/cart/cart_bloc.dart';
import 'package:flutter_lab12_bloc_shop/models/cart_item.dart';
import 'package:flutter_lab12_bloc_shop/models/money.dart';
import 'package:flutter_lab12_bloc_shop/models/product.dart';
import 'package:flutter_test/flutter_test.dart';

const mouse = Product(id: 'm', title: 'Mouse', price: 1000, icon: Icons.mouse);
const hub = Product(id: 'h', title: 'Hub', price: 2500, icon: Icons.usb);

void main() {
  late CartBloc bloc;

  setUp(() => bloc = CartBloc());
  tearDown(() => bloc.close());

  Future<CartState> next() => bloc.stream.first;

  test('starts empty', () {
    expect(bloc.state.items, isEmpty);
    expect(bloc.state.count, 0);
    expect(bloc.state.totalPrice, 0);
  });

  test('AddProductEvent adds a line', () async {
    bloc.add(const AddProductEvent(mouse));
    final state = await next();
    expect(state.items, [const CartItem(product: mouse)]);
    expect(state.count, 1);
    expect(state.totalPrice, 1000);
  });

  test('adding the same product twice increases quantity', () async {
    bloc
      ..add(const AddProductEvent(mouse))
      ..add(const AddProductEvent(mouse))
      ..add(const AddProductEvent(hub));
    final state = await bloc.stream.elementAt(2);
    expect(state.items.length, 2);
    expect(state.quantityOf('m'), 2);
    expect(state.count, 3);
    expect(state.totalPrice, 1000 * 2 + 2500);
  });

  test('RemoveProductEvent removes the whole line', () async {
    bloc
      ..add(const AddProductEvent(mouse))
      ..add(const AddProductEvent(mouse))
      ..add(const AddProductEvent(hub))
      ..add(const RemoveProductEvent('m'));
    final state = await bloc.stream.elementAt(3);
    expect(state.items, [const CartItem(product: hub)]);
    expect(state.count, 1);
    expect(state.totalPrice, 2500);
  });

  test('removing an unknown id emits nothing new', () async {
    bloc.add(const AddProductEvent(mouse));
    await next();
    final emitted = <CartState>[];
    final sub = bloc.stream.listen(emitted.add);
    bloc.add(const RemoveProductEvent('missing'));
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    expect(emitted, isEmpty, reason: 'equal state is skipped by emit()');
  });

  test('ClearCartEvent empties the cart', () async {
    bloc
      ..add(const AddProductEvent(mouse))
      ..add(const AddProductEvent(hub))
      ..add(const ClearCartEvent());
    final state = await bloc.stream.elementAt(2);
    expect(state, CartState());
    expect(state.count, 0);
    expect(state.totalPrice, 0);
  });

  test('state list cannot be mutated from outside', () async {
    bloc.add(const AddProductEvent(mouse));
    final state = await next();
    expect(
      () => state.items.add(const CartItem(product: hub)),
      throwsUnsupportedError,
    );
  });

  test('previous state is not changed by a new event', () async {
    bloc.add(const AddProductEvent(mouse));
    final first = await next();
    bloc.add(const AddProductEvent(mouse));
    await next();
    expect(first.quantityOf('m'), 1);
  });

  test('events compare by value', () {
    expect(const RemoveProductEvent('a'), const RemoveProductEvent('a'));
    expect(const RemoveProductEvent('a'), isNot(const RemoveProductEvent('b')));
    expect(const AddProductEvent(mouse), isNot(const AddProductEvent(hub)));
    expect(const AddProductEvent(mouse), const AddProductEvent(mouse));
    expect(const ClearCartEvent(), const ClearCartEvent());
  });

  test('formatTenge groups thousands', () {
    expect(formatTenge(0), '0 ₸');
    expect(formatTenge(999), '999 ₸');
    expect(formatTenge(12500), '12 500 ₸');
    expect(formatTenge(1234567), '1 234 567 ₸');
  });
}
