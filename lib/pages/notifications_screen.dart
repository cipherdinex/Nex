import 'package:flutter/material.dart';
import 'package:flutter_icons_nullsafty/flutter_icons_nullsafty.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/strings.dart';
import 'package:kryptonia/widgets/activity_cont.dart';

import 'package:kryptonia/widgets/cust_shimmer.dart';
import 'package:kryptonia/widgets/empty.dart';
import 'package:kryptonia/widgets/k_header.dart';
import 'package:kryptonia/widgets/lazy_load_wid.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  AllBackEnds _allBackEnds = AllBackEnds();
  var userBx = Hive.box(SETTINGS);

  List<int> lData = [];
  int currentLength = 0;

  final int increment = 10;
  bool isLoading = false;

  @override
  void initState() {
    _loadMore(true);
    userBx.put(NOTIFICATION, false);

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
    return KHeader(
      title: ["Notifications"],
      body: FutureBuilder<List>(
          future: _allBackEnds.getNotificationsSql(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CustShimmer(type: 7);
            } else if (snapshot.data!.isEmpty) {
              return EmptyWid(
                  title: "It's Empty Here",
                  subtitle: "Seems we haven't gotten any notification",
                  svg: 'empty');
            } else {
              var data = snapshot.data!;
              return LazyLoadWid(
                isLoading: isLoading,
                data: data,
                lData: lData,
                onEndOfPage: () => _loadMore(false),
                itemBuilder: (context, int index) {
                  int type = data[index][TYPE];
                  String title = data[index][TITLE];
                  String message = data[index][BODY];

                  String tDate = DateFormat("HH:mm - dd/MM/yyyy").format(
                      DateTime.fromMillisecondsSinceEpoch(
                          data[index][TIMESTAMP] * 1000));
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ActivtyCont(
                      isNoti: true,
                      icon: iconSwitch(type),
                      activity: title,
                      message: message,
                      tDate: tDate,
                    ),
                  );
                },
              );
            }
          }),
    );
  }

  iconSwitch(int type) {
    switch (type) {
      case 0:
        return Icon(AntDesign.linechart);
      case 1:
        return Icon(Entypo.info);
      case 2:
        return Icon(Entypo.wallet);
      default:
    }
  }
}
