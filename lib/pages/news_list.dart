import 'package:flutter/material.dart';
import 'package:kryptonia/backends/all_backends.dart';

import 'package:kryptonia/widgets/cust_shimmer.dart';
import 'package:kryptonia/widgets/k_header.dart';
import 'package:kryptonia/widgets/lazy_load_wid.dart';
import 'package:kryptonia/widgets/news_wid.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({
    Key? key,
  }) : super(key: key);

  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
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

  @override
  Widget build(BuildContext context) {
    return KHeader(
        title: ["News Latest"],
        body: FutureBuilder<List?>(
            future: _allBackEnds.getCryptoNews(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return CustShimmer(type: 4);
              } else {
                var dts = snapshot.data;

                return LazyLoadWid(
                  isLoading: isLoading,
                  data: dts!,
                  lData: data,
                  onEndOfPage: () => _loadMore(false),
                  itemBuilder: (context, int index) {
                    return NewsWid(
                      data: dts[index],
                    );
                  },
                );
              }
            }));
  }
}
