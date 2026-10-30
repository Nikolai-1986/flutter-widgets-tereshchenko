/// Імутабельна модель товару.
class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String? imageUrl;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.imageUrl,
  });

  String get formattedPrice => '${price.toStringAsFixed(0)} ₴';

  Product copyWith({
    String? title,
    String? description,
    double? price,
    String? imageUrl,
  }) {
    return Product(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  /// Товари вважаються однаковими, якщо збігається id.
  @override
  bool operator ==(Object other) => other is Product && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
