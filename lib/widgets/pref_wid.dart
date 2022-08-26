import 'package:flutter/material.dart';
import 'package:kryptonia/widgets/trns_m_text.dart';
import 'package:kryptonia/widgets/trns_text.dart';

class PreferenceWid extends StatelessWidget {
  const PreferenceWid({
    Key? key,
    this.icon,
    this.onTap,
    required this.title,
    required this.trailing,
    this.subtitle,
    this.mArgs,
  }) : super(key: key);

  final String? title;
  final IconData? icon;
  final void Function()? onTap;
  final Widget? trailing;
  final List<String>? subtitle;
  final Map<String, String>? mArgs;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? null,
      child: ListTile(
        leading: icon != null ? Icon(icon) : null,
        title: TrnsText(
          title: title!,
        ),
        subtitle: subtitle != null
            ? MultiTrnsText(
                title: subtitle!,
                args: mArgs,
              )
            : null,
        trailing: trailing,
      ),
    );
  }
}
