import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/colors.dart';

import 'package:kryptonia/widgets/cust_container.dart';
import 'package:kryptonia/widgets/trns_text.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddressQrWid extends StatelessWidget {
  const AddressQrWid({
    Key? key,
    required this.address,
  }) : super(key: key);

  final String address;

  @override
  Widget build(BuildContext context) {
    AllBackEnds _allBackends = AllBackEnds();
    return CustContainer(
      height: 410,
      child: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            color: white,
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: QrImage(
                data: address,
                version: QrVersions.auto,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            height: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TrnsText(
                      title: "{Arg} Address",
                      args: {"Arg": ""},
                    ),
                    Text(
                      address.substring(0, 6) +
                          "..." +
                          address.substring(address.length - 6, address.length),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => FlutterClipboard.copy(address).then(
                    (value) => _allBackends.showSnacky(
                        "Address Copied", true, context),
                  ),
                  child: CustContainer(
                    width: 100,
                    height: 50,
                    child: Center(
                      child: TrnsText(
                        title: "Copy",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
