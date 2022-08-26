import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

class LifeCycleManager extends StatefulWidget {
  final Widget? child;
  LifeCycleManager({Key? key, this.child}) : super(key: key);

  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {
  AppLifecycleState? _view;
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setStateIfMounted(() {
      _view = state;
    });

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _keepAlive(false);
    } else {
      _keepAlive(true);
    }
  }

  void setStateIfMounted(f) {
    if (this.mounted) setState(f);
  }

  static const _inactivityTimeout = Duration(minutes: 5);
  Timer? _keepAliveTimer;

  void _keepAlive(bool visible) {
    _keepAliveTimer?.cancel();
    if (visible) {
      _keepAliveTimer = null;
    } else {
      _keepAliveTimer = Timer(_inactivityTimeout, () => exit(0));
    }
  }

  /// Must be called only when app is visible, and exactly once
  void startKeepAlive() {
    assert(_keepAliveTimer == null);
    _keepAlive(true);
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    if (_view == AppLifecycleState.inactive ||
        _view == AppLifecycleState.paused) {
      return Container(
        child: Center(
            child: Container(
                height: 200,
                child: Image.asset(
                  'assets/icon/logo.png',
                  fit: BoxFit.contain,
                ))),
      );
    } else {
      return Container(
        child: widget.child,
      );
    }
  }
}
