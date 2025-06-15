import 'package:flutter/material.dart';

class ResponsiveText extends StatelessWidget {
  final String text;
  final double maxFontSize;
  final double minFontSize;
  final TextStyle baseStyle;

  const ResponsiveText({
    required this.text,
    this.maxFontSize = 30,
    this.minFontSize = 12,
    required this.baseStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 一旦1行表示でのTextPainterを使ってサイズを測定
        final tp = TextPainter(
          text: TextSpan(
            text: text,
            style: baseStyle.copyWith(fontSize: maxFontSize),
          ),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        );

        tp.layout(maxWidth: constraints.maxWidth);

        // 実際の幅と制限幅を比較
        if (tp.didExceedMaxLines || tp.width > constraints.maxWidth) {
          // 折り返しありで再表示（最小フォントサイズも固定できる）
          return Text(
            text,
            style: baseStyle.copyWith(fontSize: minFontSize),
            maxLines: null,
            softWrap: true,
          );
        } else {
          // 1行で表示できるならそのまま
          return Text(
            text,
            style: baseStyle.copyWith(fontSize: maxFontSize),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }
      },
    );
  }
}
