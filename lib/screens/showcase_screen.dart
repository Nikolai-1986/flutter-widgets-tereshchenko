import 'package:flutter/material.dart';

import '../models/product.dart';
import '../utils/app_state.dart';
import '../utils/constants.dart';
import '../widgets/animated_counter.dart';
import '../widgets/custom_button.dart';
import '../widgets/product_card.dart';
import '../widgets/profile_widget.dart';

/// Демонстраційний екран (Component Library) з інтерактивними
/// контролами для зміни параметрів віджетів.
class ShowcaseScreen extends StatefulWidget {
  const ShowcaseScreen({super.key});

  @override
  State<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen> {
  CustomButtonStyle _style = CustomButtonStyle.primary;
  bool _loading = false;
  bool _disabled = false;
  bool _compact = false;
  double _max = 10;
  bool _favorite = false;

  static const Product _demo = Product(
    id: 'demo',
    title: 'Демо-товар',
    description: 'Свайпніть картку вправо або вліво.',
    price: 999,
  );

  Widget _section(String title, String code, Widget child) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(code, style: const TextStyle(fontFamily: 'monospace')),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AppScope.of(context).currentUser ?? kMockUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Showcase віджетів')),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.padding),
        children: [
          // CustomButton(text: 'Кнопка', style: ..., isLoading: ...)
          _section(
            'CustomButton',
            "CustomButton(text: 'Кнопка', style: $_style)",
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<CustomButtonStyle>(
                  value: _style,
                  items: [
                    for (final s in CustomButtonStyle.values)
                      DropdownMenuItem(value: s, child: Text(s.name)),
                  ],
                  onChanged: (v) => setState(() => _style = v ?? _style),
                ),
                SwitchListTile(
                  title: const Text('isLoading'),
                  value: _loading,
                  onChanged: (v) => setState(() => _loading = v),
                ),
                SwitchListTile(
                  title: const Text('disabled (onPressed = null)'),
                  value: _disabled,
                  onChanged: (v) => setState(() => _disabled = v),
                ),
                CustomButton(
                  text: 'Кнопка',
                  style: _style,
                  isLoading: _loading,
                  icon: const Icon(Icons.bolt, size: 18),
                  onPressed: _disabled ? null : () {},
                ),
              ],
            ),
          ),
          // ProfileWidget(user: user, isCompact: true)
          _section(
            'ProfileWidget',
            'ProfileWidget(user: user, isCompact: $_compact)',
            Column(
              children: [
                SwitchListTile(
                  title: const Text('isCompact'),
                  value: _compact,
                  onChanged: (v) => setState(() => _compact = v),
                ),
                ProfileWidget(user: user, isCompact: _compact, onEditPressed: () {}),
              ],
            ),
          ),
          // AnimatedCounter(maxValue: 10)
          _section(
            'AnimatedCounter',
            'AnimatedCounter(maxValue: ${_max.round()})',
            Column(
              children: [
                Slider(
                  min: 3,
                  max: 30,
                  divisions: 27,
                  label: '${_max.round()}',
                  value: _max,
                  onChanged: (v) => setState(() => _max = v),
                ),
                AnimatedCounter(maxValue: _max.round()),
              ],
            ),
          ),
          // ProductCard(product: p, isFavorite: ..., onFavoriteToggle: ...)
          _section(
            'ProductCard',
            'ProductCard(product: p, isFavorite: $_favorite)',
            ProductCard(
              product: _demo,
              isFavorite: _favorite,
              onFavoriteToggle: () => setState(() => _favorite = !_favorite),
              onAddToCart: () {},
            ),
          ),
        ],
      ),
    );
  }
}
