import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobile_widgets_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('user flow: open catalog, add to cart, mark favorite',
      (tester) async {
    app.main();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('Каталог товарів'));
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('У кошик').first);
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.textContaining('додано в кошик'), findsOneWidget);

    await tester.tap(find.byKey(const Key('favorite_button_p1')));
    await tester.pump(const Duration(milliseconds: 500));

    await tester.pageBack();
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Обраних товарів: 1'), findsOneWidget);
  });
}
