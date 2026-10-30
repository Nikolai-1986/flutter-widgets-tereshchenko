import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_widgets_app/models/product.dart';
import 'package:mobile_widgets_app/models/user.dart';
import 'package:mobile_widgets_app/utils/app_state.dart';
import 'package:mobile_widgets_app/utils/constants.dart';

const _p1 = Product(id: '1', title: 'A', description: 'a', price: 10);
const _p2 = Product(id: '2', title: 'B', description: 'b', price: 20);

void main() {
  group('AppState Tests', () {
    test('toggleFavorite adds then removes', () {
      final state = AppState();
      state.toggleFavorite(_p1);
      expect(state.isFavorite(_p1), isTrue);
      state.toggleFavorite(_p1);
      expect(state.isFavorite(_p1), isFalse);
    });

    test('favoriteProducts is unmodifiable', () {
      final state = AppState()..toggleFavorite(_p1);
      expect(() => state.favoriteProducts.add(_p2), throwsUnsupportedError);
    });

    test('addToCart counts items', () {
      final state = AppState();
      expect(state.addToCart(_p1), isTrue);
      expect(state.addToCart(_p1), isTrue);
      expect(state.addToCart(_p2), isTrue);
      expect(state.cartItemsCount, 3);
    });

    test('cart limit is enforced', () {
      final state = AppState();
      for (var i = 0; i < AppConstants.maxCartItems; i++) {
        state.addToCart(_p1);
      }
      expect(state.addToCart(_p1), isFalse);
      expect(state.cartItemsCount, AppConstants.maxCartItems);
      expect(state.lastError, isNotNull);
    });

    test('updateUserName validates input', () {
      final state = AppState(
        user: const User(id: 'u', name: 'Old', email: 'e@e.com'),
      );
      expect(state.updateUserName(' '), isNotNull);
      expect(state.currentUser!.name, 'Old');
      expect(state.updateUserName('New Name'), isNull);
      expect(state.currentUser!.name, 'New Name');
    });

    test('notifies listeners on change', () {
      final state = AppState();
      var calls = 0;
      state.addListener(() => calls++);
      state.toggleFavorite(_p1);
      state.addToCart(_p1);
      expect(calls, 2);
    });
  });
}
