import 'package:flutter/material.dart';

import 'bounce_tap.dart';

enum CustomButtonStyle { primary, secondary, danger, outline }

/// Універсальна кнопка: 4 стилі, іконка, стан завантаження,
/// «пружний» ефект і підтримка Semantics (доступність).
///
/// Приклад:
/// CustomButton(
///   text: 'Зберегти',
///   style: CustomButtonStyle.primary,
///   icon: Icon(Icons.save),
///   onPressed: () {},
/// )
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final CustomButtonStyle style;
  final Widget? icon;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style = CustomButtonStyle.primary,
    this.icon,
    this.isLoading = false,
  });

  bool get _enabled => onPressed != null && !isLoading;

  Color _background(ColorScheme s) {
    switch (style) {
      case CustomButtonStyle.primary:
        return s.primary;
      case CustomButtonStyle.secondary:
        return s.secondaryContainer;
      case CustomButtonStyle.danger:
        return s.error;
      case CustomButtonStyle.outline:
        return Colors.transparent;
    }
  }

  Color _foreground(ColorScheme s) {
    switch (style) {
      case CustomButtonStyle.primary:
        return s.onPrimary;
      case CustomButtonStyle.secondary:
        return s.onSecondaryContainer;
      case CustomButtonStyle.danger:
        return s.onError;
      case CustomButtonStyle.outline:
        return s.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final foreground = _foreground(scheme);

    final Widget label = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: foreground,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 8)],
              Text(text),
            ],
          );

    final VoidCallback? handler = _enabled ? onPressed : null;

    final Widget button = style == CustomButtonStyle.outline
        ? OutlinedButton(
            onPressed: handler,
            style: OutlinedButton.styleFrom(
              foregroundColor: scheme.primary,
              side: BorderSide(color: scheme.primary),
            ),
            child: label,
          )
        : FilledButton(
            onPressed: handler,
            style: FilledButton.styleFrom(
              backgroundColor: _background(scheme),
              foregroundColor: foreground,
            ),
            child: label,
          );

    return Semantics(
      button: true,
      enabled: _enabled,
      child: BounceTap(enabled: _enabled, child: button),
    );
  }
}
