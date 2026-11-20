# Flutter Lab 12 — Enterprise Auth & Shopping Cart with BLoC

Three-screen app built with `flutter_bloc: ^8.1.3` and `equatable: ^2.0.5`.

**Demo login:** `student@narxoz.kz` / `123456`

## Screens

1. **Login** — email and password fields wrapped in `BlocConsumer<AuthCubit, AuthState>`.
   - `listener` (one-time side effects): a red floating `SnackBar` on `AuthError`,
     `pushReplacement` to the catalog on `AuthSuccess`.
   - `builder` (UI only): the Login button turns into a `CircularProgressIndicator` while `AuthLoading`.
2. **Catalog** — eight products, each with an **Add** button that dispatches `AddProductEvent`.
   The AppBar cart icon shows a live `Badge` counter through `BlocBuilder<CartBloc, CartState>`.
3. **Cart** — lines with quantity and line total, a delete button per line (`RemoveProductEvent`),
   the total price and a **Clear All** button (`ClearCartEvent`).

## State

```
lib/
  auth/auth_state.dart   AuthInitial | AuthLoading | AuthSuccess(username, email) | AuthError(message)
  auth/auth_cubit.dart   login(email, password), logout()
  cart/cart_event.dart   AddProductEvent(Product) | RemoveProductEvent(productId) | ClearCartEvent()
  cart/cart_state.dart   CartState(items, totalPrice, count)
  cart/cart_bloc.dart    on<AddProductEvent>, on<RemoveProductEvent>, on<ClearCartEvent>
```

- **AuthCubit**: `login()` emits `AuthLoading`, waits 2 s (simulated server), then emits
  `AuthSuccess` or `AuthError`. The email is trimmed and case-insensitive; empty fields get their own
  message; a second tap while loading is ignored; nothing is emitted if the cubit was closed during the wait.
- **CartBloc**: adding a product already in the cart increases its quantity. `count` is the number of
  units, `totalPrice` is in whole tenge (`int`, no floating point drift). Both are computed in the
  `CartState` constructor from `items`, so they can never disagree with the list, and `items` is
  unmodifiable.
- All states and events extend `Equatable`, so equal states are not re-emitted and widgets do not
  rebuild for nothing.
- `AuthCubit` and `CartBloc` are provided once above `MaterialApp` with `MultiBlocProvider`, so the
  catalog and the cart screen (separate routes) read the same cart.

## Run

```bash
flutter pub get
flutter run
```

```bash
flutter test
```

Tests cover every cubit/bloc transition and the full UI flow: wrong password → spinner → red
SnackBar, login → catalog, badge counter, remove, total, Clear All, logout.
