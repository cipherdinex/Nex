import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_nullsafty/flutter_icons_nullsafty.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/colors.dart';
import 'package:kryptonia/helpers/strings.dart';
import 'package:kryptonia/pages/bottom_nav_home.dart';
import 'package:kryptonia/utils/app_lifecycle.dart';

import 'package:kryptonia/utils/pass_code_utils.dart';
import 'package:kryptonia/widgets/trns_text.dart';
import 'package:ntp/ntp.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({Key? key}) : super(key: key);

  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  AllBackEnds _allBackends = AllBackEnds();
  static var settingsBx = Hive.box(SETTINGS);
  var passCode = settingsBx.get(PASSCODE);

  @override
  void initState() {
    runBioFxn();
    super.initState();
  }

  bool? bioStatus = false;
  String? bioType;

  Future<void> runBioFxn() async {
    bioStatus = await _allBackends.checkAvailability();
    bioType = await _allBackends.getAvailableBiometric();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/start_bg.png"),
        ),
      ),
      child: Scaffold(
        backgroundColor: transparent,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 100, 10, 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: logoutPopFxn,
                splashColor: transparent,
                highlightColor: transparent,
                child: Icon(
                  FontAwesome.sign_out,
                  color: white,
                  size: 35,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LockWid(
                    icon: Icons.password_outlined,
                    onTap: () async {
                      DateTime timeN = await NTP.now();
                      DateTime tryTime = DateTime.fromMillisecondsSinceEpoch(
                          (getLockFxn("timeTries") -
                              timeN.millisecondsSinceEpoch));

                      int minuteLeft = tryTime.minute + 1;

                      getLockFxn("lockTries") >= 4 &&
                              (getLockFxn("timeTries") -
                                      timeN.millisecondsSinceEpoch) >
                                  0
                          ? _allBackends.showSnacky(
                              minuteLeft == 1
                                  ? "Exceeded Limit, try in a minutes time"
                                  : 'Exceeded Limit, try after {Arg} minutes',
                              false,
                              context,
                              args: minuteLeft == 1
                                  ? {}
                                  : {'Arg': minuteLeft.toString()})
                          : showPassModal();
                    },
                  ),
                  SizedBox(width: 10),
                  if (bioStatus! && getFxn(BIOMETRICS))
                    LockWid(
                      icon: bioType == FACE
                          ? FlutterIcons.face_recognition_mco
                          : Entypo.fingerprint,
                      onTap: () {
                        _allBackends.authenticate().then((value) {
                          if (value!)
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => LifeCycleManager(
                                          child: BottomNavHome(),
                                        )));
                        });
                      },
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  showPassModal() async {
    DateTime timeNw = await NTP.now();

    if ((getLockFxn("timeTries") - timeNw.millisecondsSinceEpoch) < 0) {
      putFxn("lockTries", 0);
      int timeT = timeNw.add(Duration(minutes: 10)).millisecondsSinceEpoch;
      putFxn("timeTries", timeT);
    }
    _allBackends.showModalBar(
        context,
        Container(
          color: black,
          height: 700,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              TrnsText(
                title: "Enter Passcode",
                style: TextStyle(color: white),
              ),
              Container(
                height: 100,
                width: double.infinity,
                child: PassCodeUtils(
                  isLockScreen: true,
                  obscure: true,
                  onChanged: (String v) {},
                  onCompleted: (String v) async {
                    if (v == passCode) {
                      Navigator.pop(context);
                      putFxn("lockTries", 0);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => LifeCycleManager(
                                    child: BottomNavHome(),
                                  )));
                    } else {
                      if (getLockFxn("lockTries") < 4) {
                        int lockTries = getLockFxn("lockTries");
                        int lockT = lockTries + 1;
                        DateTime timeNw = await NTP.now();

                        int timeT = timeNw
                            .add(Duration(minutes: 10))
                            .millisecondsSinceEpoch;
                        putFxn("lockTries", lockT);
                        putFxn("timeTries", timeT);
                      } else {
                        getLockFxn("lockTries");
                        Navigator.pop(context);
                      }
                    }
                  },
                  validator: (v) {
                    if (v!.length < 6) {
                      return "Invalid Code Length";
                    } else if (v != passCode) {
                      return "Wrong Passcode";
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }

  logoutPopFxn() {
    _allBackends
        .showPopUp(context, TrnsText(title: 'You are about to Log Out'), [
      CupertinoButton(
        child: TrnsText(title: 'Log Out'),
        onPressed: () => _allBackends.sqlSignOut(context),
      ),
      CupertinoButton(
        child: TrnsText(title: 'Cancel'),
        onPressed: () => Navigator.pop(context),
      ),
    ], [
      TextButton(
        child: TrnsText(title: 'Log Out'),
        onPressed: () => _allBackends.sqlSignOut(context),
      ),
      TextButton(
        child: TrnsText(title: 'Cancel'),
        onPressed: () => Navigator.pop(context),
      ),
    ]);
  }

  getFxn(lckTxn) {
    return settingsBx.get(lckTxn) ?? false;
  }

  putFxn(lckTxn, value) {
    settingsBx.put(lckTxn, value);
  }

  getLockFxn(lckTxn) {
    return settingsBx.get(lckTxn) ?? 0;
  }
}

class LockWid extends StatelessWidget {
  const LockWid({
    Key? key,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: transparent,
      highlightColor: transparent,
      child: CircleAvatar(
        radius: 35,
        backgroundColor: white,
        child: CircleAvatar(
          radius: 32,
          backgroundColor: black,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: white,
            child: Icon(
              icon,
              color: black,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
