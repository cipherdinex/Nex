import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_nullsafty/flutter_icons_nullsafty.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/colors.dart';

import 'package:kryptonia/pages/home_screen.dart';
import 'package:kryptonia/pages/portfolio_screen.dart';
import 'package:kryptonia/widgets/trns_text.dart';

class BottomNavHome extends StatefulWidget {
  @override
  _BottomNavHomeState createState() => _BottomNavHomeState();
}

class _BottomNavHomeState extends State<BottomNavHome> {
  int currentIndex = 0;

  onTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  List<Widget> tabs = [
    HomeScreen(),
    PortfolioScreen(),
  ];
  AllBackEnds _allBackends = AllBackEnds();

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.sync_alt),
            onPressed: () => showTransactionActions(),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: CupertinoTabScaffold(
              tabBar: CupertinoTabBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                activeColor: Theme.of(context).colorScheme.secondary,
                inactiveColor: Theme.of(context).hintColor,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(AntDesign.home),
                    label: _allBackends.translation(context, 'Home'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(AntDesign.piechart),
                    label: (_allBackends.translation(context, 'Portfolio')),
                  ),
                ],
              ),
              tabBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return HomeScreen();
                  case 1:
                    return PortfolioScreen();

                  default:
                    return HomeScreen();
                }
              }));
    } else
      return Container(
        child: WillPopScope(
          onWillPop: pop,
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => showTransactionActions(),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: IndexedStack(
              index: currentIndex,
              children: tabs,
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Theme.of(context).colorScheme.secondary,
              unselectedItemColor: Theme.of(context).hintColor,
              currentIndex: currentIndex,
              onTap: onTapped,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(AntDesign.home),
                  label: (_allBackends.translation(context, 'Home')),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.pie_chart),
                  label: (_allBackends.translation(context, 'Portfolio')),
                ),
              ],
            ),
          ),
        ),
      );
  }

  Future<bool> pop() async {
    return false;
  }

  showTransactionActions() {
    Platform.isIOS
        ? showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) => CupertinoActionSheet(
              actions: [
                CupertinoASA(
                  title: _allBackends
                      .multiTranslation(context, ["Buy", "Sell", "Crypto"])!,
                  route: '/buy-sell-coin/',
                ),
                CupertinoASA(
                  title: _allBackends.multiTranslation(
                    context,
                    ["Swap {Arg}", 'Crypto'],
                    args: {"Arg": ""},
                  )!,
                  route: "/swap-coin/",
                ),
                CupertinoASA(
                  title: _allBackends.multiTranslation(
                    context,
                    ['Receive {Arg}', 'Crypto'],
                    args: {"Arg": ""},
                  )!,
                  route: '/receive-coin/',
                ),
                CupertinoASA(
                  title: _allBackends
                      .multiTranslation(context, ['Send', 'Crypto'])!,
                  route: '/send-coin/',
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: TrnsText(title: 'Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          )
        : showModalBottomSheet(
            context: context,
            builder: (_) => Container(
                  height: 350,
                  child: Column(
                    children: [
                      ModalWid(
                        title: _allBackends.multiTranslation(
                            context, ["Buy", "Sell", "Crypto"]),
                        desc: "Buy or Sell Crypto via Card, Bank or Paypal",
                        icon: FlutterIcons.bank_faw,
                        isSend: false,
                        color: amber,
                        page: '/buy-sell-coin/',
                      ),
                      ModalWid(
                        title: _allBackends.multiTranslation(
                          context,
                          ["Swap {Arg}", 'Crypto'],
                          args: {"Arg": ""},
                        ),
                        desc: "Exchange one coin for another",
                        icon: FlutterIcons.bank_faw,
                        isSend: false,
                        color: amber,
                        page: '/swap-coin/',
                      ),
                      ModalWid(isSend: true),
                      ModalWid(isSend: false),
                    ],
                  ),
                ));
  }
}

class CupertinoASA extends StatelessWidget {
  const CupertinoASA({
    required this.route,
    required this.title,
  });

  final String title;
  final String route;

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheetAction(
      child: Text(title),
      onPressed: () => Navigator.pushNamed(context, route),
    );
  }
}

class ModalWid extends StatelessWidget {
  const ModalWid({
    Key? key,
    this.desc,
    this.icon,
    this.page,
    this.title,
    this.isSend,
    this.color,
  }) : super(key: key);

  final bool? isSend;
  final IconData? icon;
  final String? page;
  final String? title;
  final String? desc;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    AllBackEnds _allBackends = AllBackEnds();

    return InkWell(
      onTap: () => Navigator.pushNamed(
          context,
          page != null
              ? '$page'
              : isSend!
                  ? '/send-coin/'
                  : '/receive-coin/'),
      child: ListTile(
        leading: Icon(
          icon != null
              ? icon
              : isSend!
                  ? Entypo.arrow_up
                  : Entypo.arrow_down,
          color: color != null
              ? color
              : isSend!
                  ? red
                  : green,
        ),
        title: title != null
            ? Text(title!)
            : Text(isSend!
                ? _allBackends.multiTranslation(context, ['Send', 'Crypto'])!
                : _allBackends.multiTranslation(
                    context,
                    ['Receive {Arg}', 'Crypto'],
                    args: {"Arg": ""},
                  )!),
        subtitle: desc != null
            ? TrnsText(title: desc!)
            : TrnsText(
                title: isSend!
                    ? "Send Crypto to another wallet"
                    : "Receive Crypto from another wallet"),
      ),
    );
  }
}
