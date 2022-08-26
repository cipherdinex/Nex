import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kryptonia/backends/all_backends.dart';

import 'package:kryptonia/helpers/colors.dart';
import 'package:kryptonia/helpers/strings.dart';

import 'package:kryptonia/utils/carousel.dart';
import 'package:kryptonia/widgets/cust_scaf_wid.dart';
import 'package:kryptonia/widgets/cust_shimmer.dart';
import 'package:kryptonia/widgets/news_wid.dart';
import 'package:kryptonia/widgets/text_header_wid.dart';
import 'package:kryptonia/widgets/text_link.dart';
import 'package:kryptonia/widgets/trns_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var settingsBx = Hive.box(SETTINGS);
  var crypD = Hive.box(CRYPTO_DATAS);

  AllBackEnds _allBackEnds = AllBackEnds();

  Future<List>? moversDatas;
  Future<List>? carouselDatas;
  final Map rates = {};

  @override
  void initState() {
    getVersion();
    refreshPrices();
    streamNotification();
    super.initState();
  }

  //! Refresh Prices
  refreshPrices() {
    _allBackEnds.cronJob(initFxn, 5);
  }

  getVersion() async {
    String version = await _allBackEnds.getAppVersion();
    settingsBx.put(VERSION, version);
  }

  //! Init Prices
  initFxn() async {
    moversDatas = _allBackEnds.getCryptoMovers();
    carouselDatas = _allBackEnds.getCryptoCarousel();
    await carouselDatas!.then((value) {
      for (int i = 0; i < value.length; i++) {
        rates[value[i][SYMBOL]] = value[i][CURRENT_PRICE];
      }
      crypD.put(EX_RATES, rates);
    });
    await _allBackEnds.getAllBalances();

    setState(() {});
    return moversDatas;
  }

  //! Get base Currency
  String currency() {
    return settingsBx.get(CURRENCY) ?? "usd";
  }

//! Notification
  streamNotification() {
    _allBackEnds.streamEvents();
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return CustScafWid(
      onRefresh: () => initFxn(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          priceToday(),
          SizedBox(height: 10),
          topMovers(context),
          SizedBox(height: 10),
          rewardsWid(context),
          SizedBox(height: 10),
          newsWid(med, context, _allBackEnds.getCryptoNews()),
        ],
      ),
    );
  }

  Widget priceToday() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextHeaderWid(
              title: 'Price Today',
            ),
            TextLinkWid(
              title: "View All",
              size: 16,
              onTap: () => Navigator.pushNamed(context, '/all-coins/'),
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          height: 120,
          width: double.infinity,
          child: ProfileCarousel(
            dt: carouselDatas,
          ),
        ),
      ],
    );
  }

  getMovers() {
    return FutureBuilder<List>(
        future: moversDatas,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, int i) {
                  return CustShimmer(type: 3);
                },
              ),
            );
          } else {
            return Container(
              height: 200,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, int i) {
                    var item = snapshot.data![i];
                    return Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: transparent,
                              backgroundImage:
                                  CachedNetworkImageProvider(item[IMAGE]),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Text(
                                  item[SYMBOL].toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  currency().toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color!
                                          .withOpacity(0.5)),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "${item[CURRENT_PRICE].toStringAsFixed(4)}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color!
                                          .withOpacity(0.5)),
                                ),
                              ],
                            ),
                            Text(
                              item[NAME],
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              item[PRICE_CHANGE_PERCENTAGE_24H] < 0
                                  ? "-"
                                      "${item[PRICE_CHANGE_PERCENTAGE_24H].abs().toStringAsFixed(2)}%"
                                  : "+"
                                      "${item[PRICE_CHANGE_PERCENTAGE_24H].abs().toStringAsFixed(2)}%",
                              style: TextStyle(
                                fontSize: 25,
                                color: item[PRICE_CHANGE_PERCENTAGE_24H] < 0
                                    ? red
                                    : green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            );
          }
        });
  }

  Widget topMovers(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextHeaderWid(
          title: "Top Movers",
        ),
        SizedBox(height: 10),
        getMovers(),
      ],
    );
  }

  Widget rewardsWid(context) {
    double exchRate = rates[USDT] ?? 0;
    double exRate = (exchRate * REFBONUS);
    String curr = currency().toUpperCase();

    String refCode = _allBackEnds.getUser(REFCODE);
    String refBalance = _allBackEnds.getUser(REFBALANCE);
    int refCCount = _allBackEnds.getUser(REFCONFIRMCOUNT);
    int refUCount = _allBackEnds.getUser(REFUNCONFIRMCOUNT);

    Map data = {
      RATE: exRate,
      CURRENCY: curr,
      REFCODE: refCode,
      REFBALANCE: refBalance,
      REFCONFIRMCOUNT: refCCount,
      REFUNCONFIRMCOUNT: refUCount,
    };
    String newData = jsonEncode(data);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextHeaderWid(
          title: 'Reward',
        ),
        SizedBox(height: 10),
        InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            '/rewards/$newData/',
          ),
          child: Container(
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SvgPicture.asset(
                    "assets/svg/refer.svg",
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TrnsText(
                        title: "Earn Rewards",
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TrnsText(
                        title:
                            "Invite a friend to {Arg1} and you will get {Arg2}",
                        args: {
                          "Arg1": APP_NAME,
                          "Arg2": curr + " " + exRate.toStringAsFixed(2),
                        },
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget newsWid(med, context, future) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextHeaderWid(
              title: "News Latest",
            ),
            TextLinkWid(
              title: "View All",
              size: 16,
              onTap: () => Navigator.pushNamed(context, '/news-latest/'),
            ),
          ],
        ),
        SizedBox(height: 10),
        FutureBuilder<List?>(
            future: future,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return CustShimmer(type: 4);
              } else {
                var dts = snapshot.data;
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, int index) {
                    return NewsWid(
                      data: dts![index],
                    );
                  },
                  itemCount: 5,
                );
              }
            })
      ],
    );
  }
}
