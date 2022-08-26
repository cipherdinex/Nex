import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_nullsafty/flutter_icons_nullsafty.dart';
import 'package:kryptonia/helpers/colors.dart';
import 'package:kryptonia/helpers/strings.dart';
import 'package:kryptonia/utils/price_chart.dart';

class AllCoinsWid extends StatelessWidget {
  const AllCoinsWid({
    Key? key,
    required this.data,
    required this.item,
    required this.currency,
  }) : super(key: key);

  final List<int> data;
  final List item;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, int i) {
        return Container(
          height: 100,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
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
                          CachedNetworkImageProvider(item[i][IMAGE]),
                    ),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item[i][SYMBOL].toUpperCase(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          width: 80,
                          child: Text(
                            item[i][NAME],
                            style: TextStyle(
                              fontSize: 12,
                            ),
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
                    sparkline: item[i][SPARKLINE_IN_7D],
                    color:
                        item[i][PRICE_CHANGE_PERCENTAGE_24H] < 0 ? red : green,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "$currency ${item[i][CURRENT_PRICE].toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          item[i][PRICE_CHANGE_PERCENTAGE_24H] < 0
                              ? Feather.arrow_down
                              : Feather.arrow_up,
                          color: item[i][PRICE_CHANGE_PERCENTAGE_24H] < 0
                              ? red
                              : green,
                          size: 18,
                        ),
                        Text(
                          "${item[i][PRICE_CHANGE_PERCENTAGE_24H].abs().toStringAsFixed(2)}%",
                          style: TextStyle(
                            fontSize: 14,
                            color: item[i][PRICE_CHANGE_PERCENTAGE_24H] < 0
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
    );
  }
}
