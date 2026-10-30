import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_widgets_app/models/user.dart';
import 'package:mobile_widgets_app/widgets/profile_widget.dart';

const _user = User(id: '1', name: 'Олена Коваленко', email: 'o@example.com');

Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('ProfileWidget Tests', () {
    testWidgets('shows name, email and initials', (tester) async {
      await tester.pumpWidget(wrap(const ProfileWidget(user: _user)));
      expect(find.text('Олена Коваленко'), findsOneWidget);
      expect(find.text('o@example.com'), findsOneWidget);
      expect(find.text('ОК'), findsOneWidget);
    });

    testWidgets('compact mode shows edit icon and calls callback',
        (tester) async {
      var edits = 0;
      await tester.pumpWidget(wrap(
        ProfileWidget(user: _user, isCompact: true, onEditPressed: () => edits++),
      ));
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pump();
      expect(edits, 1);
    });

    testWidgets('no edit button without callback', (tester) async {
      await tester.pumpWidget(wrap(const ProfileWidget(user: _user)));
      expect(find.byIcon(Icons.edit), findsNothing);
    });
  });
}
