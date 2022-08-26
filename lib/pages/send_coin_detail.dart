import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/colors.dart';
import 'package:kryptonia/helpers/strings.dart';

import 'package:kryptonia/utils/pass_code_utils.dart';
import 'package:kryptonia/widgets/activity_wid.dart';
import 'package:kryptonia/widgets/cust_button.dart';
import 'package:kryptonia/widgets/cust_container.dart';
import 'package:kryptonia/widgets/k_header.dart';

class SendCoinDetail extends StatefulWidget {
  const SendCoinDetail({
    Key? key,
    required this.data,
  }) : super(key: key);

  final String? data;

  @override
  _SendCoinDetailState createState() => _SendCoinDetailState();
}

class _SendCoinDetailState extends State<SendCoinDetail> {
  AllBackEnds _allBackends = AllBackEnds();

  var settingsBx = Hive.box(SETTINGS);
  var userBox = Hive.box(USERS);

  getHiveFxn(String key) {
    return settingsBx.get(key);
  }

  @override
  Widget build(BuildContext context) {
    Map dts = jsonDecode(widget.data!);

    Size med = MediaQuery.of(context).size;

    String addressFrom = dts[FROM].substring(0, 8) +
        "..." +
        dts[FROM].substring(dts[FROM].length - 8, dts[FROM].length);
    String addressTo = dts[TO].substring(0, 8) +
        "..." +
        dts[TO].substring(dts[TO].length - 8, dts[TO].length);

    String unit = dts[UNIT];
    String currency = dts[CURRENCY].toUpperCase();
    String name = dts[NAME];
    String amount = dts[AMOUNT];
    var rate = dts[RATE];
    String equivalent = (rate * double.parse(amount)).toStringAsFixed(2);
    String gas = dts[GAS_FEE];
    String gasEquivalent = (rate * double.parse(gas)).toStringAsFixed(2);
    String total = (double.parse(equivalent) + double.parse(gasEquivalent))
        .toStringAsFixed(2);

//d2dcd857679f4ad891627c793ff67200b50c76b0d8f44f89d710f86181837fee
    return KHeader(
      title: ["Transfer"],
      body: Container(
        width: double.infinity,
        height: med.height * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  amount + " " + unit.toUpperCase(),
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "≈ $currency " + equivalent,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                CustContainer(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ActivityWid(
                          title: "Asset",
                          value: "${name.capitalize()}(${unit.toUpperCase()})"),
                      ActivityWid(title: "From", value: addressFrom),
                      ActivityWid(title: "To", value: addressTo),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                CustContainer(
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ActivityWid(
                          title: "Network Fee",
                          value:
                              "$gas ${unit.toUpperCase()}($currency $gasEquivalent)"),
                      ActivityWid(
                          title: "Max Total", value: "$currency $total"),
                    ],
                  ),
                ),
              ],
            ),
            CustButton(
              onTap: () {
                authenticate(med, dts);
              },
              title: "Authenticate",
            )
          ],
        ),
      ),
    );
  }

  authenticate(Size med, dts) async {
    bool trxnSign = getHiveFxn(TRXN_SIGNING) ?? false;
    bool hasBiometrics = getHiveFxn(BIOMETRICS) ?? false;
    String passcode = getHiveFxn(PASSCODE);

    try {
      if (trxnSign) {
        if (hasBiometrics) {
          bool? authResult = await _allBackends.authenticate();
          if (authResult!) {
            otpCheckFxn(dts);
          }
        } else {
          _allBackends.showModalBar(context,
              StatefulBuilder(builder: (context, StateSetter state) {
            return Container(
              height: med.height * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  Text(_allBackends.translation(context, "Enter Passcode")),
                  Container(
                    height: 100,
                    width: double.infinity,
                    child: PassCodeUtils(
                      obscure: true,
                      onChanged: (String value) {},
                      onCompleted: (String v) {
                        if (v == passcode) {
                          Navigator.pop(context);
                          otpCheckFxn(dts);
                        }
                      },
                      validator: (v) {
                        if (v!.length < 6) {
                          return _allBackends.translation(
                              context, "Invalid Code Length");
                        } else if (v != passcode) {
                          return _allBackends.translation(
                              context, "Wrong Passcode");
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }));
        }
      } else {
        otpCheckFxn(dts);
      }
    } catch (e) {
      _allBackends.showSnacky(
          _allBackends.translation(context, DEFAULT_ERROR), false, context);
    }
  }

  otpCheckFxn(dts) async {
    _allBackends.otpCheckFxn(() {
      runTrxn(dts);
    }, context);
  }

  runTrxn(dts) async {
    Map? result;

    try {
      //?
      if (dts[UNIT] == ETH || dts[UNIT] == BNB) {
        bool isEth = dts[UNIT] == ETH ? true : false;
        await _allBackends.clientsInit(dts[UNIT]);

        result = await _allBackends.transferEthBnbToken(
            dts[ERC20 + '_' + TRANSFERKEY],
            dts[TO],
            double.parse(dts[AMOUNT]),
            isEth);

        //?
      } else {
        result = await _allBackends.transferCoin(
            dts[dts[UNIT] + '_' + WALLETID],
            dts[dts[UNIT] + '_' + TRANSFERKEY],
            dts[TO],
            dts[AMOUNT]);
      }

      if (result[STATUS]) {
        popFxn(true, result[HASH]);
        _allBackends.storeUserActivitiesSql(7);
      } else {
        popFxn(false, null);
      }
    } catch (e) {
      print(e);
      _allBackends.showSnacky(DEFAULT_ERROR, false, context);
    }
  }

  popFxn(bool success, hash) async {
    await _allBackends.showPopUp(
      context,
      success
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: green,
                ),
                SizedBox(height: 10),
                Text(_allBackends.translation(context, "Transaction Sent")),
                SizedBox(height: 10),
                Text(hash),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.close_rounded,
                  color: red,
                ),
                SizedBox(height: 10),
                Text(_allBackends.translation(context, "Transaction Failed")),
              ],
            ),
      [
        CupertinoButton(
          child: Text("Ok"),
          onPressed: () {
            Navigator.pop(context);
            if (success)
              Navigator.pushReplacementNamed(context, '/bottom-nav/');
          },
        )
      ],
      [
        TextButton(
          child: Text("Ok"),
          onPressed: () {
            Navigator.pop(context);
            if (success)
              Navigator.pushReplacementNamed(context, '/bottom-nav/');
          },
        )
      ],
      barrierDismissible: false,
    );
  }

  Map getKeys(dts) {
    Map data = {};
    String unit = dts[UNIT] == ETH || dts[UNIT] == BNB || dts[UNIT] == USDT
        ? ERC20
        : dts[UNIT];
    if (unit != ERC20) {
      var encryptedWallet = userBox.get(USER)[WALLET][unit + '_' + WALLETID];
      var encryptedTransferKey =
          userBox.get(USER)[WALLET][unit + '_' + TRANSFERKEY];
      String walletId = _allBackends.decrypt(encryptedWallet);
      String transferKey = _allBackends.decrypt(encryptedTransferKey);
      data = {
        WALLETID: walletId,
        TRANSFERKEY: transferKey,
      };
      return data;
    } else {
      var encryptedKey = userBox.get(USER)[WALLET][unit + '_' + TRANSFERKEY];
      String privateKey = _allBackends.decrypt(encryptedKey);
      data = {
        TRANSFERKEY: privateKey,
      };
      return data;
    }
  }
}
