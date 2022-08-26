import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_nullsafty/flutter_icons_nullsafty.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/app_config.dart';
import 'package:kryptonia/helpers/colors.dart';
import 'package:kryptonia/helpers/strings.dart';
import 'package:kryptonia/pages/sign_in.dart';
import 'package:kryptonia/widgets/cust_button.dart';
import 'package:kryptonia/widgets/cust_country.dart';
import 'package:kryptonia/widgets/cust_prog_ind.dart';
import 'package:kryptonia/widgets/cust_text_field.dart';
import 'package:kryptonia/widgets/text_link.dart';
import 'package:kryptonia/widgets/trns_text.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  AllBackEnds _allBackEnds = AllBackEnds();
  GlobalKey<FormState> _regKey = GlobalKey();

  String numberPrefix = DEFAULT_COUNTRY_PREFIX;
  bool? checkedValue = false;
  String? _fName,
      _lName,
      _email,
      _phone,
      _referralCode,
      _password,
      cPassword,
      _country;
  bool obscureText = true;
  bool _loading = false;

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
                key: _regKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TrnsText(
                      title: "Create Account",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    TrnsText(title: "First Name"),
                    CustTextField(
                      onChanged: (String? val) {
                        setState(() {
                          _fName = val;
                        });
                      },
                      validator: nameValidate,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 10),
                    TrnsText(title: "Last Name"),
                    CustTextField(
                      onChanged: (String? val) {
                        setState(() {
                          _lName = val;
                        });
                      },
                      validator: nameValidate,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
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
                    SizedBox(height: 10),
                    TrnsText(title: 'Phone'),
                    CustTextField(
                      onChanged: (String? val) {
                        setState(() {
                          _phone = val;
                        });
                      },
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      prefixIcon: CustCountryPicker(
                        onChanged: (val) {
                          setState(() {
                            numberPrefix = val.dialCode!;
                            _country = val.name;
                          });
                        },
                        onInit: (code) {
                          _country = code!.name;
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    TrnsText(title: "Referral Code"),
                    CustTextField(
                      onChanged: (String? val) {
                        setState(() {
                          _referralCode = val;
                        });
                      },
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 10),
                    TrnsText(title: "Password"),
                    CustTextField(
                      onChanged: (String? val) {
                        setState(() {
                          _password = val;
                        });
                      },
                      validator: passwordValidate,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      obscureText: obscureText,
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            this.obscureText = !this.obscureText;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            obscureText ? Entypo.eye : Entypo.eye_with_line,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TrnsText(title: "Confirm Password"),
                    CustTextField(
                      onChanged: (String? val) {
                        setState(() {
                          cPassword = val;
                        });
                      },
                      validator: validateCPassword,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      obscureText: obscureText,
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            this.obscureText = !this.obscureText;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            obscureText ? Entypo.eye : Entypo.eye_with_line,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    CheckboxListTile(
                      activeColor: accentColor,
                      title: Wrap(
                        children: [
                          TrnsText(
                              title:
                                  "I certify that I am 18 years of age or older, and I agree to the "),
                          TextLinkWid(
                            url: TERMS_URL,
                            title: "User Agreement",
                          ),
                          TrnsText(
                            extra1: ' ',
                            title: "and",
                            extra2: ' ',
                            style: TextStyle(fontSize: 14),
                          ),
                          TextLinkWid(
                            url: PRIVACY_POLICY_URL,
                            title: "Privacy Policy",
                          ),
                        ],
                      ),
                      value: checkedValue,
                      onChanged: (newValue) {
                        setState(() {
                          checkedValue = newValue;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    SizedBox(height: 10),
                    CustButton(
                      onTap: createAccount,
                      title: "Create Account",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TrnsText(
                          title: "Already have an account?",
                          extra2: ' ',
                        ),
                        TextLinkWid(
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SignInScreen(),
                            ),
                          ),
                          title: "Sign In",
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

  String? nameValidate(value) {
    return _allBackEnds.validateName(value, context);
  }

  String? emailValidate(value) {
    return _allBackEnds.validateEmail(value, context);
  }

  String? passwordValidate(value) {
    return _allBackEnds.validatePassword(value, context);
  }

  String? validateCPassword(String? value) {
    return _allBackEnds.validateCPassword(value, _password, context);
  }

  createAccount() async {
    try {
      if (checkedValue!) {
        if (_regKey.currentState!.validate()) {
          _regKey.currentState!.save();
          setState(() {
            _loading = true;
          });

          String phone = '$numberPrefix-${_phone ?? "0"}';
          Map res = await _allBackEnds.sqlSignUp(
            _email,
            _password,
            _fName,
            _lName,
            phone,
            _country,
            _referralCode == '' || _referralCode == null
                ? 'app'
                : _referralCode,
            context,
          );

          if (res[STATUS]) {
            _allBackEnds.showPopUp(
              context,
              TrnsText(title: res[MESSAGE]),
              [
                CupertinoButton(
                  child: TrnsText(title: "Ok"),
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SignInScreen(),
                    ),
                  ),
                )
              ],
              [
                TextButton(
                  child: TrnsText(title: "Ok"),
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SignInScreen(),
                    ),
                  ),
                )
              ],
              barrierDismissible: false,
            );
          }
        }
      } else {
        _allBackEnds.showSnacky("Accept to User Agreement", false, context);
      }
    } catch (e) {
      print(e);
      _allBackEnds.showSnacky(DEFAULT_ERROR, false, context);
    }
    setState(() {
      _loading = false;
    });
  }
}
