import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_nullsafty/flutter_icons_nullsafty.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/strings.dart';

import 'package:kryptonia/utils/pass_code_utils.dart';
import 'package:kryptonia/widgets/k_header.dart';
import 'package:kryptonia/widgets/pref_wid.dart';
import 'package:kryptonia/widgets/trns_text.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  _SecurityScreenState createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  AllBackEnds _allBackEnds = AllBackEnds();

  var settingsBx = Hive.box(SETTINGS);

  putHive(String key, value) {
    settingsBx.put(key, value);
  }

  getHiveFxn(String key) {
    return settingsBx.get(key);
  }

  int index = 0;
  String currentVal = "", newVal = "";

  @override
  void initState() {
    runBioFxn();
    super.initState();
  }

  bool? bioStatus = false;
  String? bioType;

  Future<void> runBioFxn() async {
    bioStatus = await _allBackEnds.checkAvailability();
    bioType = await _allBackEnds.getAvailableBiometric();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool _appLock = getHiveFxn(APP_LOCK) ?? false;
    bool _privacyMode = getHiveFxn(PRIVACY_MODE) ?? false;
    bool _biometrics = getHiveFxn(BIOMETRICS) ?? false;
    bool _trxnSigning = getHiveFxn(TRXN_SIGNING) ?? false;

    Size med = MediaQuery.of(context).size;
    return KHeader(
      title: ["Security"],
      body: Column(
        children: [
          PreferenceWid(
            icon: AntDesign.lock,
            title: "App Lock",
            subtitle: ["Require Authentication"],
            trailing: _allBackEnds.toggleSwitch(
              _appLock,
              context,
              (bool val) async {
                setState(() {
                  index = 0;
                });
                await showModalBS(med, _appLock, val);
              },
            ),
          ),
          PreferenceWid(
            icon: Icons.hide_source,
            title: "Privacy Mode",
            subtitle: ["Hide Portfolio Balance"],
            trailing: _allBackEnds.toggleSwitch(
              _privacyMode,
              context,
              (bool val) async {
                setState(() {
                  putHive(PRIVACY_MODE, val);
                });
              },
            ),
          ),
          PreferenceWid(
            icon: Feather.shield,
            title: "2 Factor Auth",
            subtitle: ["Google", "SMS", "Email"],
            trailing: Icon(CupertinoIcons.forward, size: 15),
            onTap: () => Navigator.pushNamed(context, '/two-fa/'),
          ),
          if (_appLock)
            Column(
              children: [
                if (bioStatus!)
                  PreferenceWid(
                    icon: bioType == TOUCHID
                        ? Entypo.fingerprint
                        : FlutterIcons.face_recognition_mco,
                    title: "Biometrics",
                    subtitle: [
                      bioType == TOUCHID
                          ? "Unlock with Fingerprint"
                          : "Unlock with Face ID"
                    ],
                    trailing: _allBackEnds.toggleSwitch(
                      _biometrics,
                      context,
                      (bool val) {
                        setState(() {
                          putHive(BIOMETRICS, val);
                        });
                      },
                    ),
                  ),
                PreferenceWid(
                  icon: CupertinoIcons.signature,
                  title: "Transaction Signing",
                  subtitle: ["Authenticate transactions"],
                  trailing: _allBackEnds.toggleSwitch(
                    _trxnSigning,
                    context,
                    (bool val) {
                      setState(() {
                        putHive(TRXN_SIGNING, val);
                      });
                    },
                  ),
                ),
              ],
            ),
          PreferenceWid(
            icon: Feather.alert_triangle,
            title: "Account",
            subtitle: ["Edit password, or disable account"],
            trailing: Icon(CupertinoIcons.forward, size: 15),
            onTap: () => Navigator.pushNamed(context, '/account-security/'),
          ),
        ],
      ),
    );
  }

  showModalBS(med, bool active, bool val) {
    if (active) {
      _allBackEnds.showModalBar(context,
          StatefulBuilder(builder: (context, StateSetter state) {
        return Container(
          height: med.height * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              TrnsText(title: "Enter Passcode"),
              Container(
                height: 100,
                width: double.infinity,
                child: PassCodeUtils(
                  obscure: true,
                  onChanged: (String value) {
                    state(() {
                      currentVal = value;
                    });
                  },
                  onCompleted: (String v) {
                    if (currentVal == getHiveFxn(PASSCODE)) {
                      Navigator.pop(context);
                      putHive(APP_LOCK, val);
                      setState(() {});
                      _allBackEnds.showSnacky(
                          "App Lock Disabled", false, context);
                    }
                  },
                  validator: (v) {
                    if (v!.length < 6) {
                      return _allBackEnds.translation(
                          context, "Invalid Code Length");
                    } else if (currentVal != getHiveFxn(PASSCODE)) {
                      return _allBackEnds.translation(
                          context, "Wrong Passcode");
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ],
          ),
        );
      }));
    } else {
      _allBackEnds.showModalBar(context,
          StatefulBuilder(builder: (context, StateSetter state) {
        return Container(
          height: med.height * 0.7,
          child: IndexedStack(
            index: index,
            children: [
              Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TrnsText(title: "Enter New Passcode"),
                    Container(
                      height: 100,
                      width: double.infinity,
                      child: PassCodeUtils(
                        obscure: true,
                        onChanged: (String value) {
                          state(() {
                            currentVal = value;
                          });
                        },
                        onCompleted: (String v) {
                          state(() {
                            index++;
                          });
                        },
                        validator: (v) {
                          if (v!.length < 6) {
                            return _allBackEnds.translation(
                                context, "Invalid Code Length");
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TrnsText(title: "Re-enter Passcode"),
                    Container(
                      height: 100,
                      width: double.infinity,
                      child: PassCodeUtils(
                        obscure: true,
                        onCompleted: (String v) {
                          if (newVal == currentVal) {
                            Navigator.pop(context);
                            putHive(APP_LOCK, val);
                            putHive(PASSCODE, newVal);
                            setState(() {});
                            _allBackEnds.showSnacky(
                                "App Lock Enabled", true, context);
                          }
                        },
                        onChanged: (String value) {
                          state(() {
                            newVal = value;
                          });
                        },
                        validator: (v) {
                          if (v!.length < 6) {
                            return _allBackEnds.translation(
                                context, "Invalid Code Length");
                          } else if (newVal != currentVal) {
                            return _allBackEnds.translation(
                                context, "Passcodes don't match");
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }));
    }
  }
}
