import 'dart:convert';
import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_nullsafty/flutter_icons_nullsafty.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kryptonia/backends/all_backends.dart';

import 'package:kryptonia/helpers/decimals.dart';

import 'package:kryptonia/widgets/cust_button.dart';
import 'package:kryptonia/widgets/cust_container.dart';
import 'package:kryptonia/widgets/cust_text_field.dart';
import 'package:kryptonia/widgets/k_header.dart';
import 'package:kryptonia/helpers/strings.dart';
import 'package:kryptonia/widgets/trns_text.dart';

class SendCryptoScreen extends StatefulWidget {
  const SendCryptoScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SendCryptoScreenState createState() => _SendCryptoScreenState();
}

class _SendCryptoScreenState extends State<SendCryptoScreen> {
  AllBackEnds _allBackEnds = AllBackEnds();

  String? address, amount;

  TextEditingController _addCtrl = TextEditingController();

  var settingsBx = Hive.box(SETTINGS);
  var userBox = Hive.box(USERS);

  static var crypD = Hive.box(CRYPTO_DATAS);

  Map rates = crypD.get(EX_RATES) ?? {};

  String currency() {
    return settingsBx.get(CURRENCY) ?? "usd";
  }

  int _ind = 0;
  String _value = BITCOIN;
  bool boolFrom = false;

  Map balances = crypD.get(BALANCES) ?? {};

