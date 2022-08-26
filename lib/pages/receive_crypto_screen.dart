import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/app_config.dart';
import 'package:kryptonia/helpers/colors.dart';
import 'package:kryptonia/helpers/strings.dart';
import 'package:kryptonia/widgets/address_qr_wid.dart';
import 'package:kryptonia/widgets/cust_button.dart';
import 'package:kryptonia/widgets/cust_container.dart';
import 'package:kryptonia/widgets/k_header.dart';
import 'package:share/share.dart';

class ReceiveCryptoScreen extends StatefulWidget {
  const ReceiveCryptoScreen({Key? key}) : super(key: key);

  @override
  _ReceiveCryptoScreenState createState() => _ReceiveCryptoScreenState();
}

class _ReceiveCryptoScreenState extends State<ReceiveCryptoScreen> {
  var userBox = Hive.box(USERS);

  AllBackEnds _allBackEnds = AllBackEnds();
  int _ind = 0;
  String _value = BITCOIN;

  @override
  Widget build(BuildContext context) {
    return KHeader(
      title: ["Receive {Arg}"],
      args: {'Arg': ''},
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AddressQrWid(address: getAddress()),
              SizedBox(height: 100),
              ReceiveContWid(
                svg: getSvg(),
                address: getSvg().capitalize()!,
                name: getUnit().toUpperCase(),
                onTap: getCryptoCurrency,
              ),
              SizedBox(height: 50),
              CustButton(
                title: "Share",
                onTap: () => Share.share(
                  _allBackEnds.translation(context,
                      "Hi, send me some {Arg1} using my address {Arg2} on {Arg3}, download the app via {Arg4}",
                      args: {
                        'Arg1': getUnit().toUpperCase(),
                        'Arg2': getAddress(),
                        'Arg3': APP_NAME,
                        'Arg4': WEBSITE_URL,
                      }),
                  subject: APP_NAME,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getSvg() {
    return Platform.isIOS ? CRYPTOCURRENCIES[_ind] : _value;
  }

  String getUnit() {
    return Platform.isAndroid
        ? UNITS[CRYPTOCURRENCIES.indexOf(_value)]
        : UNITS[_ind];
  }

  String getAddress() {
    String unit = getUnit() == ETH || getUnit() == BNB || getUnit() == USDT
        ? ERC20
        : getUnit();
    var encryptedWallet = userBox.get(USER)[WALLET][unit + '_' + ADDRESS];
    String address = _allBackEnds.decrypt(encryptedWallet);

    return address;
  }

  getCryptoCurrency() {
    _allBackEnds.showPicker(
      context,
      children: CRYPTOCURRENCIES,
      onChanged: (String? val) {
        setState(() {
          _value = val!;
        });
        Navigator.pop(context);
      },
      onSelectedItemChanged: (int? index) {
        setState(() {
          _ind = index!;
        });
      },
      hasTrns: false,
    );
  }
}

class ReceiveContWid extends StatelessWidget {
  const ReceiveContWid({
    Key? key,
    required this.address,
    required this.name,
    required this.onTap,
    required this.svg,
  }) : super(key: key);

  final String svg;
  final void Function() onTap;
  final String address;
  final String name;
  @override
  Widget build(BuildContext context) {
    return CustContainer(
      height: 70,
      child: InkWell(
        onTap: onTap,
        splashColor: transparent,
        highlightColor: transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  child: SvgPicture.asset('assets/svg/$svg.svg'),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .color!
                            .withOpacity(0.5),
                      ),
                    ),
                    Text(address),
                  ],
                ),
                SizedBox(width: 20),
              ],
            ),
            Icon(CupertinoIcons.chevron_down, size: 18)
          ],
        ),
      ),
    );
  }
}
