import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/app_config.dart';
import 'package:kryptonia/helpers/colors.dart';
import 'package:kryptonia/helpers/strings.dart';
import 'package:kryptonia/widgets/cust_button.dart';
import 'package:kryptonia/widgets/cust_container.dart';
import 'package:kryptonia/widgets/ref_col_wid.dart';
import 'package:kryptonia/widgets/text_link.dart';
import 'package:kryptonia/widgets/trns_text.dart';
import 'package:share/share.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({
    Key? key,
    this.data,
  }) : super(key: key);

  final String? data;

  @override
  Widget build(BuildContext context) {
    Map dts = jsonDecode(data!);

    AllBackEnds _allBackEnds = AllBackEnds();

    Size med = MediaQuery.of(context).size;
    double balance = double.parse(dts[REFBALANCE]);
    int cCount = dts[REFCONFIRMCOUNT];
    int uCount = dts[REFUNCONFIRMCOUNT];

    String earned =
        dts[CURRENCY] + " " + ((dts[RATE] / 10) * balance).toStringAsFixed(2);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: transparent,
        elevation: 0.0,
        iconTheme:
            IconThemeData(color: Theme.of(context).textTheme.bodyText1!.color),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("assets/images/box.png"),
              SizedBox(height: 20),
              TrnsText(
                title: "Get {Arg} in ",
                args: {
                  'Arg': '${dts[CURRENCY]} ${dts[RATE].toStringAsFixed(2)}'
                },
                extra2: BITCOIN.capitalize()!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TrnsText(
                title:
                    "You will earn {Arg1} when your friend buys or sells {Arg2} of Crypto",
                args: {
                  'Arg1': '${dts[CURRENCY]} ${dts[RATE].toStringAsFixed(2)}',
                  'Arg2':
                      '${dts[CURRENCY]} ${(dts[RATE] * 10).toStringAsFixed(2)}'
                },
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              CustContainer(
                height: 60,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      dts[REFCODE],
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    InkWell(
                      onTap: () => FlutterClipboard.copy(dts[REFCODE]).then(
                          (value) =>
                              _allBackEnds.showSnacky("Copied", true, context)),
                      child: CustContainer(
                        width: 100,
                        height: 50,
                        child: Center(
                          child: TrnsText(title: "Copy"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4),
              CustContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RefColWid(
                      title: 'Reward',
                      value: earned,
                    ),
                    VerticalDivider(
                      width: 30,
                      color: black,
                      thickness: 2,
                    ),
                    RefColWid(
                      title: 'Confirmed',
                      value: '$cCount',
                    ),
                    VerticalDivider(
                      width: 30,
                      color: black,
                      thickness: 2,
                    ),
                    RefColWid(
                      title: 'UnConfirmed',
                      value: "$uCount",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustButton(
                    color: green,
                    width: med.width * 0.4,
                    onTap: () => requestFxn(context),
                    title: "Request",
                  ),
                  CustButton(
                      width: med.width * 0.4,
                      onTap: () => Share.share(
                            _allBackEnds.translation(context,
                                "Hi, use my refcode {Arg1} to register and trade crypto seamlessy at {Arg2}, visit {Arg3} for more info.",
                                args: {
                                  'Arg1': dts[REFCODE],
                                  'Arg2': APP_NAME,
                                  'Arg3': WEBSITE_URL,
                                }),
                            subject: APP_NAME,
                          ),
                      title: "Share")
                ],
              ),
              SizedBox(height: 20),
              TextLinkWid(
                title: "Terms and Conditions",
                url: TERMS_URL,
              ),
            ],
          ),
        ),
      ),
    );
  }

  requestFxn(context) async {
    AllBackEnds _allBackEnds = AllBackEnds();

    try {
      await _allBackEnds.requestRefPayout(context);
    } catch (e) {
      print(e);
    }
  }
}
