import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/widgets/trns_text.dart';

class AboutTile extends StatelessWidget {
  const AboutTile({
    Key? key,
    required this.title,
    required this.url,
  }) : super(key: key);

  final String url;
  final String title;

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
        title: TrnsText(title: title),
        trailing: Icon(
          CupertinoIcons.forward,
          size: 15,
        ),
      ),
    );
  }
}
