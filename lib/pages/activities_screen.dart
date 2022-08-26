import 'package:flutter/material.dart';
import 'package:flutter_icons_nullsafty/flutter_icons_nullsafty.dart';
import 'package:intl/intl.dart';
import 'package:kryptonia/backends/all_backends.dart';
import 'package:kryptonia/helpers/strings.dart';
import 'package:kryptonia/widgets/activity_cont.dart';
import 'package:kryptonia/widgets/activity_wid.dart';
import 'package:kryptonia/widgets/cust_shimmer.dart';
import 'package:kryptonia/widgets/k_header.dart';
import 'package:kryptonia/widgets/lazy_load_wid.dart';

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({Key? key}) : super(key: key);

  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen>
    with SingleTickerProviderStateMixin {
  AllBackEnds _allBackEnds = AllBackEnds();

  TabController? _tabController;

  List<int> lData = [];
  int currentLength = 0;

  final int increment = 10;
  bool isLoading = false;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);

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
    Size med = MediaQuery.of(context).size;

    return KHeader(
        title: ['Activities'],
        body: Container(
          height: med.height,
          child: Column(
            children: [
              TabBar(
                labelColor: Theme.of(context).textTheme.bodyText1!.color,
                unselectedLabelColor:
                    Theme.of(context).textTheme.bodyText1!.color,
                tabs: [
                  Tab(text: _allBackEnds.translation(context, 'Account')),
                  Tab(text: _allBackEnds.translation(context, 'Device')),
                ],
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    activitiesList(med),
                    devicesList(med),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  activitiesList(med) {
    return FutureBuilder<List>(
        future: _allBackEnds.getUserActivitiesSql(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CustShimmer(type: 7);
          } else {
            var data = snapshot.data!;
            return LazyLoadWid(
              isLoading: isLoading,
              data: data,
              lData: lData,
              onEndOfPage: () => _loadMore(false),
              itemBuilder: (context, int index) {
                int type = data[index][TYPE];
                String activity = ACTIVITY_MAP[type][ACTIVITY];
                String message = ACTIVITY_MAP[type][MESSAGE];

                String tDate = DateFormat("HH:mm - dd/MM/yyyy").format(
                    DateTime.fromMillisecondsSinceEpoch(
                        data[index][TIMESTAMP] * 1000));
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ActivtyCont(
                    icon: iconSwitch(type),
                    activity: activity,
                    message: message,
                    tDate: tDate,
                  ),
                );
              },
            );
          }
        });
  }

  devicesList(med) {
    return FutureBuilder<List>(
        future: _allBackEnds.getUserDeviceActivitiesSql(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CustShimmer(type: 7);
          } else {
            var data = snapshot.data!;
            return LazyLoadWid(
              isLoading: isLoading,
              data: data,
              lData: lData,
              onEndOfPage: () => _loadMore(false),
              itemBuilder: (context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    height: 170,
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          data[index][DEVICENAME],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ActivityWid(
                          title: "Ip",
                          value: data[index][IP],
                        ),
                        ActivityWid(
                          title: "Location",
                          value: data[index][LOCATION],
                        ),
                        ActivityWid(
                          title: "Country",
                          value: data[index][COUNTRY],
                        ),
                        ActivityWid(
                          title: "Date",
                          value: DateFormat.yMEd()
                              .add_jms()
                              .format(DateTime.fromMillisecondsSinceEpoch(
                                  data[index][TIMESTAMP] * 1000))
                              .toString(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        });
  }

  iconSwitch(int type) {
    switch (type) {
      case 0:
        return Icon(Entypo.login);
      case 1:
        return Icon(Octicons.sign_in);
      case 2:
        return Icon(Icons.password);
      case 3:
        return Icon(Icons.password);
      case 4:
        return Icon(Entypo.swap);
      case 5:
        return Icon(Entypo.arrow_up);
      case 6:
        return Icon(Entypo.arrow_down);
      case 7:
        return Icon(Entypo.arrow_up);
      case 8:
        return Icon(Entypo.arrow_down);
      case 9:
        return Icon(Icons.hide_source);
      case 10:
        return Icon(Icons.circle);
      case 11:
        return Icon(AntDesign.profile);
      case 12:
        return Icon(Icons.people_alt_outlined);
      default:
    }
  }
}
