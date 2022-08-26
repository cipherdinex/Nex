import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kryptonia/helpers/app_config.dart';

import 'package:kryptonia/helpers/strings.dart';
import 'package:kryptonia/widgets/about_tile.dart';
import 'package:kryptonia/widgets/k_header.dart';
import 'package:kryptonia/widgets/trns_text.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var settingsBx = Hive.box(SETTINGS);
    String version = settingsBx.get(VERSION);
    return KHeader(
      title: ["About"],
      body: Column(
        children: [
          AboutTile(
            title: "Help Center",
            url: HELP_CENTER_URL,
          ),
          AboutTile(
            title: "FAQs",
            url: FAQ_URL,
          ),
          AboutTile(
            title: "Privacy Policy",
            url: PRIVACY_POLICY_URL,
          ),
          AboutTile(
            title: "Terms of Service",
            url: TERMS_URL,
          ),
          AboutTile(
            title: "Support",
            url: SUPPORT_URL,
          ),
          AboutTile(
            title: "Make a Suggestion",
            url: MAKE_SUGGESTION_URL,
          ),
          SizedBox(height: 50),
          TrnsText(
            title: "App Version {Arg}",
            args: {'Arg': version},
          )
        ],
      ),
    );
  }
}
