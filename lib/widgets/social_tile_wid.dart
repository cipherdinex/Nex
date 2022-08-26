import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/widgets/trns_text.dart';

class SocialWid extends StatelessWidget {
  const SocialWid({
    Key? key,
    required this.icon,
    required this.url,
    required this.title,
  }) : super(key: key);

  final String url;
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    AllBackEnds _allBackEnds = AllBackEnds();

    return InkWell(
      onTap: () {
        try {
          _allBackEnds.launchUrlFxn(url);
        } catch (e) {
          print(e);
        }
      },
      child: ListTile(
        leading: Icon(
          icon,
        ),
        title: TrnsText(
          title: title,
        ),
        trailing: Icon(
          CupertinoIcons.forward,
          size: 15,
        ),
      ),
    );
  }
}
