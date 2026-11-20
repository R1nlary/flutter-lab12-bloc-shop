import 'package:flutter/material.dart';
import 'package:flutter_lab12_bloc_shop/main.dart';
import 'package:flutter_lab12_bloc_shop/screens/cart_screen.dart';
import 'package:flutter_lab12_bloc_shop/screens/catalog_screen.dart';
import 'package:flutter_lab12_bloc_shop/screens/login_screen.dart';
import 'package:flutter_test/flutter_test.dart';

const delay = Duration(seconds: 2);

Future<void> login(WidgetTester tester, String email, String password) async {
  await tester.enterText(find.byKey(const Key('emailField')), email);
  await tester.enterText(find.byKey(const Key('passwordField')), password);
  await tester.tap(find.byKey(const Key('loginButton')));
  await tester.pump();
}

String badgeText(WidgetTester tester) {
  final badge = tester.widget<Badge>(find.byKey(const Key('cartBadge')));
  if (badge.isLabelVisible == false) return '';
  return (badge.label as Text).data!;
}

void main() {
  testWidgets('spinner while loading, red floating SnackBar on error', (
    tester,
  ) async {
    await tester.pumpWidget(const ShopApp());
    await login(tester, 'student@narxoz.kz', 'wrong');

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byKey(const Key('loginButton')), findsNothing);

    await tester.pump(delay);
    await tester.pump(); // snack bar animation starts

    final snack = tester.widget<SnackBar>(find.byType(SnackBar));
    expect((snack.content as Text).data, 'Invalid email or password.');
    expect(snack.behavior, SnackBarBehavior.floating);
    expect(snack.backgroundColor, Colors.red.shade700);
    expect(find.byKey(const Key('loginButton')), findsOneWidget);
    expect(find.byType(LoginScreen), findsOneWidget);
  });

  testWidgets('full flow: login, add to cart, badge, remove, clear', (
    tester,
  ) async {
    await tester.pumpWidget(const ShopApp());
    await login(tester, 'student@narxoz.kz', '123456');
    await tester.pump(delay);
    await tester.pumpAndSettle();

    expect(find.byType(CatalogScreen), findsOneWidget);
    expect(
      find.byType(LoginScreen),
      findsNothing,
      reason: 'pushReplacement: no way back to login',
    );
    expect(find.text('Hi, Narxoz Student'), findsOneWidget);
    expect(badgeText(tester), '');

    await tester.tap(find.byKey(const Key('add_p1'))); // 24 990
    await tester.tap(find.byKey(const Key('add_p1')));
    await tester.tap(find.byKey(const Key('add_p3'))); // 12 900
    await tester.pump();
    expect(badgeText(tester), '3');
    expect(find.text('24 990 ₸ · in cart: 2'), findsOneWidget);

    await tester.tap(find.byKey(const Key('cartButton')));
    await tester.pumpAndSettle();
    expect(find.byType(CartScreen), findsOneWidget);
    expect(find.text('Cart (3)'), findsOneWidget);
    expect(find.text('62 880 ₸'), findsOneWidget); // 2*24990 + 12900

    await tester.tap(find.byKey(const Key('remove_p1')));
    await tester.pump();
    expect(find.text('Cart (1)'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const Key('cartTotal'))).data,
      '12 900 ₸',
    );

    // Back on the catalog the badge already shows the new count.
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(badgeText(tester), '1');

    await tester.tap(find.byKey(const Key('cartButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('clearAllButton')));
    await tester.pump();
    expect(find.text('Your cart is empty'), findsOneWidget);
    expect(tester.widget<Text>(find.byKey(const Key('cartTotal'))).data, '0 ₸');

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(badgeText(tester), '');
  });

  testWidgets('logout clears the cart and returns to login', (tester) async {
    await tester.pumpWidget(const ShopApp());
    await login(tester, 'student@narxoz.kz', '123456');
    await tester.pump(delay);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('add_p2')));
    await tester.pump();
    expect(badgeText(tester), '1');

    await tester.tap(find.byTooltip('Logout'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);

    await login(tester, 'student@narxoz.kz', '123456');
    await tester.pump(delay);
    await tester.pumpAndSettle();
    expect(badgeText(tester), '');
  });
}
