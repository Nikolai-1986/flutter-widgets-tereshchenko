import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_widgets_app/models/product.dart';
import 'package:mobile_widgets_app/widgets/product_card.dart';

const _product = Product(
  id: 't1',
  title: 'Тестовий товар',
  description: 'Опис',
  price: 100,
);

Widget wrap(Widget child) => MaterialApp(
      home: Scaffold(
        body: Center(child: SizedBox(width: 420, child: child)),
      ),
    );

void main() {
  group('ProductCard Tests', () {
    testWidgets('renders title and price', (tester) async {
      await tester.pumpWidget(wrap(const ProductCard(product: _product)));
      expect(find.text('Тестовий товар'), findsOneWidget);
      expect(find.text('100 ₴'), findsOneWidget);
    });

    testWidgets('add to cart callback', (tester) async {
      var added = 0;
      await tester.pumpWidget(
        wrap(ProductCard(product: _product, onAddToCart: () => added++)),
      );
      await tester.tap(find.text('У кошик'));
      await tester.pump();
      expect(added, 1);
    });

    testWidgets('favorite button callback', (tester) async {
      var toggles = 0;
      await tester.pumpWidget(
        wrap(ProductCard(product: _product, onFavoriteToggle: () => toggles++)),
      );
      await tester.tap(find.byKey(const Key('favorite_button_t1')));
      await tester.pump();
      expect(toggles, 1);
    });

    testWidgets('swipe right adds to favorites', (tester) async {
      var toggles = 0;
      await tester.pumpWidget(
        wrap(ProductCard(product: _product, onFavoriteToggle: () => toggles++)),
      );
      await tester.drag(find.byType(Dismissible), const Offset(300, 0));
      await tester.pumpAndSettle();
      expect(toggles, 1);
    });

    testWidgets('swipe left removes only if favorite', (tester) async {
      var toggles = 0;
      await tester.pumpWidget(
        wrap(ProductCard(product: _product, onFavoriteToggle: () => toggles++)),
      );
      await tester.drag(find.byType(Dismissible), const Offset(-300, 0));
      await tester.pumpAndSettle();
      expect(toggles, 0);

      await tester.pumpWidget(wrap(ProductCard(
        product: _product,
        isFavorite: true,
        onFavoriteToggle: () => toggles++,
      )));
      await tester.drag(find.byType(Dismissible), const Offset(-300, 0));
      await tester.pumpAndSettle();
      expect(toggles, 1);
    });
  });
}
