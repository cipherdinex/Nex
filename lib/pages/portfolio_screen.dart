import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kryptonia/backends/all_backends.dart';

import 'package:kryptonia/helpers/strings.dart';

import 'package:kryptonia/utils/asset_pie_chart.dart';
import 'package:kryptonia/widgets/cust_scaf_wid.dart';
import 'package:kryptonia/widgets/trns_text.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AllBackEnds _allBackends = AllBackEnds();

    var settingsBx = Hive.box(SETTINGS);
    var userBox = Hive.box(USERS);

    getHive(String key) {
      return settingsBx.get(key);
    }

    var crypD = Hive.box(CRYPTO_DATAS);
    Map? rates = crypD.get(EX_RATES) ?? {};
    Map? balances = crypD.get(BALANCES) ?? {};

    String currency = getHive(CURRENCY) ?? "usd";
    bool privacyMode = getHive(PRIVACY_MODE) ?? false;

    Map? totaBalances = {};
    var allBalances;

    double? getVal() {
      double portfolioBal = 0.0;

      for (String unit in UNITS) {
        double? val = balances![unit] != null
            ? (balances[unit] * (rates![unit] ?? 0))
            : 0;
        totaBalances[unit] = val;
      }
      allBalances = totaBalances.values;
      portfolioBal = allBalances.reduce((sum, element) => sum + element);

      return portfolioBal;
    }

    return CustScafWid(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TrnsText(
          title: "Portfolio balance",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color:
                Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.5),
          ),
        ),
        Text(
          privacyMode
              ? currency.toUpperCase() + " •••••"
              : currency.toUpperCase() + " " + getVal()!.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        AssetPieChart(
          balances: balances,
        ),
        ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, int index) {
            bool erc20 = ERC20LIST.contains(UNITS[index]) ? true : false;

            String? _walletId;
            String _address;
            if (!erc20) {
              String _encryptedWallet =
                  userBox.get(USER)[WALLET][UNITS[index] + '_' + WALLETID];
              _walletId = _allBackends.decrypt(_encryptedWallet);

              String _encryptedAdd =
                  userBox.get(USER)[WALLET][UNITS[index] + '_' + ADDRESS];

              _address = _allBackends.decrypt(_encryptedAdd);
            } else {
              String _encryptedAdd =
                  userBox.get(USER)[WALLET][ERC20 + '_' + ADDRESS];

              _address = _allBackends.decrypt(_encryptedAdd);
            }

            Map data = {
              WALLETID: _walletId,
              ADDRESS: _address,
              UNIT: UNITS[index],
              ERC20: erc20,
            };

            String name = CRYPTOCURRENCIES[index];

            return CoinWid(
              svg: CRYPTOCURRENCIES[index],
              name: name.capitalize()!,
              unit: UNITS[index].toUpperCase(),
              value: balances != {} ? balances![UNITS[index]] : 0.0,
              rate: rates!,
              erc20: erc20,
              data: jsonEncode(data),
            );
          },
          itemCount: CRYPTOCURRENCIES.length,
        ),
      ],
    ));
  }
}

class CoinWid extends StatelessWidget {
  const CoinWid({
    Key? key,
    required this.name,
    required this.svg,
    required this.unit,
    required this.value,
    required this.rate,
    required this.erc20,
    this.data,
  }) : super(key: key);

  final String name;
  final String svg;
  final String unit;
  final double? value;
  final Map? rate;
  final bool erc20;
  final String? data;

  @override
  Widget build(BuildContext context) {
    var settingsBx = Hive.box(SETTINGS);

    getHive(String key) {
      return settingsBx.get(key);
    }

    String currency = getHive(CURRENCY) ?? "usd";
    bool privacyMode = getHive(PRIVACY_MODE) ?? false;

    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        '/coin-history/$data/',
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: SvgPicture.asset("assets/svg/$svg.svg"),
        ),
        title: Text(
          unit,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          name,
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              privacyMode
                  ? currency.toUpperCase() + " ••••"
                  : currency.toUpperCase() +
                      " " +
                      (value != null
                              ? ((rate![unit.toLowerCase()] ?? 0) * value)
                              : 0.0)
                          .toStringAsFixed(2),
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Text(
              privacyMode
                  ? "••••" + " $unit"
                  : (value != null ? (value!.toStringAsFixed(4)) : "0.0") +
                      " $unit",
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .color!
                    .withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
