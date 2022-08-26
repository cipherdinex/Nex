import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons_nullsafty/flutter_icons_nullsafty.dart';

import 'package:kryptonia/backends/all_backends.dart';

import 'package:kryptonia/helpers/strings.dart';

import 'package:kryptonia/widgets/cust_shimmer.dart';
import 'package:kryptonia/widgets/empty.dart';
import 'package:kryptonia/widgets/history_wid.dart';
import 'package:kryptonia/widgets/k_header.dart';
import 'package:kryptonia/widgets/lazy_load_wid.dart';
import 'package:kryptonia/widgets/trns_text.dart';

class CoinHistoryScreen extends StatefulWidget {
  final String? data;
  const CoinHistoryScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _CoinHistoryScreenState createState() => _CoinHistoryScreenState();
}

class _CoinHistoryScreenState extends State<CoinHistoryScreen> {
  AllBackEnds _allBackends = AllBackEnds();

  List<int> lData = [];
  int currentLength = 0;

  final int increment = 10;
  bool isLoading = false;

  @override
  void initState() {
    _loadMore(true);

    super.initState();
  }

  Future _loadMore(bool isInit) async {
    setState(() {
      isLoading = true;
    });
    await Future.delayed(Duration(seconds: isInit ? 0 : 2));
    for (var i = currentLength; i <= currentLength + increment; i++) {
      lData.add(i);
    }
    setState(() {
      isLoading = false;
      currentLength = lData.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map dts = jsonDecode(widget.data!);

    bool isEth = dts[UNIT] == ETH ? true : false;
    return KHeader(
      title: ["History"],
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: null,
            onPressed: () => Navigator.pushNamed(context, '/send-coin/'),
            label: Row(
              children: [
                Icon(
                  Entypo.arrow_up,
                  size: 20,
                ),
                SizedBox(width: 5),
                TrnsText(
                  title: "Send",
                ),
              ],
            ),
            elevation: 0,
          ),
          SizedBox(width: 10),
          FloatingActionButton.extended(
            heroTag: null,
            onPressed: () => Navigator.pushNamed(context, '/receive-coin/'),
            label: Row(
              children: [
                Icon(
                  Entypo.arrow_down,
                  size: 20,
                ),
                SizedBox(width: 5),
                TrnsText(
                  title: "Receive {Arg}",
                  args: {"Arg": ""},
                ),
              ],
            ),
            elevation: 0,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: FutureBuilder<List>(
              future: dts[ERC20]
                  ? _allBackends.getAccTokenHistory(
                      dts[ADDRESS],
                      dts[UNIT],
                      isEth,
                    )
                  : _allBackends.getWalletHistory(dts[WALLETID]),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: 15,
                    itemBuilder: (context, int index) {
                      return CustShimmer(type: 7);
                    },
                  );
                } else {
                  var historyData = snapshot.data;
                  if (historyData!.isEmpty) {
                    return EmptyWid(
                      svg: 'empty',
                      title: "It's Empty Here",
                      subtitle: "Get busy, carry out some transactions",
                    );
                  } else
                    return LazyLoadWid(
                      isLoading: isLoading,
                      data: historyData,
                      lData: lData,
                      onEndOfPage: () => _loadMore(false),
                      itemBuilder: (context, int index) {
                        return HistoryWid(
                          data: historyData[index],
                          unit: dts[UNIT],
                        );
                      },
                    );
                }
              }),
        ),
      ),
    );
  }
}
