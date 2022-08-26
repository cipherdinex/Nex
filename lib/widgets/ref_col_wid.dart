import 'package:flutter/material.dart';
import 'package:kryptonia/widgets/trns_text.dart';

class RefColWid extends StatelessWidget {
  const RefColWid({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TrnsText(
          title: title,
          style: TextStyle(
            color:
                Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.5),
          ),
        ),
        Text(value),
      ],
    );
  }
}
