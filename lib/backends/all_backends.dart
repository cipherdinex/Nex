import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kryptonia/backends/crypto_apis.dart';
import 'package:kryptonia/backends/call_functions.dart';
import 'package:kryptonia/backends/device_info.dart';
import 'package:kryptonia/backends/encrypt.dart';
import 'package:kryptonia/backends/erc_20_wallet.dart';
import 'package:kryptonia/backends/miscellenous.dart';
import 'package:kryptonia/backends/mysql/sql_activities.dart';
import 'package:kryptonia/backends/mysql/user_fxn.dart';
import 'package:kryptonia/backends/notifications_repo.dart';
import 'package:kryptonia/backends/otp_repo.dart';
import 'package:kryptonia/backends/payments.dart';
import 'package:kryptonia/backends/swap_repo.dart';
import 'package:kryptonia/backends/validators.dart';
import 'package:kryptonia/backends/wallet_addresses.dart';
import 'package:kryptonia/utils/biometrics.dart';
import 'package:kryptonia/utils/time_convert_fxn.dart';

class AllBackEnds {
  CallFunctions _callFunctions = CallFunctions();
  ApiRepo _apiRepo = ApiRepo();
  TimeConvert _timeConvert = TimeConvert();
  WalletAd _walletAd = WalletAd();
  PaymentRepo _paymentRepo = PaymentRepo();
  ValidatorsFxn _validatorsFxn = ValidatorsFxn();
  ERC20WalletAd _erc20walletAd = ERC20WalletAd();
  BiometricsFxn _biometricsFxn = BiometricsFxn();
  MiscRepo _miscRepo = MiscRepo();
  DeviceInfoFxn _deviceInfoFxn = DeviceInfoFxn();
  EncryptApp _encryptApp = EncryptApp();
  SwapRepo _swapRepo = SwapRepo();
  OTPRepo _otpRepo = OTPRepo();

  UserSql _userSql = UserSql();
  ActivitiesSql _activitiesSql = ActivitiesSql();

  NotificationsRepo _notificationsRepo = NotificationsRepo();

  //!CallFunctions

  launchUrlFxn(url) => _callFunctions.launchUrlFxn(url);

  showSnacky(String msg, bool isSuccess, BuildContext context,
          {Map<String, String>? args, String extra2 = ''}) =>
      _callFunctions.showSnacky(msg, isSuccess, context,
          args: args, extra2: extra2);

  toggleSwitch(
    bool value,
    context,
    Function(bool) onChanged,
  ) =>
      _callFunctions.toggleSwitch(
        value,
        context,
        onChanged,
      );

  showPicker(
    context, {
    List<dynamic>? children,
    Function(int?)? onSelectedItemChanged,
    Function(String?)? onChanged,
    bool hasTrns = true,
  }) =>
      _callFunctions.showPicker(
        context,
        children: children,
        onSelectedItemChanged: onSelectedItemChanged,
        onChanged: onChanged,
        hasTrns: hasTrns,
      );

  showPopUp(
    BuildContext context,
    Widget content,
    List<CupertinoButton> iosActions,
    List<TextButton> androidActions, {
    IconData? icon,
    String? msg,
    Color? color,
    bool barrierDismissible = true,
  }) =>
      _callFunctions.showPopUp(
        context,
        content,
        iosActions,
        androidActions,
        barrierDismissible: barrierDismissible,
      );

  showModalBarAction(
    BuildContext context,
    Widget child,
    List<CupertinoActionSheetAction> action,
  ) =>
      _callFunctions.showModalBarAction(
        context,
        child,
        action,
      );

  showModalBar(
    BuildContext context,
    Widget content, {
    bool? isDismissible,
  }) =>
      _callFunctions.showModalBar(
        context,
        content,
        isDismissible: isDismissible,
      );

  translation(dynamic context, String key, {Map<String, String>? args}) =>
      _callFunctions.translation(context, key, args: args);

  String? multiTranslation(context, List<String> keys,
          {Map<String, String>? args}) =>
      _callFunctions.multiTranslation(context, keys, args: args);

  //! Api Repo
  Future<List>? getAllDatas() => _apiRepo.getAllDatas();
  getCryptoMovers() => _apiRepo.getCryptoMovers();
  getCryptoNews() => _apiRepo.getCryptoNews();

  getCryptoCarousel() => _apiRepo.getCryptoCarousel();

  //! Time Convert
  convertToTimeAgo(int date, {String? locale}) =>
      _timeConvert.convertToTimeAgo(date, locale: locale);

  //! Biometrics
  Future<bool?> checkAvailability() => _biometricsFxn.checkAvailability();
  Future<String?> getAvailableBiometric() =>
      _biometricsFxn.getAvailableBiometric();
  Future<bool?> authenticate() => _biometricsFxn.authenticate();

