import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/strings.dart';
import 'package:kryptonia/widgets/all_coins_wid.dart';
import 'package:kryptonia/widgets/cust_prog_ind.dart';
import 'package:kryptonia/widgets/cust_shimmer.dart';
import 'package:kryptonia/widgets/k_header.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class CoinsListScreen extends StatefulWidget {
  const CoinsListScreen({Key? key}) : super(key: key);

  @override
  _CoinsListScreenState createState() => _CoinsListScreenState();
}

class _CoinsListScreenState extends State<CoinsListScreen> {
  AllBackEnds _allBackEnds = AllBackEnds();

  List<int> data = [];
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
      data.add(i);
    }
    setState(() {
      isLoading = false;
      currentLength = data.length;
    });
  }

  var settingsBx = Hive.box(SETTINGS);
  String getCurrency() {
    return settingsBx.get(CURRENCY) ?? "usd";
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return KHeader(
      title: ["All Coins"],
      body: FutureBuilder<List?>(
          future: _allBackEnds.getAllDatas(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return CustShimmer(type: 2);
            } else {
              List item = snapshot.data!;
              return Column(
                children: [
                  LazyLoadScrollView(
                    isLoading: isLoading,
                    onEndOfPage: () => _loadMore(false),
                    child: Container(
                        height: med.height * 0.82,
                        child: AllCoinsWid(
                          data: data,
                          item: item,
                          currency: getCurrency().toUpperCase(),
                        )),
                  ),
                  isLoading ? CustProgIndicator() : SizedBox.shrink(),
                ],
              );
            }
          }),
    );
  }
}
