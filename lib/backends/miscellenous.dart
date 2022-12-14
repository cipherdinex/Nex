import 'dart:io';

import 'package:cron/cron.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_nullsafty/flutter_icons_nullsafty.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:kryptonia/backends/call_functions.dart';
import 'package:kryptonia/backends/crypto_apis.dart';
import 'package:kryptonia/backends/encrypt.dart';
import 'package:kryptonia/backends/erc_20_wallet.dart';
import 'package:kryptonia/backends/wallet_addresses.dart';
import 'package:kryptonia/helpers/colors.dart';
import 'package:kryptonia/helpers/strings.dart';
import 'package:kryptonia/widgets/cust_button.dart';
import 'package:kryptonia/widgets/pref_wid.dart';
import 'package:kryptonia/widgets/trns_text.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class BaseMiscRepo {
  Future<File?> cropImage(File imageFile);
  cronJob(Function function, int when);
  getUser(dataKey);
  getFinancials(dataKey);
  String getWallet(dataKey);
  getAppVersion();

  Future<Map> getAllBalances();
  Widget otpToggle(
    String title,
    bool _logOTP,
    bool _signOTP,
    Function(bool) _logOnChanged,
    Function(bool) _signOnChanged,
    Function()? onTap,
    context,
  );
  Future<bool> onWillPop(context);
}

class MiscRepo implements BaseMiscRepo {
  List rpcs = [
    eTHRPCURL,
    BSC_RPC_URL,
  ];
  List ids = [
    BTC,
    DOGE,
  ];

  EncryptApp _encryptApp = EncryptApp();
  ERC20WalletAd _erc20walletAd = ERC20WalletAd();
  WalletAd _walletAd = WalletAd();
  ApiRepo _apiRepo = ApiRepo();
  CallFunctions _callFunctions = CallFunctions();

  final cron = Cron();
  var userBox = Hive.box(USERS);

  @override
  Future<File?> cropImage(File imageFile) async {
    File? croppedFile;
    try {
      croppedFile = await ImageCropper.cropImage(
          sourcePath: imageFile.path,
          aspectRatioPresets: Platform.isAndroid
              ? [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9
                ]
              : [
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio5x3,
                  CropAspectRatioPreset.ratio5x4,
                  CropAspectRatioPreset.ratio7x5,
                  CropAspectRatioPreset.ratio16x9
                ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: accentColor,
              toolbarWidgetColor: white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            title: 'Cropper',
          ));

      return croppedFile;
    } catch (e) {
      print(e);
    }
    return croppedFile;
  }

  @override
  cronJob(Function function, int when) {
    function();

    cron.schedule(Schedule.parse('*/$when * * * *'), () async {
      function();
    });
  }

  @override
  getUser(dataKey) {
    var data = userBox.get(USER)[USER][dataKey];

    return data;
  }

  @override
  getFinancials(dataKey) {
    var data = userBox.get(USER)[FINANCIAL][dataKey];
    return data;
  }

  @override
  getWallet(dataKey) {
    var data = _encryptApp.appDecrypt(userBox.get(USER)[WALLET][dataKey]);
    return data;
  }

  Future<Map> getAllBalances() async {
    final Map balances = {};
    Map rates = {};
    List walletIds = [];
    var userBox = Hive.box(USERS);
    var crypD = Hive.box(CRYPTO_DATAS);

    await _apiRepo.getCryptoCarousel().then((value) {
      for (int i = 0; i < value.length; i++) {
        rates[value[i][SYMBOL]] = value[i][CURRENT_PRICE];
      }
      crypD.put(EX_RATES, rates);
    });
    String erKey = ERC20 + '_' + ADDRESS;
    var encryptedErc20 = userBox.get(USER)[WALLET][erKey];
    String data = _encryptApp.appDecrypt(encryptedErc20);

    for (String id in ids) {
      String walKey = id + '_' + WALLETID;
      var encryptedWallet = userBox.get(USER)[WALLET][walKey];
      String walletData = _encryptApp.appDecrypt(encryptedWallet);
      walletIds.add(walletData);
    }

    try {
      // BTC LTC DOGE BCH

      Map walletBalances = await _walletAd.getWalletBalance(walletIds);

      balances.addAll(walletBalances);

      // ETH BNB

      for (String rpc in rpcs) {
        for (var i = 0; i < 2; i++) {
          String unit = i == 0 ? ETH : BNB;

          await _erc20walletAd.clientsInit(rpc);
          String? ethBal = await _erc20walletAd.getEthBnbWalletBalance(data);
          balances[unit] = (double.parse(ethBal!));
        }
      }

      crypD.put(BALANCES, balances);
    } catch (e) {
      print(e);
    }

    return balances;
  }

  @override
  Widget otpToggle(
    String title,
    bool _logOTP,
    bool _signOTP,
    Function(bool) _logOnChanged,
    Function(bool) _signOnChanged,
    Function()? onTap,
    context,
  ) {
    return Column(
      children: [
        PreferenceWid(
          icon: AntDesign.lock,
          title: "Login",
          subtitle: ["Require {Arg} OTP for login"],
          mArgs: {'Arg': _callFunctions.translation(context, title)!},
          trailing: _callFunctions.toggleSwitch(
            _logOTP,
            context,
            _logOnChanged,
          ),
        ),
        PreferenceWid(
          icon: CupertinoIcons.signature,
          title: "Transaction Signing",
          subtitle: ["Require {Arg} OTP to authenticate transactions"],
          mArgs: {'Arg': _callFunctions.translation(context, title)!},
          trailing: _callFunctions.toggleSwitch(
            _signOTP,
            context,
            _signOnChanged,
          ),
        ),
        SizedBox(height: 20),
        CustButton(
          onTap: onTap,
          title: 'Deactivate',
          color: red,
        ),
      ],
    );
  }

  @override
  Future<bool> onWillPop(context) async {
    _callFunctions.showPopUp(
      context,
      TrnsText(title: "Are you sure you want to go back?"),
      [
        CupertinoButton(
          child: TrnsText(title: "Yes"),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
        CupertinoButton(
          child: TrnsText(title: "No"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
      [
        TextButton(
          child: TrnsText(title: "Yes"),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: TrnsText(title: "No"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
    return true;
  }

  @override
  Future<String> getAppVersion() async {
    String appVersion;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    appVersion = "$version.$buildNumber";
    return appVersion;
  }
}