  //! WalletAd
  createWallet() => _walletAd.createWallet();
  getWalletHistory(String walletId) => _walletAd.getWalletHistory(walletId);
  Future<Map> getWalletBalance(List<dynamic> walletIds) =>
      _walletAd.getWalletBalance(walletIds);
  Future<Map> transferCoin(
          String walletId, String transferKey, String address, String amount) =>
      _walletAd.transferCoin(walletId, transferKey, address, amount);

  Future<String?> getFee(
          String walletId, String address, String amount, context) =>
      _walletAd.getFee(walletId, address, amount, context);
  //! ERC 20 Wallet Ads

  clientsInit(String unit) => _erc20walletAd.clientsInit(unit);

  createErcWallet() => _erc20walletAd.createErcWallet();

  Future<String?> getEthBnbWalletBalance(
    String privateKey,
  ) =>
      _erc20walletAd.getEthBnbWalletBalance(
        privateKey,
      );

  Future<Map> transferEthBnbToken(
          String privateKey, String receiverAdd, double amount, bool isEth) =>
      _erc20walletAd.transferEthBnbToken(
        privateKey,
        receiverAdd,
        amount,
        isEth,
      );

  Future<List> getAccTokenHistory(String address, String unit, bool isEth) =>
      _erc20walletAd.getAccTokenHistory(address, unit, isEth);

  Future<String?> getGasBal(String sender, String receiver, double amount) =>
      _erc20walletAd.getGasBal(sender, receiver, amount);

  //! Payment
//?
  Future<bool> storeTrxnMap(String amount, bool isBuy, String paymentMethod,
          String reference, String toGet, context) =>
      _paymentRepo.storeTrxnMap(
          amount, isBuy, paymentMethod, reference, toGet, context);
  //? Coinbase
  coinbasePayment(String coin, String amount) =>
      _paymentRepo.coinbasePayment(coin, amount);

  //? Now Payment
  nowPayment(String coin, String amount) =>
      _paymentRepo.nowPayment(coin, amount);

  //? (Braintree) Paypal
  braintreePayment(String amount, String displayName, String countryCode, toGet,
          context) =>
      _paymentRepo.braintreePayment(
          amount, displayName, countryCode, toGet, context);

  //? Paystack
  initPaystack() => _paymentRepo.initPaystack();
  paystackPayment(context, String email, double amount, toGet) =>
      _paymentRepo.paystackPayment(context, email, amount, toGet);

  //? RazorPay
  initRazorpay(Function _handlePaymentSuccess, Function _handlePaymentError,
          Function _handleExternalWallet) =>
      _paymentRepo.initRazorpay(
          _handlePaymentSuccess, _handlePaymentError, _handleExternalWallet);
  razorpayPayment(double amount, String phone, String email) =>
      _paymentRepo.razorpayPayment(amount, phone, email);
  disposeRazorpay() => _paymentRepo.disposeRazorpay();

  //! Validators
  String? validateAmount(bool hasBal, String value, double balance,
          double minimum, double maximum, context, {bool notNull = true}) =>
      _validatorsFxn.validateAmount(
          hasBal, value, balance, minimum, maximum, context,
          notNull: notNull);

  //?

  String? validateName(String? value, context) =>
      _validatorsFxn.validateName(value, context);

  //?

  String? validateEmpty(String? value, String? title, context) =>
      _validatorsFxn.validateEmpty(value, title, context);

  //?

  String? validateOTPRegex(String? value, context) =>
      _validatorsFxn.validateOTPRegex(value, context);

  //?

  String? validateEmail(String? value, context) =>
      _validatorsFxn.validateEmail(value, context);

  //?

  String? validatePassword(String? value, context) =>
      _validatorsFxn.validatePassword(value, context);

  //?

  String? validateCPassword(String? value, String? password, context) =>
      _validatorsFxn.validateCPassword(value, password, context);

  //?

  String? validateErc20Address(String? value, context) =>
      _validatorsFxn.ethAddressValidator(value, context);
  //?

  String? validateBTCAdd(String? value, context) =>
      _validatorsFxn.btcAddressValidator(value, context);

  //?

  String? validateLTCAdd(String? value, context) =>
      _validatorsFxn.litecoinAddressValidator(value, context);

  //?
  String? validateDOGEAdd(String? value, context) =>
      _validatorsFxn.dogeAddressValidator(value, context);

  //! Misc
  Future<File?> cropImage(imageFile) => _miscRepo.cropImage(imageFile);
  cronJob(Function function, int when) => _miscRepo.cronJob(function, when);
  getUser(dataKey) => _miscRepo.getUser(dataKey);
  getWallet(dataKey) => _miscRepo.getWallet(dataKey);
  getFinancials(dataKey) => _miscRepo.getFinancials(dataKey);
  getAppVersion() => _miscRepo.getAppVersion();
  getAllBalances() => _miscRepo.getAllBalances();
  Future<bool> onWillPop(context) => _miscRepo.onWillPop(context);

