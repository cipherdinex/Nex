import 'package:flutter/material.dart';
import 'package:kryptonia/backends/all_backends.dart';

class MultiTrnsText extends StatelessWidget {
  const MultiTrnsText({
    Key? key,
    required this.title,
    this.style,
    this.textAlign,
    this.extra1 = '',
    this.extra2 = '',
    this.args,
  }) : super(key: key);

  final List<String> title;
  final TextStyle? style;
  final TextAlign? textAlign;
  final String extra1;
  final String extra2;
  final Map<String, String>? args;

  @override
  Widget build(BuildContext context) {
    AllBackEnds _allBackEnds = AllBackEnds();

    return Text(
      extra1 +
          _allBackEnds.multiTranslation(context, title, args: args)! +
          extra2,
      style: style,
      textAlign: textAlign,
    );
  }
}
