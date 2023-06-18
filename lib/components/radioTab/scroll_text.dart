import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class ScrollText extends StatelessWidget {
  final String text;
  final double fontSize;
  final TextStyle style;

  const ScrollText(
    this.text, {
    required this.fontSize,
    required this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: fontSize + 4,
      child: AutoSizeText(
        text,
        maxLines: 1,
        minFontSize: fontSize,
        maxFontSize: fontSize,
        style: style,
        overflowReplacement: Marquee(
          text: text,
          blankSpace: 50,
          style: style.copyWith(fontSize: fontSize),
        ),
      ),
    );
  }
}
