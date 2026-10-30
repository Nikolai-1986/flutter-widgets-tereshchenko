import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_widgets_app/widgets/custom_button.dart';

Widget wrap(Widget child) =>
    MaterialApp(home: Scaffold(body: Center(child: child)));

void main() {
  group('CustomButton Widget Tests', () {
    testWidgets('should render text correctly', (tester) async {
      await tester.pumpWidget(
        wrap(const CustomButton(text: 'Зберегти', onPressed: null)),
      );
      expect(find.text('Зберегти'), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        wrap(CustomButton(text: 'OK', onPressed: () => taps++)),
      );
      await tester.tap(find.text('OK'));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('should show loading state', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        wrap(CustomButton(text: 'Wait', isLoading: true, onPressed: () => taps++)),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Wait'), findsNothing);
      await tester.tap(find.byType(FilledButton), warnIfMissed: false);
      await tester.pump();
      expect(taps, 0);
    });

    testWidgets('outline style renders OutlinedButton', (tester) async {
      await tester.pumpWidget(
        wrap(CustomButton(
          text: 'Outline',
          style: CustomButtonStyle.outline,
          onPressed: () {},
        )),
      );
      expect(find.byType(OutlinedButton), findsOneWidget);
    });
  });
}
