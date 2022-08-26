import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/colors.dart';
import 'package:kryptonia/helpers/strings.dart';
import 'package:kryptonia/widgets/address_qr_wid.dart';
import 'package:kryptonia/widgets/cust_button.dart';
import 'package:kryptonia/widgets/k_header.dart';
import 'package:kryptonia/widgets/large_text.dart';
import 'package:kryptonia/widgets/trns_text.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class BuySellCryptoScreen extends StatefulWidget {
  const BuySellCryptoScreen({Key? key}) : super(key: key);

  @override
  _BuySellCryptoScreenState createState() => _BuySellCryptoScreenState();
}

AllBackEnds _allBackEnds = AllBackEnds();
int _ind = 0;
String? _value = PAYSTACK;
int _sind = 0;
String? _svalue = BITCOIN;

int _jind = 0;
String? _jvalue = BANK;

class _BuySellCryptoScreenState extends State<BuySellCryptoScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    _allBackEnds.initPaystack();
    _allBackEnds.initRazorpay(
        _handlePaymentSuccess, _handlePaymentError, _handleExternalWallet);
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  _handlePaymentSuccess(PaymentSuccessResponse? response) async {
    String payId = response!.paymentId!;
    String toGet = Platform.isAndroid ? _svalue! : CRYPTOCURRENCIES[_sind];

    await _allBackEnds.storeUserActivitiesSql(4);
    await _allBackEnds.storeTrxnMap(
        _amount!, true, 'RazorPay', payId, toGet, context);
    _allBackEnds.showPopUp(
        context, TrnsText(title: "Success!", extra2: ' Reference ' + payId), [
      CupertinoButton(
        child: TrnsText(title: "Ok"),
        onPressed: () => Navigator.pop(context),
      ),
    ], [
      TextButton(
        child: TrnsText(title: "Ok"),
        onPressed: () => Navigator.pop(context),
      ),
    ]);
    print("sucess " + response.paymentId!);
    return true;
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    try {
      _allBackEnds.showSnacky(
        "ERROR:",
        false,
        context,
        extra2: ' ' + response.code.toString() + " - " + response.message!,
      );

      print("ERROR: " + response.code.toString() + " - " + response.message!);
    } catch (e) {
      print(e);
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("EXTERNAL_WALLET: " + response.walletName!);
  }

  @override
  void dispose() {
    _allBackEnds.disposeRazorpay();

    super.dispose();
  }

  String? _amount;

  TextEditingController _buyCtrl = TextEditingController()..text = "0";
  TextEditingController _sellCtrl = TextEditingController()..text = "0";

  static var crypD = Hive.box(CRYPTO_DATAS);
  var settingsBx = Hive.box(SETTINGS);
  var userBx = Hive.box(USERS);

  Map rates = crypD.get(EX_RATES);
  Map balances = crypD.get(BALANCES) ?? {};

  String currency() {
    return settingsBx.get(CURRENCY) ?? USD;
  }

  bool boolFrom = false;
  bool _isLoading = false;

  String? errorMsg = "";
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return KHeader(
      isLoading: _isLoading,
      title: ["Trade Crypto"],
      body: Container(
        height: med.height,
        child: Column(
          children: [
            TabBar(
              labelColor: Theme.of(context).textTheme.bodyText1!.color,
              unselectedLabelColor:
                  Theme.of(context).textTheme.bodyText1!.color,
              tabs: [
                Tab(
                    text: _allBackEnds
                        .multiTranslation(context, ['Buy', 'Coin'])),
                Tab(
                    text: _allBackEnds
                        .multiTranslation(context, ['Sell', 'Coin'])),
              ],
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  BuySellWid(
                    prefix: Text(
                      currency().toUpperCase(),
                    ),
                    msg: errorMsg,
                    onChanged: (String val) {
                      setState(() {
                        _amount = val;
                        numValidate(_amount, false);
                      });
                    },
                    onTap: () async {
                      if (errorMsg == "") {
                        try {
                          String payment = Platform.isAndroid
                              ? _value!
                              : PAYMENT_METHODS[_ind];
                          String toGet = Platform.isAndroid
                              ? _svalue!
                              : CRYPTOCURRENCIES[_sind];
                          getPaymentType(payment, toGet);
                        } catch (e) {
                          print(e);
                        }
                      }
                    },
                    controller: _buyCtrl,
                    suffixTap: () {
                      setState(() {
                        _buyCtrl.text =
                            (rates[USDT] * 100000).toStringAsFixed(2);
                        numValidate(_buyCtrl.text, false);
                      });
                    },
                    isBuy: true,
                  ),
                  BuySellWid(
                    prefix: InkWell(
                      onTap: () {
                        setState(() {
                          this.boolFrom = !this.boolFrom;
                        });
                      },
                      child: Text(getUnit()),
                    ),
                    msg: errorMsg,
                    onChanged: (String val) {
                      setState(() {
                        _amount = val;
                        numValidate(_amount, true);
                      });
                    },
                    onTap: () async {
                      if (errorMsg == "") {
                        try {
                          shootNowPayment(med);
                        } catch (e) {
                          print(e);
                        }
                      }
                    },
                    suffixTap: () {
                      setState(() {
                        _sellCtrl.text = getBalance();
                        numValidate(_sellCtrl.text, true);
                      });
                    },
                    isBuy: false,
                    controller: _sellCtrl,
                  ),
                ],
                controller: _tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getUnit() {
    String _fromUnit = Platform.isAndroid
        ? UNITS[CRYPTOCURRENCIES.indexOf(_svalue)]
        : UNITS[_sind];

    return (boolFrom ? _fromUnit : currency()).toUpperCase();
  }

  String getBalance() {
    String _fromUnit = Platform.isAndroid
        ? UNITS[CRYPTOCURRENCIES.indexOf(_svalue)]
        : UNITS[_sind];

    return boolFrom
        ? balances[_fromUnit].toStringAsFixed(4)
        : (balances[_fromUnit] * rates[_fromUnit]).toStringAsFixed(2);
  }

  String? numValidate(_amount, hasBalance) {
    errorMsg = _allBackEnds.validateAmount(
        hasBalance,
        _amount,
        double.parse(getBalance()),
        boolFrom ? (rates[USDT] * 0.001) : (rates[USDT] * 10),
        boolFrom ? (rates[USDT] * 100000) : (rates[USDT] * 100000000),
        context,
        notNull: true);
    return errorMsg;
  }

  getUserData(dataKey) {
    return _allBackEnds.getUser(dataKey);
  }

  getPaymentType(payment, toGet) async {
    switch (payment) {
      case PAYSTACK:
        return await _allBackEnds.paystackPayment(
            context, getUserData(EMAIL), double.parse(_buyCtrl.text), toGet);

      case RAZOR_PAY:
        return await _allBackEnds.razorpayPayment(double.parse(_buyCtrl.text),
            getUserData(PHONE), getUserData(EMAIL));

      case PAYPAL:
        return await _allBackEnds.braintreePayment(
            _buyCtrl.text,
            getUserData(FIRST_NAME) + " " + getUserData(LAST_NAME),
            "US",
            toGet,
            context);
      case BANK:
        return popBankPayment();
      default:
        return await _allBackEnds.paystackPayment(
            context, getUserData(EMAIL), double.parse(_buyCtrl.text), toGet);
    }
  }

  popBankPayment() {
    _allBackEnds.showPopUp(
        context,
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TrnsText(
              title: "Make Payment to the account below",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(height: 10),
            BankWidRow(title: "Bank Name", value: dotenv.env['APP_BANK_NAME']!),
            BankWidRow(
                title: "Account Name", value: dotenv.env['APP_BANK_ACC_NAME']!),
            BankWidRow(
                title: "Account Number",
                value: dotenv.env['APP_BANK_ACC_NUM']!),
          ],
        ),
        [
          CupertinoButton(
            child: TrnsText(title: "I've Paid"),
            onPressed: bankPaidFxn,
          ),
          CupertinoButton(
            child: TrnsText(title: "Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        [
          TextButton(
            child: TrnsText(title: "I've Paid"),
            onPressed: bankPaidFxn,
          ),
          TextButton(
            child: TrnsText(title: "Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
        barrierDismissible: false);
  }

  bankPaidFxn() async {
    String ref = randomString(8);

    String toGet = Platform.isAndroid ? _svalue! : CRYPTOCURRENCIES[_sind];

    await _allBackEnds.storeTrxnMap(
        _amount!, true, 'Bank', ref, toGet, context);

    Navigator.pop(context);

    _allBackEnds.showSnacky('Transaction Sent', true, context);
  }

  shootNowPayment(Size med) async {
    String coin = Platform.isAndroid
        ? UNITS[CRYPTOCURRENCIES.indexOf(_svalue)]
        : UNITS[_sind];
    Map datas;
    try {
      FocusScope.of(context).unfocus();

      String _fromUnit = Platform.isAndroid
          ? UNITS[CRYPTOCURRENCIES.indexOf(_svalue)]
          : UNITS[_sind];
      String coinVal = !boolFrom
          ? _sellCtrl.text
          : (double.parse(_sellCtrl.text) * rates[_fromUnit])
              .toStringAsFixed(2);

      datas = await _allBackEnds.nowPayment(coin, coinVal);
      print("e");
      _allBackEnds.showModalBar(
          context,
          Container(
            height: med.height * 0.8,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(height: 10),
                Column(
                  children: [
                    TrnsText(
                      title: "Send",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Text(
                      datas[AMOUNT] + " " + coin.toUpperCase(),
                      style: TextStyle(
                        fontSize: 25,
                        color: green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                AddressQrWid(address: datas[ADDRESS]),
                SizedBox(height: 10),
                CustButton(
                    onTap: () => makeCryptoPayment(
                        _fromUnit, datas[AMOUNT], datas[ADDRESS]),
                    title: "Approve Payment"),
                SizedBox(height: 5),
                CustButton(
                  onTap: () => Navigator.pop(context),
                  title: "Cancel",
                  color: red,
                ),
              ],
            ),
          ),
          isDismissible: false);
    } catch (e) {
      _allBackEnds.showSnacky(
          _allBackEnds.translation(context, DEFAULT_ERROR), false, context);
      print(e);
    }
  }

  makeCryptoPayment(unit, amount, address) async {
    setState(() {
      _isLoading = true;
    });

    try {
      //!

      String _unit = unit == ETH || unit == BNB || unit == USDT ? ERC20 : unit;

      var encryptedWallet = userBx.get(USER)[WALLETS][_unit][TRANSFERKEY];
      String tKey = _allBackEnds.decrypt(encryptedWallet);

      if (_unit != ERC20) {
        var encryptedWallet = userBx.get(USER)[WALLETS][_unit][WALLETID];
        String walletData = _allBackEnds.decrypt(encryptedWallet);
        await _allBackEnds
            .transferCoin(walletData, tKey, address, amount)
            .then((value) {
          if (value[STATUS] == false) {
            _allBackEnds.showSnacky(
                _allBackEnds.translation(context, DEFAULT_ERROR),
                false,
                context);
          } else {
            successMsg();
          }
        });
      } else {
        bool isEth = _unit == ETH ? true : false;

        await _allBackEnds.clientsInit(_unit);

        await _allBackEnds
            .transferEthBnbToken(tKey, address, amount, isEth)
            .then((value) {
          if (value[STATUS] == false) {
            _allBackEnds.showSnacky("Transaction failed", false, context);
          } else {
            successMsg();
          }
        });
      }
    } catch (e) {
      print(e);
      _allBackEnds.showSnacky(
          _allBackEnds.translation(context, DEFAULT_ERROR), false, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  successMsg() async {
    _allBackEnds.showPopUp(context, TrnsText(title: "Sell Request Placed"), [
      CupertinoButton(
        child: TrnsText(title: "Ok"),
        onPressed: () {
          Navigator.pop(context);
          _sellCtrl.clear();
        },
      ),
    ], [
      TextButton(
        child: TrnsText(title: "Ok"),
        onPressed: () {
          Navigator.pop(context);
          _sellCtrl.clear();
        },
      ),
    ]);
    String ref = randomString(8);

    String paymentMethod =
        Platform.isAndroid ? _jvalue! : PAYOUT_METHODS[_jind];
    String toGet = Platform.isAndroid ? _svalue! : CRYPTOCURRENCIES[_sind];

    await _allBackEnds.storeTrxnMap(
        _amount!, false, paymentMethod, ref, toGet, context);
  }
}

class BankWidRow extends StatelessWidget {
  const BankWidRow({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TrnsText(title: title),
        Text(value),
      ],
    );
  }
}

class BuySellWid extends StatelessWidget {
  const BuySellWid({
    Key? key,
    this.onChanged,
    this.onTap,
    this.suffixTap,
    this.controller,
    this.msg,
    required this.isBuy,
    required this.prefix,
  }) : super(key: key);

  final void Function()? onTap;
  final void Function()? suffixTap;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final String? msg;
  final bool isBuy;
  final Widget prefix;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LargeTextField(
          controller: controller,
          onChanged: onChanged,
          prefix: prefix,
          suffixTap: suffixTap,
        ),
        Text(
          msg!,
          style: TextStyle(
            fontSize: 16,
            color: red,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TrnsText(
                title: isBuy ? "Payment Method" : "To Sell",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        BSCardTile(
          tradeType: isBuy ? 0 : 1,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TrnsText(
                title: isBuy ? "To Buy" : "Receiving Method",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        BSCardTile(
          tradeType: isBuy ? 1 : 2,
        ),
        if (!isBuy)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TrnsText(
              title:
                  "Ensure you have filled in payment details for the method choosen.",
            ),
          ),
        CustButton(
          onTap: onTap,
          title: "Next",
        ),
      ],
    );
  }
}

class BSCardTile extends StatefulWidget {
  const BSCardTile({
    Key? key,
    required this.tradeType,
  }) : super(key: key);

  final int tradeType;

  @override
  _BSCardTileState createState() => _BSCardTileState();
}

class _BSCardTileState extends State<BSCardTile> {
  @override
  Widget build(BuildContext context) {
    String _val = PAYMENT_METHODS[_ind];
    String _sval = CRYPTOCURRENCIES[_sind];
    String _jval = PAYOUT_METHODS[_jind];
    return InkWell(
      onTap: () {
        _allBackEnds.showPicker(
          context,
          children: widget.tradeType == 0
              ? PAYMENT_METHODS
              : widget.tradeType == 1
                  ? CRYPTOCURRENCIES
                  : PAYOUT_METHODS,
          onChanged: (String? val) {
            tradeSwitchAndroid(widget.tradeType, val);
          },
          onSelectedItemChanged: (int? index) {
            tradeSwitchiOS(widget.tradeType, index);
          },
          hasTrns: false,
        );
      },
      child: Card(
        elevation: 3,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListTile(
          leading: widget.tradeType == 0
              ? Image.asset(
                  PAYMENT_MAP[Platform.isAndroid ? _value! : _val]![IMAGE]!,
                  height: 30,
                  fit: BoxFit.cover,
                )
              : widget.tradeType == 1
                  ? CircleAvatar(
                      child: SvgPicture.asset(
                          "assets/svg/${Platform.isAndroid ? _svalue : _sval}.svg"),
                    )
                  : Image.asset(
                      PAYOUT_MAP[Platform.isAndroid ? _jvalue! : _jval]![
                          IMAGE]!,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
          title: widget.tradeType == 0
              ? Text(Platform.isAndroid
                  ? _value!.capitalize()!
                  : _val.capitalize()!)
              : widget.tradeType == 1
                  ? Text(
                      Platform.isAndroid
                          ? UNITS[CRYPTOCURRENCIES.indexOf(_svalue)]
                              .toUpperCase()
                          : UNITS[_sind].toUpperCase(),
                    )
                  : Text(Platform.isAndroid
                      ? _jvalue!.capitalize()!
                      : _jval.capitalize()!),
          subtitle: widget.tradeType == 0 || widget.tradeType == 2
              ? null
              : Platform.isAndroid
                  ? Text(_svalue.capitalize()!)
                  : Text(
                      _sval.capitalize()!,
                    ),
          trailing: Icon(
            CupertinoIcons.forward,
            size: 15,
          ),
        ),
      ),
    );
  }

  tradeSwitchAndroid(int type, val) {
    switch (type) {
      case 0:
        setState(() {
          _value = val!;
        });

        break;
      case 1:
        setState(() {
          _svalue = val!;
        });

        break;
      case 2:
        setState(() {
          _jvalue = val!;
        });

        break;
      default:
    }
    Navigator.pop(context);
  }

  tradeSwitchiOS(int type, index) {
    switch (type) {
      case 0:
        setState(() {
          _ind = index!;
        });
        break;
      case 1:
        setState(() {
          _sind = index!;
        });

        break;
      case 2:
        setState(() {
          _jind = index!;
        });

        break;
      default:
    }
  }
}
