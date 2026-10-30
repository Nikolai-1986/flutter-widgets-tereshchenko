import 'package:flutter/material.dart';

import '../utils/app_state.dart';
import '../utils/constants.dart';
import '../widgets/profile_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _compact = false;

  Future<void> _editName(BuildContext context) async {
    final state = AppScope.of(context);
    final controller = TextEditingController(text: state.currentUser?.name);
    String? error;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Редагувати імʼя'),
              content: TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Імʼя',
                  errorText: error,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Скасувати'),
                ),
                FilledButton(
                  onPressed: () {
                    final result = state.updateUserName(controller.text);
                    if (result == null) {
                      Navigator.of(dialogContext).pop();
                    } else {
                      setDialogState(() => error = result);
                    }
                  },
                  child: const Text('Зберегти'),
                ),
              ],
            );
          },
        );
      },
    );
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final user = state.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Профіль')),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.padding),
        children: [
          if (user != null)
            ProfileWidget(
              user: user,
              isCompact: _compact,
              onEditPressed: () => _editName(context),
            ),
          SwitchListTile(
            title: const Text('Компактний режим'),
            value: _compact,
            onChanged: (v) => setState(() => _compact = v),
          ),
          const Divider(),
          Text('Обране (${state.favoriteProducts.length})',
              style: Theme.of(context).textTheme.titleMedium),
          for (final p in state.favoriteProducts)
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.red),
              title: Text(p.title),
              trailing: Text(p.formattedPrice),
            ),
        ],
      ),
    );
  }
}
