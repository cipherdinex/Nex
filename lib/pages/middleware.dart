import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/strings.dart';
import 'package:kryptonia/pages/bottom_nav_home.dart';
import 'package:kryptonia/pages/intro_screen.dart';
import 'package:kryptonia/pages/lock_screen.dart';
import 'package:kryptonia/pages/start_page.dart';
import 'package:kryptonia/utils/app_lifecycle.dart';

class AppMiddleWare extends StatelessWidget {
  const AppMiddleWare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AllBackEnds _allBackEnds = AllBackEnds();
    var userBx = Hive.box(USERS);
    var settingsBx = Hive.box(SETTINGS);

    bool seen = settingsBx.get('intro_seen') ?? false;

    if (userBx.isEmpty) {
      if (!seen) {
        return LifeCycleManager(child: OnBoardingPage());
      } else {
        return LifeCycleManager(child: StartPage());
      }
    } else {
      bool _blocked = _allBackEnds.getUser(BLOCKED) == 0 ? false : true;
      bool _verified = _allBackEnds.getUser(VERIFIED) == 0 ? false : true;
      int _sessionEnd = _allBackEnds.getUser(SESSION_END) * 1000;
      bool _sessionPast =
          DateTime.now().millisecondsSinceEpoch > _sessionEnd ? true : false;

      if (!_blocked && _verified && !_sessionPast) {
        bool _appLock = settingsBx.get(APP_LOCK) ?? false;

        if (_appLock) {
          return LockScreen();
        } else
          _allBackEnds.otpCheckFxn(() {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => LifeCycleManager(
                          child: BottomNavHome(),
                        )));
          }, context);
        return Container();
      } else {
        return LifeCycleManager(child: StartPage());
      }
    }
  }
}
