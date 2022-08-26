import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_nullsafty/flutter_icons_nullsafty.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/strings.dart';
import 'package:kryptonia/utils/provider_controllers.dart';
import 'package:kryptonia/widgets/k_header.dart';
import 'package:kryptonia/widgets/pref_wid.dart';
import 'package:provider/provider.dart';

class PreferenceScreen extends StatefulWidget {
  const PreferenceScreen({Key? key}) : super(key: key);

  @override
  _PreferenceScreenState createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  int? selectedValue;
  String? currency;
  String? language;
  bool? _active = false;

//Theme
  static var settingsBx = Hive.box(SETTINGS);
  var themeBx = settingsBx.get(THEME);
  ProviderControllers themeType = ProviderControllers();

  @override
  void initState() {
    super.initState();
  }

  AllBackEnds _allBackEnds = AllBackEnds();

  putHive(String key, value) {
    settingsBx.put(key, value);
  }

  static String? getHiveFxn(String key) {
    return settingsBx.get(key);
  }

  String currentCurrency = getHiveFxn(CURRENCY) == null
      ? 'USD'
      : getHiveFxn(CURRENCY)!.toUpperCase();
  String currentLanguage = getHiveFxn(LANGUAGE) == null
      ? ENGLISH.toUpperCase()
      : getHiveFxn(LANGUAGE)!.toUpperCase();
  @override
  Widget build(BuildContext context) {
    return KHeader(
      title: ["Preferences"],
      body: Column(
        children: [
          SizedBox(height: 10),
          PreferenceWid(
            icon: FlutterIcons.theme_light_dark_mco,
            title: "Theme",
            trailing: _allBackEnds.toggleSwitch(_active!, context, (bool val) {
              setState(() {
                Provider.of<ProviderControllers>(context, listen: false)
                    .switchTheme();
                _active = val;
              });
            }),
          ),
          PreferenceWid(
            icon: MaterialCommunityIcons.home_currency_usd,
            title: "Currency",
            trailing: currency == null
                ? Text(currentCurrency, style: TextStyle())
                : Text(currency!.toUpperCase(), style: TextStyle()),
            onTap: () => _allBackEnds.showPicker(
              context,
              children: CURRENCIES,
              onSelectedItemChanged: (value) {
                setState(() {
                  selectedValue = value;
                  currency = CURRENCIES[value!];
                  putHive(CURRENCY, currency);
                });
              },
              onChanged: (String? val) {
                setState(() {
                  currency = val;
                  putHive(CURRENCY, currency);
                  Navigator.pop(context);
                });

                Navigator.pop(context);
              },
              hasTrns: false,
            ),
          ),
          PreferenceWid(
            icon: MaterialCommunityIcons.earth,
            title: "Language",
            onTap: () => _allBackEnds.showPicker(context, children: LANGUAGES,
                onSelectedItemChanged: (value) {
              setState(() {
                selectedValue = value;
                language = LANGUAGES[value!];

                Provider.of<ProviderControllers>(context, listen: false)
                    .setLocale(value);
                putHive(LANGUAGE, language);
              });
            }, onChanged: (String? val) {
              setState(() {
                language = val;
                putHive(LANGUAGE, language);
                Provider.of<ProviderControllers>(context, listen: false)
                    .setLocale(LANGUAGES.indexOf(val));
              });
              Navigator.pop(context);
            }),
            trailing: language == null
                ? Text(currentLanguage.toUpperCase())
                : Text(
                    _allBackEnds.translation(context, language!).toUpperCase()),
          ),
        ],
      ),
    );
  }
}
