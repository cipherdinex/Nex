import 'package:flutter/material.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/colors.dart';
import 'package:kryptonia/widgets/trns_text.dart';

class TextLinkWid extends StatelessWidget {
  const TextLinkWid({
    Key? key,
    this.onTap,
    required this.title,
    this.url,
    this.color,
    this.size,
  }) : super(key: key);
  final String? title;
  final String? url;
  final void Function()? onTap;
  final Color? color;
  final double? size;
  @override
  Widget build(BuildContext context) {
    AllBackEnds _allBackEnds = AllBackEnds();

    return InkWell(
      onTap: url != null ? () => _allBackEnds.launchUrlFxn(url) : onTap,
      child: TrnsText(
        title: title!,
        style: TextStyle(color: color ?? blue, fontSize: size ?? 14.0),
      ),
    );
  }
}
