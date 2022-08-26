import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_nullsafty/flutter_icons_nullsafty.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:kryptonia/helpers/colors.dart';
import 'package:kryptonia/helpers/strings.dart';
import 'package:kryptonia/utils/price_chart.dart';
import 'package:kryptonia/widgets/cust_shimmer.dart';

class ProfileCarousel extends StatefulWidget {
  ProfileCarousel({
    required this.dt,
  });
  final Future<List>? dt;
  @override
  State<StatefulWidget> createState() {
    return _ProfileCarouselState();
  }
}

class _ProfileCarouselState extends State<ProfileCarousel> {
  int _current = 0;
  var crypD = Hive.box(CRYPTO_DATAS);
  var settingsBx = Hive.box(SETTINGS);
  String getCurrency() {
    return settingsBx.get(CURRENCY) ?? "usd";
  }

  Widget interateGet() {
    return FutureBuilder<List>(
        future: widget.dt,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Container(
              height: 100,
              child: CustShimmer(
                type: 1,
              ),
            );
          } else {
            return CarouselSlider.builder(
              itemCount: CRYPTOCURRENCIES.length,
              itemBuilder: (context, i, int) {
                var item = snapshot.data![i];
                return Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(),
                  ),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: transparent,
                              backgroundImage:
                                  CachedNetworkImageProvider(item[IMAGE]),
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item[SYMBOL].toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  item[NAME],
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          height: 50,
                          width: 100,
                          child: PriceChart(
                            sparkline: item[SPARKLINE_IN_7D],
                            color: item[PRICE_CHANGE_PERCENTAGE_24H] < 0
                                ? red
                                : green,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Text(
                                "${getCurrency().toUpperCase()} ${item[CURRENT_PRICE].toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  item[PRICE_CHANGE_PERCENTAGE_24H] < 0
                                      ? Feather.arrow_down
                                      : Feather.arrow_up,
                                  color: item[PRICE_CHANGE_PERCENTAGE_24H] < 0
                                      ? red
                                      : green,
                                  size: 18,
                                ),
                                Text(
                                  "${item[PRICE_CHANGE_PERCENTAGE_24H].abs().toStringAsFixed(2)}%",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: item[PRICE_CHANGE_PERCENTAGE_24H] < 0
                                        ? red
                                        : green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                  height: 100,
                  viewportFraction: 1,
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            interateGet(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: CRYPTOCURRENCIES.map((count) {
                  int index = CRYPTOCURRENCIES.indexOf(count);
                  return Container(
                    width: _current == index ? 12 : 8.0,
                    height: _current == index ? 12 : 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? Theme.of(context).primaryColor
                          : accentColor,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
