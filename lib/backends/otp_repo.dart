import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kryptonia/backends/call_functions.dart';
import 'package:kryptonia/backends/encrypt.dart';
import 'package:kryptonia/helpers/strings.dart';
import 'package:twilio_phone_verify/twilio_phone_verify.dart';
import 'package:http/http.dart' as http;

abstract class BaseOTpRepo {
  initializeSMS();
  Future<bool?> sendSMSRepo(String phone, context);
  Future<Map<String, dynamic>>? otpStatusGet();
  Future<bool?> verifiySMSRepo(String phone, String code, bool isLock, context);
  Future<bool?> sendMailOTP(String email, context);
  Future<bool?> verifyMailOTP(String email, String code, bool isLock, context);
  Future<bool?> updateOTPOption(
      String field, String option, int value, context);
  Future<bool?> activateDeactivateOTP(String field, String value, context);
}

class OTPRepo implements BaseOTpRepo {
  CallFunctions _callFunctions = CallFunctions();
  EncryptApp _encryptApp = EncryptApp();

  TwilioPhoneVerify? _twilioPhoneVerify;

  String? url = dotenv.env['ENDPOINT_URL'];
  static String? username = dotenv.env['ENDPOINT_USERNAME'];
  static String? password = dotenv.env['ENDPOINT_PASSWORD'];
  static String base64encodedData =
      base64Encode(utf8.encode('$username:$password'));

  Map<String, String> header = {
    'Authorization': 'Basic ' + base64encodedData,
  };

  static var userBox = Hive.box(USERS);

  @override
  initializeSMS() {
    _twilioPhoneVerify = TwilioPhoneVerify(
      accountSid: dotenv.env['ACCOUNT_SID']!,
      authToken: dotenv.env['AUTH_TOKEN']!,
      serviceSid: dotenv.env['SERVICE_SID']!,
    );
  }

  @override
  Future<Map<String, dynamic>>? otpStatusGet() async {
    String uUid = userBox.get(USER)[USER][UID];

    try {
      var body = {
        UID: uUid,
      };

      http.Response response = await http.post(
        Uri.parse(url! + 'otp-get.php'),
        headers: header,
        body: body,
      );

      var resbody = json.decode(response.body);

      return resbody[OTPS];
    } catch (e) {
      print(e);
      return {};
    }
  }

  otpCheckFxn(Function fxn, context) async {
    Map? data = await otpStatusGet();

    int _emailLogin = data!.isEmpty ? 0 : data[EMAIL + '_' + LOGIN];
    int _phoneLogin = data.isEmpty ? 0 : data[PHONE + '_' + LOGIN];
    int _googleLogin = data.isEmpty ? 0 : data[GOOGLE + '_' + LOGIN];

    if (_emailLogin == 1 || _phoneLogin == 1 || _googleLogin == 1) {
      final result = await Navigator.pushNamed(
        context,
        '/otp-lock/',
      );
      if (result == true) {
        return fxn();
      }
    } else
      return fxn();
  }

  @override
  Future<bool?> sendSMSRepo(String phone, context) async {
    try {
      var twilioResponse = await _twilioPhoneVerify!.sendSmsCode(phone);

      bool status = twilioResponse.successful!;
      String msg = twilioResponse.errorMessage!;
      if (status) {
        _callFunctions.showSnacky("Success!", true, context);
        return true;
      } else {
        _callFunctions.showSnacky('Failed:', false, context);
        print(msg);
        return false;
      }
    } catch (e) {
      _callFunctions.showSnacky(DEFAULT_ERROR, false, context);
      print(e);
      return false;
    }
  }

