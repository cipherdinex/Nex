import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/app_config.dart';
import 'package:kryptonia/helpers/strings.dart';
import 'package:kryptonia/widgets/cust_button.dart';
import 'package:kryptonia/widgets/cust_country.dart';
import 'package:kryptonia/widgets/cust_prog_ind.dart';
import 'package:kryptonia/widgets/cust_text_field.dart';
import 'package:kryptonia/widgets/k_header.dart';
import 'package:kryptonia/widgets/trns_m_text.dart';
import 'package:kryptonia/widgets/trns_text.dart';

class Phone2FA extends StatefulWidget {
  const Phone2FA({Key? key}) : super(key: key);

  @override
  _Phone2FAState createState() => _Phone2FAState();
}

class _Phone2FAState extends State<Phone2FA> {
  AllBackEnds _allBackEnds = AllBackEnds();

  int _index = 0;

  TextEditingController _phoneCtrl = TextEditingController();
  TextEditingController _otpCtrl = TextEditingController();

  String numberPrefix = DEFAULT_COUNTRY_PREFIX;

  @override
  void initState() {
    _allBackEnds.initializeSMS();
    super.initState();
  }

  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
        future: _allBackEnds.otpStatusGet(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(body: CustProgIndicator());
          } else {
            Map<String, dynamic>? data = snapshot.data;
            bool _hasPhone = data![PHONE] == null ? false : true;

            return KHeader(
              hasWillPop: !_hasPhone,
              isLoading: _loading,
              title: _hasPhone
                  ? ["Manage", "SMS", "OTP"]
                  : ['Activate', 'SMS', 'OTP'],
              body: Container(
                width: double.infinity,
                child: childWid(data),
              ),
            );
          }
        });
  }

  Widget childWid(Map? data) {
    bool _hasPhone = data![PHONE] == null ? false : true;

    bool _loginOTP = data[PHONE + '_' + LOGIN] == 0 ? false : true;
    bool _trxnSignOTP = data[PHONE + '_' + TRXN_SIGNING] == 0 ? false : true;

    return _hasPhone
        ? _allBackEnds.otpToggle(
            "SMS",
            _loginOTP,
            _trxnSignOTP,
            (bool val) async {
              updateFxn(val, _loginOTP, LOGIN);
            },
            (bool val) {
              updateFxn(val, _trxnSignOTP, TRXN_SIGNING);
            },
            () => deactivateFxn(data[PHONE]),
            context,
          )
        : IndexedStack(
            index: _index,
            children: [
              stackOne(),
              stackTwo(),
            ],
          );
  }

  updateFxn(bool val, bool field, String option) async {
    setState(
      () {
        _loading = true;
        field = val;
      },
    );
    int v = val ? 1 : 0;

    await _allBackEnds.updateOTPOption(PHONE, option, v, context);
    setState(
      () {
        _loading = false;
      },
    );
  }

  deactivateFxn(encryptedPhone) {
    try {
      String phone = _allBackEnds.decrypt(encryptedPhone);
      sendVerifyFxn(phone);
    } catch (e) {
      print(e);
    }
  }

  Widget stackOne() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/svg/sms_otp.svg",
          height: 300,
        ),
        MultiTrnsText(
          title: ["Enable", "SMS", "OTP"],
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        TrnsText(
          title:
              "Two-Factor authentication keeps your wallet safer by using both your password and an authentication app to sign in.",
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        CustButton(
          onTap: () {
            setState(() {
              _index++;
            });
          },
          title: "Get Started",
        ),
      ],
    );
  }

  Widget stackTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 30),
        TrnsText(
          title:
              "Enter Your Phone Number, a verification SMS will be sent to the provided number.",
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        CustTextField(
          hintText: "41-2345-6789",
          keyboardType: TextInputType.phone,
          controller: _phoneCtrl,
          prefixIcon: CustCountryPicker(
            onChanged: (val) {
              setState(() {
                numberPrefix = val.dialCode!;
              });
            },
          ),
        ),
        SizedBox(height: 10),
        CustButton(
          onTap: () async {
            try {
              if (_phoneCtrl.text.trim().isNotEmpty) {
                sendVerifyFxn(numberPrefix + _phoneCtrl.text);
              } else {
                _allBackEnds.showSnacky("Phone Field is Blank", false, context);
              }
            } catch (e) {
              print(e);
            }
          },
          title: "Authenticate",
        ),
      ],
    );
  }

  sendVerifyFxn(String phone) async {
    await _allBackEnds.sendSMSRepo(phone, context).then((value) async {
      if (value!) {
        setState(() {
          _loading = true;
        });
        await _allBackEnds.showPopUp(
          context,
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TrnsText(
                title:
                    "A 6-Digit SMS OTP has been sent to {Arg}, please get code and input below",
                args: {'Arg': phone},
              ),
              SizedBox(height: 10),
              Material(
                child: CustTextField(
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  hintText: "123456",
                  keyboardType: TextInputType.phone,
                  controller: _otpCtrl,
                ),
              ),
            ],
          ),
          [
            CupertinoButton(
              child: TrnsText(title: "Ok"),
              onPressed: () async {
                await _allBackEnds
                    .verifiySMSRepo(
                        phone.trim(), _otpCtrl.text.trim(), false, context)
                    .then((value) {
                  if (value!) {
                    Navigator.popUntil(
                        context, ModalRoute.withName('/two-fa/'));
                  }
                });
              },
            ),
            CupertinoButton(
              child: TrnsText(title: "Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
          [
            TextButton(
              child: TrnsText(title: "Ok"),
              onPressed: () async {
                await _allBackEnds
                    .verifiySMSRepo(numberPrefix + phone.trim(),
                        _otpCtrl.text.trim(), false, context)
                    .then((value) {
                  if (value!) {
                    Navigator.popUntil(
                        context, ModalRoute.withName('/two-fa/'));

                    return true;
                  }
                });
              },
            ),
            TextButton(
              child: TrnsText(title: "Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
          barrierDismissible: false,
        );

        setState(() {
          _loading = false;
        });
      }
    }).catchError((e) {
      print(e);
    });
  }
}
