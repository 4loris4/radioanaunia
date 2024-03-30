import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:flutter/material.dart';

class ScrollText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const ScrollText(
    this.text, {
    this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AutoScrollText(
      text,
      style: style,
      mode: AutoScrollTextMode.endless,
      intervalSpaces: 12,
      delayBefore: const Duration(seconds: 1),
      velocity: const Velocity(pixelsPerSecond: Offset(50, 0)),
    );
  }
}