  otpToggle(
    String title,
    bool _logOTP,
    bool _signOTP,
    Function(bool) _logOnChanged,
    Function(bool) _signOnChanged,
    Function()? onTap,
    context,
  ) =>
      _miscRepo.otpToggle(title, _logOTP, _signOTP, _logOnChanged,
          _signOnChanged, onTap, context);

  //! Device & IP
  getDeviceIp() => _deviceInfoFxn.getDeviceIp();

  //! Encrypt Decrypt

  decrypt(String encrypted) => _encryptApp.appDecrypt(encrypted);
  encrypt(String data) => _encryptApp.appEncrypt(data);

  //! Swap Repo
  Future<double> getEstimate(from, to, amount) =>
      _swapRepo.getEstimate(from, to, amount);

  Future<Map> swapCoin(String from, String to, String amount) =>
      _swapRepo.swapCoin(from, to, amount);
  //! MYSQL

  //! UserSql

  //?
  sqlGetUser(String email) => _userSql.getUser(email);

  Future<bool> sqlSignIn(email, password, context) =>
      _userSql.signIn(email, password, context);

  //?
  Future<Map> sqlSignUp(email, password, firstName, lastName, phone, country,
          refBy, context) =>
      _userSql.signUp(
          email, password, firstName, lastName, phone, country, refBy, context);
//?
  Future<bool> sqlSignOut(context) => _userSql.signOut(context);
  //?
  Future<bool> sqlforgetPassword(email, context) =>
      _userSql.forgetPassword(email, context);

  //?
  sqlchangePassword(String uid, String password, String newPass, context) =>
      _userSql.changePassword(uid, password, newPass, context);

  //?
  sqlupdateProfile(data, String slug, context) =>
      _userSql.updateProfile(data, slug, context);

//?
  updateProfilePic(String imgPath) => _userSql.updateProfilePic(imgPath);

//?
  Future<bool> kycVerification(Map<String, String?> data, context) =>
      _userSql.kycVerification(data, context);
  //?
  Future<List?> sqlgetTransactions() => _userSql.getTransactions();

  //?
  sqlstoreTransaction(data, context) =>
      _userSql.storeTransaction(data, context);

  //?

  Future<bool?> requestRefPayout(context) => _userSql.requestRefPayout(context);

  //! SQL Activities

  storeUserActivitiesSql(int type) =>
      _activitiesSql.storeUserActivitiesSql(type);
  Future<List> getUserActivitiesSql() => _activitiesSql.getUserActivitiesSql();
  Future<List> getUserDeviceActivitiesSql() =>
      _activitiesSql.getUserDeviceActivitiesSql();
  Future<List> getNotificationsSql() => _activitiesSql.getNotificationsSql();

  Future<int> getUserKycStatusSql() => _activitiesSql.getUserKycStatusSql();

//! OTP Repo

  //?
  initializeSMS() => _otpRepo.initializeSMS();

  //?

  Future<Map<String, dynamic>>? otpStatusGet() => _otpRepo.otpStatusGet();

//?

  otpCheckFxn(Function fxn, context) => _otpRepo.otpCheckFxn(fxn, context);

  //?
  Future<bool?> sendSMSRepo(phone, context) =>
      _otpRepo.sendSMSRepo(phone, context);

  //?
  Future<bool?> verifiySMSRepo(
          String phone, String code, bool isLock, context) =>
      _otpRepo.verifiySMSRepo(phone, code, isLock, context);

  //?
  Future<bool?> sendMailOTP(String email, context) =>
      _otpRepo.sendMailOTP(email, context);

  Future<bool?> verifyMailOTP(
          String email, String code, bool isLock, context) =>
      _otpRepo.verifyMailOTP(email, code, isLock, context);

  //?
  Future<bool?> updateOTPOption(
          String field, String option, int value, context) =>
      _otpRepo.updateOTPOption(field, option, value, context);

  //?
  Future<bool?> activateDeactivateOTP(String field, value, context) =>
      _otpRepo.activateDeactivateOTP(field, value, context);

  //! Notifications
  getnStoreToken(Function(String)? userStoreToken) =>
      _notificationsRepo.getnStoreToken(userStoreToken);

  //?
  subscribeToTopics() => _notificationsRepo.subscribeToTopics();

  //?

  unSubscribeToTopics() => _notificationsRepo.unSubscribeToTopics();

  //?

  streamEvents() => _notificationsRepo.streamEvents();

  //?

  backgroundMsg() => _notificationsRepo.backgroundMsg();

  //?

  requestNotification() => _notificationsRepo.requestPermission();
}
