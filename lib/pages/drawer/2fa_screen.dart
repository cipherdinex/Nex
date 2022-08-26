import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_nullsafty/flutter_icons_nullsafty.dart';

import 'package:kryptonia/widgets/k_header.dart';
import 'package:kryptonia/widgets/pref_wid.dart';

class TwoFAScreen extends StatelessWidget {
  const TwoFAScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KHeader(
      title: ["Choose a Provider"],
      body: Column(
        children: [
          PreferenceWid(
            icon: Feather.message_square,
            title: "Phone",
            subtitle: ["Receive OTP via", "SMS"],
            trailing: Icon(CupertinoIcons.forward, size: 15),
            onTap: () => Navigator.pushNamed(context, '/phone-2fa/'),
          ),
        ],
      ),
    );
  }
}
