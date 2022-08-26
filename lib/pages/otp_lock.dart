import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kryptonia/backends/all_backends.dart';

import 'package:kryptonia/helpers/strings.dart';
import 'package:kryptonia/widgets/cust_button.dart';
import 'package:kryptonia/widgets/cust_prog_ind.dart';
import 'package:kryptonia/widgets/cust_text_field.dart';
import 'package:kryptonia/widgets/empty.dart';
import 'package:kryptonia/widgets/text_link.dart';
import 'package:kryptonia/widgets/trns_text.dart';
import 'package:loading_overlay/loading_overlay.dart';

class OTPLockScreen extends StatefulWidget {
  const OTPLockScreen({Key? key}) : super(key: key);

  @override
  _OTPLockScreenState createState() => _OTPLockScreenState();
}

class _OTPLockScreenState extends State<OTPLockScreen> {
  TextEditingController? _smsCtrl = TextEditingController();

  GlobalKey<FormState> _otpKey = GlobalKey();
  AllBackEnds _allBackEnds = AllBackEnds();

  int? _sms;

  @override
  void initState() {
    getOtpStatus();
    super.initState();
  }

  //! Send SM;
  String? _otpPhone;

  bool? _smsVerify = false;

  bool _loading = false;

  Future<Map<String, dynamic>>? _future;
  getOtpStatus() async {
    _future = _allBackEnds.otpStatusGet();
    Map? data = await _allBackEnds.otpStatusGet();

    intOtps(data);
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return FutureBuilder<Map<String, dynamic>?>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(body: CustProgIndicator());
          } else {
            Map<String, dynamic>? data = snapshot.data;

            _sms = data![PHONE + '_' + LOGIN];

            return Scaffold(
              body: LoadingOverlay(
                isLoading: _loading,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _otpKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: SingleChildScrollView(
                      child: Container(
                        height: med.height,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            EmptyWid(
                              title: 'OTP Required',
                              subtitle:
                                  'Further Authentication is required to proceed',
                              svg: 'otp_secure',
                              height: 150,
                            ),
                            SizedBox(height: 10),
                            _sms == 1
                                ? Column(
                                    children: [
                                      OTPWid(
                                        controller: _smsCtrl!,
                                        hintText: _allBackEnds.multiTranslation(
                                            context, ['SMS', 'OTP'])!,
                                        validator: _otpValidate,
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  )
                                : SizedBox.shrink(),
                            SizedBox(height: 20),
                            CustButton(
                              onTap: () => onTap(data),
                              title: 'Authenticate',
                            ),
                            SizedBox(height: 20),
                            TextLinkWid(
                              title: "Go Back",
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                              size: 20,
                              onTap: () => Navigator.pop(context, false),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }

  String? _otpValidate(value) {
    return _allBackEnds.validateOTPRegex(value, context);
  }

  intOtps(data) async {
    if (data[PHONE] != null && data[PHONE + '_' + LOGIN] == 1) {
      await _allBackEnds.initializeSMS();
      _otpPhone = _allBackEnds.decrypt(data[PHONE]);
      await _allBackEnds.sendSMSRepo(_otpPhone, context);
      _sms = data[PHONE + '_' + LOGIN];
    }
  }

  onTap(data) async {
    try {
      if (_otpKey.currentState!.validate()) {
        _otpKey.currentState!.save();
        setState(() {
          _loading = true;
        });
        await verifyOtp(data);
      }
    } catch (e) {
      print(e);
    }
  }

  verifyOtp(Map? data) async {
    if (_smsCtrl!.text.isNotEmpty) {
      _smsVerify = await _allBackEnds.verifiySMSRepo(
          _otpPhone!, _smsCtrl!.text, true, context);
    }

    if ((_sms == 1 && !_smsVerify!)) {
      _allBackEnds.showPopUp(context, TrnsText(title: "OTP Incorrect"), [
        CupertinoButton(
          child: TrnsText(title: "Cancel"),
          onPressed: () {
            intOtps(data);
            Navigator.pop(context);
          },
        ),
      ], [
        TextButton(
          child: TrnsText(title: "Cancel"),
          onPressed: () {
            intOtps(data);
            Navigator.pop(context);
          },
        ),
      ]);
      setState(() {
        _loading = false;
      });
      return false;
    } else {
      setState(() {
        _loading = false;
      });
      Navigator.pop(context, true);
      return true;
    }
  }
}

class OTPWid extends StatelessWidget {
  const OTPWid({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.validator,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return CustTextField(
      hintText: hintText,
      controller: controller,
      validator: validator,
      maxLength: 6,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }
}
