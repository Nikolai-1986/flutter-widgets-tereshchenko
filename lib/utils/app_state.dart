import 'package:flutter/material.dart';

import '../models/product.dart';
import '../models/user.dart';
import 'constants.dart';

/// Єдине джерело правди (single source of truth) для стану застосунку.
/// Усі колекції замінюються новими екземплярами (immutable update).
class AppState extends ChangeNotifier {
  AppState({User? user}) : _currentUser = user;

  List<Product> _favoriteProducts = const [];
  User? _currentUser;
  Map<String, int> _cart = const {};
  String? _lastError;

  List<Product> get favoriteProducts => List.unmodifiable(_favoriteProducts);
  User? get currentUser => _currentUser;
  int get cartItemsCount => _cart.values.fold(0, (sum, n) => sum + n);
  String? get lastError => _lastError;

  bool isFavorite(Product product) =>
      _favoriteProducts.any((p) => p.id == product.id);

  /// Додає товар в обране або прибирає його.
  void toggleFavorite(Product product) {
    _favoriteProducts = isFavorite(product)
        ? _favoriteProducts.where((p) => p.id != product.id).toList()
        : [..._favoriteProducts, product];
    _lastError = null;
    notifyListeners();
  }

  /// Повертає false, якщо досягнуто ліміт кошика.
  bool addToCart(Product product) {
    if (cartItemsCount >= AppConstants.maxCartItems) {
      _lastError = 'У кошику не може бути більше '
          '${AppConstants.maxCartItems} товарів';
      notifyListeners();
      return false;
    }
    final current = _cart[product.id] ?? 0;
    _cart = {..._cart, product.id: current + 1};
    _lastError = null;
    notifyListeners();
    return true;
  }

  void clearCart() {
    _cart = const {};
    notifyListeners();
  }

  /// Валідація імені. Повертає текст помилки або null, якщо все гаразд.
  String? updateUserName(String name) {
    final trimmed = name.trim();
    if (_currentUser == null) {
      return 'Користувача не знайдено';
    }
    if (trimmed.length < AppConstants.minNameLength) {
      return 'Імʼя має містити щонайменше '
          '${AppConstants.minNameLength} символи';
    }
    _currentUser = _currentUser!.copyWith(name: trimmed);
    notifyListeners();
    return null;
  }

  void clearError() {
    if (_lastError == null) return;
    _lastError = null;
    notifyListeners();
  }
}

/// Передає AppState вниз по дереву без сторонніх пакетів.
/// Віджет, який викликає AppScope.of(context), автоматично
/// перебудовується при кожному notifyListeners().
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({
    super.key,
    required AppState state,
    required super.child,
  }) : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope не знайдено у дереві віджетів');
    return scope!.notifier!;
  }
}
