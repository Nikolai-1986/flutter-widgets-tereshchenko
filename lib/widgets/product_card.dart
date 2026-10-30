import 'package:flutter/material.dart';

import '../models/product.dart';
import 'bounce_tap.dart';
import 'custom_button.dart';
import 'shimmer_box.dart';

/// Інтерактивна картка товару:
///  - свайп вправо — додати в обране, вліво — прибрати;
///  - анімація натискання кнопок (BounceTap);
///  - збільшення фото при тапі;
///  - shimmer-ефект під час завантаження зображення.
class ProductCard extends StatefulWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.onAddToCart,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _zoomed = false;

  /// Картка не прибирається зі списку: повертаємо false,
  /// а потрібну дію виконуємо за напрямком свайпу.
  Future<bool> _onSwipe(DismissDirection direction) async {
    if (direction == DismissDirection.startToEnd && !widget.isFavorite) {
      widget.onFavoriteToggle?.call();
    } else if (direction == DismissDirection.endToStart && widget.isFavorite) {
      widget.onFavoriteToggle?.call();
    }
    return false;
  }

  Widget _swipeBackground({
    required Alignment alignment,
    required Color color,
    required IconData icon,
    required String label,
  }) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: color,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _image(BuildContext context) {
    final url = widget.product.imageUrl;
    final placeholder = Container(
      color: Colors.black12,
      child: const Center(child: Icon(Icons.image_not_supported_outlined)),
    );
    if (url == null) return placeholder;
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : const ShimmerBox(),
      errorBuilder: (context, error, stack) => placeholder,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = widget.product;

    return Dismissible(
      key: ValueKey('dismiss_${product.id}'),
      direction: DismissDirection.horizontal,
      confirmDismiss: _onSwipe,
      background: _swipeBackground(
        alignment: Alignment.centerLeft,
        color: Colors.green.shade600,
        icon: Icons.favorite,
        label: 'В обране',
      ),
      secondaryBackground: _swipeBackground(
        alignment: Alignment.centerRight,
        color: Colors.red.shade400,
        icon: Icons.heart_broken,
        label: 'Прибрати',
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              key: Key('product_image_${product.id}'),
              onTap: () => setState(() => _zoomed = !_zoomed),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRect(
                  child: AnimatedScale(
                    scale: _zoomed ? 1.25 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    child: _image(context),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        product.formattedPrice,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      BounceTap(
                        child: IconButton(
                          key: Key('favorite_button_${product.id}'),
                          tooltip: widget.isFavorite
                              ? 'Прибрати з обраного'
                              : 'Додати в обране',
                          onPressed: widget.onFavoriteToggle,
                          icon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            transitionBuilder: (child, animation) =>
                                ScaleTransition(scale: animation, child: child),
                            child: Icon(
                              widget.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              key: ValueKey(widget.isFavorite),
                              color: widget.isFavorite ? Colors.red : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CustomButton(
                        text: 'У кошик',
                        icon: const Icon(Icons.add_shopping_cart, size: 18),
                        onPressed: widget.onAddToCart,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
