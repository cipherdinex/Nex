import 'package:flutter/material.dart';
import 'package:kryptonia/widgets/trns_text.dart';

class TextHeaderWid extends StatelessWidget {
  const TextHeaderWid({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String? title;
  @override
  Widget build(BuildContext context) {
    return TrnsText(
      title: title!,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