  GlobalKey<FormState> _sendCoinKey = GlobalKey();
  TextEditingController _amountCtrl = TextEditingController()..text = "0";

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return KHeader(
      title: ["Send"],
      extra2: " " + getUnit().toUpperCase(),
      body: Container(
        height: med.height * 0.8,
        child: Form(
          key: _sendCoinKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SendWidList(
                    onTap: getCryptoCurrency,
                    svg: getSvg(),
                    unit: getUnit(),
                    cryptoBalance: cryptoBalance(),
                    fiatBalance: fiatBalance(),
                  ),
                  SizedBox(height: 10),
                  CustTextField(
                    validator: addressValidator,
                    controller: _addCtrl,
                    enabled: true,
                    onChanged: (String? val) {
                      setState(() {
                        address = val;
                      });
                    },
                    hintTrns: true,
                    hintText: "Recipient Address",
                    suffix: InkWell(
                      onTap: () {
                        setState(() {
                          FlutterClipboard.paste().then(
                            (value) {
                              _addCtrl.text = value;
                            },
                          );
                        });
                      },
                      child: TrnsText(title: 'Paste'),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () async {
                        final result = await Navigator.pushNamed(
                            context, '/address-scanner/');
                        setState(() {
                          address = result as String;
                          _addCtrl.text = result;
                        });
                      },
                      icon: Icon(AntDesign.scan1),
                    ),
                  ),
                  SizedBox(height: 10),
                  CustTextField(
                    controller: _amountCtrl,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [DecimalTextInputFormatter()],
                    validator: numValidate,
                    enabled: true,
                    onChanged: (String? val) {
                      setState(() {
                        amount = val;
                      });
                    },
                    hintText: getUnit().toUpperCase() +
                        ' ' +
                        _allBackEnds.translation(context, "Amount"),
                    suffix: InkWell(
                      onTap: suffixTap,
                      child: TrnsText(title: 'Max'),
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          this.boolFrom = !this.boolFrom;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          (boolFrom ? getUnit() : currency()).toUpperCase(),
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color!
                                  .withOpacity(0.6)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              CustButton(
                  onTap: () async {
                    String? gas;
                    if (_sendCoinKey.currentState!.validate()) {
                      try {
                        if (getUnit() == ETH || getUnit() == BNB) {
                          await _allBackEnds.clientsInit(getUnit());

                          gas = await _allBackEnds.getGasBal(getAddress(),
                              _addCtrl.text, double.parse(getAmountCrypto()));
                        } else {
                          gas = await _allBackEnds.getFee(getWalletId(),
                              _addCtrl.text, getAmountCrypto(), context);
                        }

                        _sendCoinKey.currentState!.save();
                        Map data = {
                          FROM: getAddress(),
                          TO: _addCtrl.text.trim(),
                          AMOUNT: getAmountCrypto(),
                          GAS_FEE: gas!,
                          UNIT: getUnit(),
                          CURRENCY: currency(),
                          NAME: getSvg(),
                          RATE: rates[getUnit()] ?? 0,
                        };
                        String newData = jsonEncode(data);
                        Navigator.pushNamed(context, '/send-detail/$newData/');
                      } catch (e) {
                        _allBackEnds.showSnacky(DEFAULT_ERROR, false, context);

                        print(e);
                      }
                    }
                  },
                  title: "Send")
            ],
          ),
        ),
      ),
    );
  }

  String getAmountCrypto() {
    return boolFrom
        ? _amountCtrl.text
        : (double.parse(_amountCtrl.text) / (rates[getUnit()] ?? 1.0))
            .toStringAsFixed(4);
  }

  suffixTap() {
    setState(() {
      _amountCtrl.text = getBalance();
      amount = getBalance();
    });
  }

  String getBalance() {
    String _unit = getUnit();
    return boolFrom
        ? (balances[_unit]).toStringAsFixed(4)
        : ((balances[_unit] * rates[_unit]) ?? 0).toStringAsFixed(2);
  }

  String? numValidate(_amount) {
    return _allBackEnds.validateAmount(
        true,
        _amount,
        double.parse(getBalance()),
        boolFrom ? ((rates[USDT] ?? 0) * 0.00001) : ((rates[USDT] ?? 0.0) * 10),
        boolFrom
            ? ((rates[USDT] ?? 0.0) * 100000)
            : ((rates[USDT] ?? 0.0) * 100000000),
        context,
        notNull: true);
  }

  String? addressValidator(_address) {
    switch (getUnit()) {
      case BTC:
        return _allBackEnds.validateBTCAdd(_address, context);

      case DOGE:
        return _allBackEnds.validateDOGEAdd(_address, context);

      default:
        return _allBackEnds.validateErc20Address(_address, context);
    }
  }

  String getSvg() {
    return Platform.isIOS ? CRYPTOCURRENCIES[_ind] : _value;
  }

  String getUnit() {
    return Platform.isAndroid
        ? UNITS[CRYPTOCURRENCIES.indexOf(_value)]
        : UNITS[_ind];
  }

  String fiatBalance() {
    return currency().toUpperCase() +
        " " +
        (rates[getUnit()] ?? 0.0 * balances[getUnit()]).toStringAsFixed(2);
  }

  String cryptoBalance() {
    return balances.isNotEmpty ? balances[getUnit()].toStringAsFixed(4) : '0.0';
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

  String getAddress() {
    String unit = getUnit() == ETH || getUnit() == BNB || getUnit() == USDT
        ? ERC20
        : getUnit();
    var encryptedWallet = userBox.get(USER)[WALLET][unit + '_' + ADDRESS];
    String address = _allBackEnds.decrypt(encryptedWallet);

    return address;
  }

  String getWalletId() {
    var encryptedWallet = userBox.get(USER)[WALLET][getUnit() + '_' + WALLETID];
    String walletId = _allBackEnds.decrypt(encryptedWallet);

    return walletId;
  }
}

class SendWidList extends StatelessWidget {
  const SendWidList({
    Key? key,
    required this.onTap,
    required this.cryptoBalance,
    required this.fiatBalance,
    required this.svg,
    required this.unit,
  }) : super(key: key);

  final void Function() onTap;
  final String svg;
  final String fiatBalance;
  final String cryptoBalance;
  final String unit;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CustContainer(
        height: 70,
        child: Center(
          child: ListTile(
            leading: CircleAvatar(
              child: SvgPicture.asset("assets/svg/$svg.svg"),
            ),
            title: TrnsText(
              title: "{Arg} Wallet",
              args: {"Arg": unit.toUpperCase()},
              style: TextStyle(fontSize: 14),
            ),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  fiatBalance,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Text(
                  cryptoBalance + " " + unit.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .color!
                        .withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
