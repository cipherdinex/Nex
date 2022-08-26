import 'package:flutter/material.dart';
import 'package:kryptonia/widgets/trns_text.dart';

class ActivityWid extends StatelessWidget {
  const ActivityWid({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TrnsText(
          title: title,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