  @override
  Future<bool?> verifiySMSRepo(
      String phone, String code, bool isLock, context) async {
    try {
      var twilioResponse =
          await _twilioPhoneVerify!.verifySmsCode(phone: phone, code: code);
      bool state = twilioResponse.successful!;
      String msg = twilioResponse.errorMessage!;
      if (state) {
        VerificationStatus? verificationStatus =
            twilioResponse.verification!.status;
        if (verificationStatus == VerificationStatus.approved) {
          if (!isLock) {
            await activateDeactivateOTP(PHONE, phone, context);
          }

          _callFunctions.showSnacky("Success!", true, context);

          return true;
        } else {
          _callFunctions.showSnacky('Invalid Code', false, context);
          return false;
        }
      } else {
        _callFunctions.showSnacky(msg, false, context);
        return false;
      }
    } catch (e) {
      _callFunctions.showSnacky(DEFAULT_ERROR, false, context);

      print(e);
      return false;
    }
  }

  @override
  Future<bool?> sendMailOTP(String email, context) async {
    try {
      print(url);

      var body = {
        EMAIL: email,
      };
      http.Response response = await http.post(
        Uri.parse(url! + 'email-otp-request.php'),
        headers: header,
        body: body,
      );

      var resbody = json.decode(response.body);
      print(resbody);

      if (resbody[STATUS] == FAILED) {
        _callFunctions.showSnacky(resbody[MESSAGE], false, context);
        return false;
      } else {
        _callFunctions.showSnacky(resbody[MESSAGE], true, context);

        return true;
      }
    } catch (e) {
      _callFunctions.showSnacky(DEFAULT_ERROR, false, context);

      print(e);
      return false;
    }
  }

  @override
  Future<bool?> verifyMailOTP(
      String email, String code, bool isLock, context) async {
    try {
      var body = {
        EMAIL: email,
        EMAIL_OTP: code,
      };
      http.Response response = await http.post(
        Uri.parse(url! + 'email-otp-verify.php'),
        headers: header,
        body: body,
      );

      var resbody = json.decode(response.body);
      if (resbody[STATUS] == FAILED) {
        _callFunctions.showSnacky(resbody[MESSAGE], false, context);
        return false;
      } else {
        print(resbody[MESSAGE]);

        if (!isLock) {
          await activateDeactivateOTP(EMAIL, email, context);
        }

        _callFunctions.showSnacky(resbody[MESSAGE], true, context);
        return true;
      }
    } catch (e) {
      _callFunctions.showSnacky(DEFAULT_ERROR, false, context);

      print(e);
      return false;
    }
  }

  @override
  Future<bool?> updateOTPOption(
      String field, String option, int value, context) async {
    String uUid = userBox.get(USER)[USER][UID];

    try {
      var body = {
        UID: uUid,
        'field': field,
        'option': option,
        'val': value.toString(),
      };
      http.Response response = await http.post(
        Uri.parse(url! + 'otp-options-set.php'),
        headers: header,
        body: body,
      );

      var resbody = json.decode(response.body);

      if (resbody[STATUS] == SUCCESS) {
        _callFunctions.showSnacky('2FA updated', true, context);

        return true;
      } else {
        _callFunctions.showSnacky(resbody[MESSAGE], false, context);
        return false;
      }
    } catch (e) {
      _callFunctions.showSnacky(DEFAULT_ERROR, false, context);

      print(e);
      return false;
    }
  }

  @override
  Future<bool?> activateDeactivateOTP(String field, value, context) async {
    String uUid = userBox.get(USER)[USER][UID];

    try {
      var body = {
        UID: uUid,
        'field': field,
        'val': _encryptApp.appEncrypt(value),
      };
      http.Response response = await http.post(
        Uri.parse(url! + 'otp-set.php'),
        headers: header,
        body: body,
      );

      var resbody = json.decode(response.body);

      if (resbody[STATUS] == SUCCESS) {
        _callFunctions.showSnacky(resbody[MESSAGE], true, context);

        print(resbody[MESSAGE]);

        return true;
      } else {
        _callFunctions.showSnacky('Failed updating OTP', false, context);
        return false;
      }
    } catch (e) {
      _callFunctions.showSnacky(DEFAULT_ERROR, false, context);

      print(e);
      return false;
    }
  }
}
