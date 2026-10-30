import 'package:flutter/material.dart';

import '../utils/app_state.dart';
import '../utils/constants.dart';
import '../widgets/animated_counter.dart';
import '../widgets/custom_button.dart';
import '../widgets/profile_widget.dart';
import 'products_screen.dart';
import 'profile_screen.dart';
import 'showcase_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final user = state.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Badge(
              label: Text('${state.cartItemsCount}'),
              isLabelVisible: state.cartItemsCount > 0,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.padding),
        children: [
          if (user != null) ProfileWidget(user: user, isCompact: true),
          const SizedBox(height: 24),
          const Center(child: AnimatedCounter(maxValue: 10)),
          const SizedBox(height: 24),
          Text(
            'Обраних товарів: ${state.favoriteProducts.length}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Каталог товарів',
            icon: const Icon(Icons.storefront),
            onPressed: () => _open(context, const ProductsScreen()),
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: 'Профіль',
            style: CustomButtonStyle.secondary,
            icon: const Icon(Icons.person),
            onPressed: () => _open(context, const ProfileScreen()),
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: 'Showcase віджетів',
            style: CustomButtonStyle.outline,
            icon: const Icon(Icons.widgets),
            onPressed: () => _open(context, const ShowcaseScreen()),
          ),
        ],
      ),
    );
  }
}
