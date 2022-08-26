import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kryptonia/helpers/strings.dart';

class ProviderControllers with ChangeNotifier {
  static bool _isDark = true;
  static String? _locale = "en";
  var settingsBx = Hive.box(SETTINGS);

  ProviderControllers() {
    if (settingsBx.containsKey(THEME))
      _isDark = settingsBx.get(THEME);
    else
      settingsBx.put(THEME, _isDark);
  }

  ThemeMode currentTheme() {
    return getFxn(THEME, false) ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme() {
    _isDark = !_isDark;
    putFxn(THEME, _isDark);
    notifyListeners();
  }

  void onLanguageChange() async {
    await Future.delayed(Duration(milliseconds: 1000));
    notifyListeners();
  }

  setLocale(int languageCode) async {
    _locale = LANGUAGE_CODES[languageCode];
    putFxn("lang", _locale);
    notifyListeners();
  }

  String getLocale() {
    return getFxn("lang", "en");
  }

  getFxn(key, def) {
    return settingsBx.get(key) ?? def;
  }

  putFxn(key, value) {
    settingsBx.put(key, value);
  }
}
