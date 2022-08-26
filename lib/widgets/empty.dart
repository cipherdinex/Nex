import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kryptonia/widgets/trns_text.dart';

class EmptyWid extends StatelessWidget {
  const EmptyWid({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.svg,
    this.height,
  }) : super(key: key);

  final String svg;
  final String title;
  final String subtitle;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SvgPicture.asset(
            "assets/svg/$svg.svg",
            height: height ?? 300,
          ),
          SizedBox(
            height: 50,
          ),
          TrnsText(
            title: title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TrnsText(
            title: subtitle,
          ),
        ],
      ),
    );
  }
}
