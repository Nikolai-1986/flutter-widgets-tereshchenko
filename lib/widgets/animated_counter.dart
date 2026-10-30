import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'bounce_tap.dart';

/// Анімований лічильник:
///  - scale-анімація числа при кожній зміні;
///  - плавний перехід кольору при досягненні максимуму;
///  - «пружний» ефект на кнопках;
///  - прогрес-індикатор зі плавною зміною значення.
class AnimatedCounter extends StatefulWidget {
  final int initialValue;
  final int maxValue;
  final Duration animationDuration;
  final Color? primaryColor;

  const AnimatedCounter({
    super.key,
    this.initialValue = 0,
    this.maxValue = 100,
    this.animationDuration = const Duration(milliseconds: 300),
    this.primaryColor,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with TickerProviderStateMixin {
  late int _value;
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _value = math.max(0, math.min(widget.maxValue, widget.initialValue));
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.35)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.35, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationDuration != widget.animationDuration) {
      _controller.duration = widget.animationDuration;
    }
    if (_value > widget.maxValue) {
      setState(() => _value = widget.maxValue);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _change(int delta) {
    final next = math.max(0, math.min(widget.maxValue, _value + delta));
    if (next == _value) return;
    setState(() => _value = next);
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = widget.primaryColor ?? theme.colorScheme.primary;
    final atMax = _value >= widget.maxValue;
    final target = atMax ? Colors.green.shade700 : base;
    final progress = widget.maxValue == 0 ? 0.0 : _value / widget.maxValue;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TweenAnimationBuilder<Color?>(
          tween: ColorTween(end: target),
          duration: widget.animationDuration,
          builder: (context, color, _) {
            return ScaleTransition(
              scale: _scale,
              child: Text(
                '$_value',
                key: const Key('counter_value'),
                style: theme.textTheme.displayMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
        Text('із ${widget.maxValue}', style: theme.textTheme.bodySmall),
        const SizedBox(height: 12),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: progress),
          duration: widget.animationDuration * 2,
          curve: Curves.easeOutCubic,
          builder: (context, value, _) {
            return LinearProgressIndicator(
              value: value,
              minHeight: 8,
              color: target,
              borderRadius: BorderRadius.circular(4),
            );
          },
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 20,
          child: atMax
              ? Text(
                  'Максимум!',
                  style: theme.textTheme.labelLarge?.copyWith(color: target),
                )
              : null,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BounceTap(
              child: FilledButton(
                key: const Key('counter_decrement'),
                onPressed: () => _change(-1),
                child: const Icon(Icons.remove),
              ),
            ),
            const SizedBox(width: 16),
            BounceTap(
              child: FilledButton(
                key: const Key('counter_increment'),
                onPressed: () => _change(1),
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
