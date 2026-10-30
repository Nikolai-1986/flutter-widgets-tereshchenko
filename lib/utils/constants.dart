import '../models/product.dart';
import '../models/user.dart';

class AppConstants {
  AppConstants._();

  static const String appTitle = 'Flutter Widgets';
  static const double padding = 16;
  static const double radius = 16;
  static const int maxCartItems = 99;
  static const int minNameLength = 2;
  static const Duration shortAnimation = Duration(milliseconds: 200);
}

const User kMockUser = User(
  id: 'u1',
  name: 'Олена Коваленко',
  email: 'olena.kovalenko@example.com',
);

const List<Product> kMockProducts = [
  Product(
    id: 'p1',
    title: 'Бездротові навушники',
    description: 'Накладні, до 30 годин роботи, шумозаглушення.',
    price: 1899,
    imageUrl: 'https://picsum.photos/seed/headphones/640/360',
  ),
  Product(
    id: 'p2',
    title: 'Механічна клавіатура',
    description: 'Compact 75%, hot-swap перемикачі, підсвітка RGB.',
    price: 2499,
    imageUrl: 'https://picsum.photos/seed/keyboard/640/360',
  ),
  Product(
    id: 'p3',
    title: 'Портативна колонка',
    description: 'Захист IP67, 12 годин музики, Bluetooth 5.3.',
    price: 1299,
    imageUrl: 'https://picsum.photos/seed/speaker/640/360',
  ),
  Product(
    id: 'p4',
    title: 'Смарт-годинник',
    description: 'AMOLED-екран, пульсометр, GPS, 7 днів автономності.',
    price: 3299,
    imageUrl: 'https://picsum.photos/seed/watch/640/360',
  ),
];
