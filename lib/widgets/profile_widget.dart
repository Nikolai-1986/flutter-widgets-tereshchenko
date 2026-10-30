import 'package:flutter/material.dart';

import '../models/user.dart';

/// Профіль користувача з двома режимами (compact / expanded)
/// і адаптивним розташуванням через LayoutBuilder.
/// Кольори й шрифти беруться з поточної Theme.
class ProfileWidget extends StatelessWidget {
  final User user;
  final VoidCallback? onEditPressed;
  final bool isCompact;

  const ProfileWidget({
    super.key,
    required this.user,
    this.onEditPressed,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 600;
        final radius = isCompact ? 22.0 : (wide ? 48.0 : 40.0);

        final avatar = CircleAvatar(
          radius: radius,
          backgroundColor: scheme.primaryContainer,
          foregroundColor: scheme.onPrimaryContainer,
          backgroundImage:
              user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
          child: user.avatarUrl == null
              ? Text(
                  user.initials,
                  style: TextStyle(
                    fontSize: radius * 0.7,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        );

        final alignStart = isCompact || wide;
        final info = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              alignStart ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Text(
              user.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: (isCompact
                      ? theme.textTheme.titleMedium
                      : theme.textTheme.headlineSmall)
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              user.email,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        );

        Widget content;
        if (isCompact) {
          content = Row(
            children: [
              avatar,
              const SizedBox(width: 12),
              Expanded(child: info),
              if (onEditPressed != null)
                IconButton(
                  tooltip: 'Редагувати профіль',
                  icon: const Icon(Icons.edit),
                  onPressed: onEditPressed,
                ),
            ],
          );
        } else if (wide) {
          content = Row(
            children: [
              avatar,
              const SizedBox(width: 24),
              Expanded(child: info),
              if (onEditPressed != null)
                TextButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Редагувати'),
                  onPressed: onEditPressed,
                ),
            ],
          );
        } else {
          content = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              avatar,
              const SizedBox(height: 12),
              info,
              if (onEditPressed != null) ...[
                const SizedBox(height: 8),
                TextButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Редагувати'),
                  onPressed: onEditPressed,
                ),
              ],
            ],
          );
        }

        return Card(
          child: Padding(
            padding: EdgeInsets.all(isCompact ? 12 : 20),
            child: content,
          ),
        );
      },
    );
  }
}
