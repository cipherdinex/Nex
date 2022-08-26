import 'package:flutter/material.dart';
import 'package:flutter_icons_nullsafty/flutter_icons_nullsafty.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/app_config.dart';
import 'package:kryptonia/helpers/colors.dart';
import 'package:kryptonia/helpers/strings.dart';

import 'package:kryptonia/pages/sign_up_screen.dart';
import 'package:kryptonia/widgets/cust_button.dart';
import 'package:kryptonia/widgets/cust_prog_ind.dart';
import 'package:kryptonia/widgets/cust_text_field.dart';
import 'package:kryptonia/widgets/text_link.dart';
import 'package:kryptonia/widgets/trns_text.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  AllBackEnds _allBackEnds = AllBackEnds();

  bool _osbcure = true;
  bool _loading = false;
  bool _forgetPass = false;
  GlobalKey<FormState> _logKey = GlobalKey();
  String? _email, _password;
  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _loading,
      progressIndicator: CustProgIndicator(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
            child: SingleChildScrollView(
              child: Form(
                key: _logKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TrnsText(
                      title: "Sign in to ",
                      extra2: APP_NAME,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    TrnsText(title: "Email"),
                    CustTextField(
                      onChanged: (String? val) {
                        setState(() {
                          _email = val;
                        });
                      },
                      validator: emailValidate,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    !_forgetPass
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              TrnsText(title: "Password"),
                              CustTextField(
                                onChanged: (String? val) {
                                  setState(() {
                                    _password = val;
                                  });
                                },
                                validator: _forgetPass ? null : emptyValidate,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                obscureText: _osbcure,
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      this._osbcure = !this._osbcure;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(_osbcure
                                        ? Entypo.eye
                                        : Entypo.eye_with_line),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
                    SizedBox(height: 20),
                    CustButton(
                      onTap: signInFxn,
                      title: _forgetPass ? "Reset Password" : "Login",
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextLinkWid(
                          title: "Forgot Password",
                          onTap: () {
                            setState(() {
                              this._forgetPass = !this._forgetPass;
                            });
                          },
                        ),
                        TextLinkWid(
                          title: "Privacy Policy",
                          url: PRIVACY_POLICY_URL,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TrnsText(title: "Don't have an account? "),
                        TextLinkWid(
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SignUpScreen(),
                            ),
                          ),
                          title: "Sign Up",
                        ),
                      ],
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

  String? emptyValidate(String? value) {
    return _allBackEnds.validateEmpty(value, "Password", context);
  }

  String? emailValidate(value) {
    return _allBackEnds.validateEmail(value, context);
  }

  signInFxn() async {
    try {
      if (_logKey.currentState!.validate()) {
        setState(() {
          _loading = true;
        });
        _logKey.currentState!.save();
        if (_forgetPass) {
          await _allBackEnds.sqlforgetPassword(_email, context);
        } else
          await _allBackEnds
              .sqlSignIn(_email, _password, context)
              .then((value) async {
            if (value) {
              _allBackEnds.otpCheckFxn(() {
                Navigator.pushReplacementNamed(context, '/bottom-nav/');
              }, context);
            }
          });
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      _loading = false;
    });
  }
}

class SocialButtons extends StatelessWidget {
  const SocialButtons({
    Key? key,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  final IconData icon;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: transparent,
      highlightColor: transparent,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 30, 5, 10),
        child: CircleAvatar(
          backgroundColor: white,
          radius: 22,
          child: Icon(icon, size: 25),
        ),
      ),
    );
  }
}
