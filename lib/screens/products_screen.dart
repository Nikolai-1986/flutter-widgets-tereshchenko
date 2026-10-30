import 'package:flutter/material.dart';

import '../utils/app_state.dart';
import '../utils/constants.dart';
import '../widgets/product_card.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Каталог товарів')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Адаптивна сітка: мінімальна ширина картки ~340 px.
          const spacing = 16.0;
          final available = constraints.maxWidth - AppConstants.padding * 2;
          final columns = (available / 340).floor().clamp(1, 4);
          final itemWidth = (available - spacing * (columns - 1)) / columns;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.padding),
            child: Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                for (final product in kMockProducts)
                  SizedBox(
                    width: itemWidth,
                    child: ProductCard(
                      product: product,
                      isFavorite: state.isFavorite(product),
                      onFavoriteToggle: () => state.toggleFavorite(product),
                      onAddToCart: () {
                        final ok = state.addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              ok
                                  ? '«${product.title}» додано в кошик'
                                  : state.lastError ?? 'Помилка',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
