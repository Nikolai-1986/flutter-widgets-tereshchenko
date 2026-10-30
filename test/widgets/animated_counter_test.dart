import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_widgets_app/widgets/animated_counter.dart';

Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: Center(child: child)));

void main() {
  group('AnimatedCounter Tests', () {
    testWidgets('increments and decrements', (tester) async {
      await tester.pumpWidget(
        wrap(const AnimatedCounter(initialValue: 2, maxValue: 5)),
      );
      expect(find.text('2'), findsOneWidget);

      await tester.tap(find.byKey(const Key('counter_increment')));
      await tester.pumpAndSettle();
      expect(find.text('3'), findsOneWidget);

      await tester.tap(find.byKey(const Key('counter_decrement')));
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('does not go below zero', (tester) async {
      await tester.pumpWidget(wrap(const AnimatedCounter(maxValue: 5)));
      await tester.tap(find.byKey(const Key('counter_decrement')));
      await tester.pumpAndSettle();
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('shows max label at maxValue', (tester) async {
      await tester.pumpWidget(
        wrap(const AnimatedCounter(initialValue: 2, maxValue: 3)),
      );
      expect(find.text('Максимум!'), findsNothing);
      await tester.tap(find.byKey(const Key('counter_increment')));
      await tester.pumpAndSettle();
      expect(find.text('Максимум!'), findsOneWidget);

      await tester.tap(find.byKey(const Key('counter_increment')));
      await tester.pumpAndSettle();
      expect(find.text('3'), findsOneWidget);
    });
  });
}
