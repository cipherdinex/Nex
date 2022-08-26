import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kryptonia/helpers/colors.dart';

class CustProgIndicator extends StatelessWidget {
  const CustProgIndicator({
    Key? key,
    this.radius,
  }) : super(key: key);

  final radius;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Platform.isIOS
          ? CupertinoActivityIndicator()
          : CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(accentColor)),
    );
  }
}
